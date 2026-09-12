"""Serve the time-reply showcase with controlled HTTP calibration responses."""

import argparse
import functools
import http.server
import json
import urllib.parse


class TimeFixtureHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        if self.path != "/fixture/time-mode":
            self.send_error(404)
            return
        mode = self.rfile.read(int(self.headers.get("Content-Length", "0"))).decode()
        if mode not in {"matched", "mismatch", "near-mismatch"}:
            self.send_error(400, "Unknown fixture mode")
            return
        self.server.mode = mode
        self.send_response(204)
        self.send_header("Cache-Control", "no-store")
        self.end_headers()

    def do_GET(self):
        request = urllib.parse.urlsplit(self.path)
        if request.path != "/api/public/time":
            return super().do_GET()
        try:
            sent = int(urllib.parse.parse_qs(request.query)["clientSentAtNanos"][0])
        except (KeyError, ValueError):
            self.send_error(400, "Missing client timestamp")
            return
        echo = sent
        mode = getattr(self.server, "mode", "matched")
        if mode == "mismatch":
            echo -= 60000000000
        elif mode == "near-mismatch":
            echo += 1
        payload = json.dumps({
            "clientSentAtNanos": str(echo),
            "serverReceivedAtNanos": str(sent + 2000000000),
            "serverSentAtNanos": str(sent + 2000000000),
        }).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8196)
    parser.add_argument("--directory", default="build/review/server-time")
    args = parser.parse_args()
    handler = functools.partial(TimeFixtureHandler, directory=args.directory)
    http.server.ThreadingHTTPServer(("127.0.0.1", args.port), handler).serve_forever()
