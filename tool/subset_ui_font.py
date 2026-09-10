"""Generate or check the bundled Chinese UI font against localization messages."""

import argparse
import hashlib
import json
from pathlib import Path

from fontTools import subset
from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "assets/fonts/SyncTvUiCjk.ttf"
SOURCE_SHA256 = "a3041811a78c361b1de50f953c805e0244951c21c5bd412f7232ef0d899af0da"


def ui_codepoints():
    messages = json.loads(
        (ROOT / "lib/l10n/app_zh.arb").read_text(encoding="utf-8")
    )
    return {
        ord(char)
        for key, message in messages.items()
        if not key.startswith("@") and isinstance(message, str)
        for char in message
        if char.isprintable()
    }


def check_coverage(font, codepoints):
    missing = codepoints - font.getBestCmap().keys()
    if missing:
        formatted = ", ".join(f"U+{value:04X}" for value in sorted(missing))
        raise SystemExit(f"UI font is missing {formatted}; regenerate the subset.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--source", type=Path, help="Pinned upstream variable TTF")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    codepoints = ui_codepoints()
    if args.check:
        with TTFont(OUTPUT) as font:
            check_coverage(font, codepoints)
        print(f"UI font covers {len(codepoints)} localization codepoints.")
        return

    if hashlib.sha256(args.source.read_bytes()).hexdigest() != SOURCE_SHA256:
        raise SystemExit("Unexpected upstream font checksum.")
    with TTFont(args.source, recalcTimestamp=False) as font:
        check_coverage(font, codepoints)
        options = subset.Options()
        options.name_IDs = ["*"]
        options.name_legacy = True
        options.name_languages = ["*"]
        subsetter = subset.Subsetter(options=options)
        subsetter.populate(unicodes=codepoints)
        subsetter.subset(font)
        # Identify this modified subset while preserving upstream license records.
        names = {1: "SyncTV UI CJK", 2: "Regular", 3: "SyncTV UI CJK subset",
                 4: "SyncTV UI CJK", 6: "SyncTVUiCjk", 16: "SyncTV UI CJK"}
        for entry in font["name"].names:
            if entry.nameID in names:
                entry.string = names[entry.nameID].encode(entry.getEncoding())
        OUTPUT.parent.mkdir(parents=True, exist_ok=True)
        font.save(OUTPUT)
    print(f"Generated {OUTPUT.name}: {OUTPUT.stat().st_size} bytes.")


if __name__ == "__main__":
    main()
