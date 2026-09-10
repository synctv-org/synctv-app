"""Serve the production verification page with a controlled SDK, without network calls."""

import argparse
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlsplit


ROOT = Path(__file__).resolve().parents[1] / 'web'
NATIVE_HTML = None


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        uri = urlsplit(self.path)
        if uri.path in ('/', '/provider_verification.html'):
            scenario = parse_qs(uri.query).get('scenario', ['init'])[0]
            if scenario not in ('init', 'mount', 'validate', 'success'):
                self.send_error(400)
                return
            sdk = f'''<script>
window.SyncTVGeetest = {{postMessage(message) {{
  window.postMessage({{type: 'synctv-provider-verification', payload: JSON.parse(message)}}, '*');
}}}};
window.initGeetest = (_, callback) => {{
  const scenario = {json.dumps(scenario)};
  if (scenario === 'init') throw new Error('Controlled initialization failure');
  const events = {{}};
  const captcha = {{
    appendTo(selector) {{
      if (scenario === 'mount') throw new Error('Controlled mount failure');
      const button = document.createElement('button');
      button.textContent = '完成受控验证';
      button.addEventListener('click', () => {{
        events.success(); events.error(); events.ready();
      }});
      document.querySelector(selector).append(button);
    }},
    onReady(fn) {{ events.ready = fn; fn(); }},
    onSuccess(fn) {{ events.success = fn; }},
    onError(fn) {{ events.error = fn; }},
    getValidate() {{
      if (scenario === 'validate') throw new Error('Controlled result failure');
      return {{geetest_validate: 'preview-result'}};
    }}
  }};
  setTimeout(() => callback(captcha), 0);
}};
window.addEventListener('message', (event) => {{
  if (event.source !== window || event.data.type !== 'synctv-provider-verification') return;
  const evidence = document.getElementById('fixture-evidence');
  evidence.dataset.count = String(Number(evidence.dataset.count || 0) + 1);
  evidence.textContent = 'Received messages: ' + evidence.dataset.count + ' · ' +
    (event.data.payload.error ? 'error' : 'success');
}});
</script>'''
            html = (NATIVE_HTML or (ROOT / 'provider_verification.html')).read_text()
            html = html.replace(
                '<script src="https://static.geetest.com/static/tools/gt.js" defer></script>',
                sdk,
            ).replace(
                '<script src="https://static.geetest.com/static/tools/gt.js"></script>',
                sdk,
            ).replace('</main>', '<p id="fixture-evidence">Controlled SDK; no real verification.</p></main>')
            body, content_type = html.encode(), 'text/html; charset=utf-8'
        elif uri.path in ('/provider_verification.js', '/provider_verification.css'):
            body = (ROOT / uri.path.lstrip('/')).read_bytes()
            content_type = 'text/javascript' if uri.path.endswith('.js') else 'text/css'
        else:
            self.send_error(404)
            return
        self.send_response(200)
        self.send_header('Content-Type', content_type)
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Cache-Control', 'no-store')
        self.end_headers()
        self.wfile.write(body)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', type=int, default=8206)
    parser.add_argument('--native-html', type=Path)
    args = parser.parse_args()
    NATIVE_HTML = args.native_html
    HTTPServer(('127.0.0.1', args.port), Handler).serve_forever()
