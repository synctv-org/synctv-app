# Chinese UI Font

`SyncTvUiCjk.ttf` is a subset of Noto Sans SC under the SIL Open Font License
in `OFL.txt`. The font retains its variable weight axis and covers printable
characters in `lib/l10n/app_zh.arb`. Other text can use Flutter's normal fallback.
Flutter Web loads this font from its asset manifest before running the app,
avoiding delayed external fallback downloads for Chinese interface labels.

Upstream: [google/fonts, Noto Sans SC](https://github.com/google/fonts/tree/a85815a42757630ce188fdad368c2dfc444d4773/ofl/notosanssc).
Source SHA-256: `a3041811a78c361b1de50f953c805e0244951c21c5bd412f7232ef0d899af0da`.
The generated subset uses the distinct family name `SyncTV UI CJK`.

Regenerate after adding characters to Chinese messages:

```sh
python3 -m venv build/font-tools
build/font-tools/bin/pip install fonttools==4.61.1
curl -fsSL 'https://raw.githubusercontent.com/google/fonts/a85815a42757630ce188fdad368c2dfc444d4773/ofl/notosanssc/NotoSansSC%5Bwght%5D.ttf' -o build/NotoSansSC.ttf
build/font-tools/bin/python tool/subset_ui_font.py --source build/NotoSansSC.ttf
build/font-tools/bin/python tool/subset_ui_font.py --check
```

CI checks the committed font's character map against localization messages.
Normal application builds use the committed subset and require no Python or
upstream font download. New user-generated characters are outside this subset's
coverage guarantee. The font's retained copyright and license metadata and the
bundled `OFL.txt` apply to redistribution of the font.
