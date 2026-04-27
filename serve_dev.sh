#!/usr/bin/env bash
set -euo pipefail

PSY_ROOT=/home/conan777/psy
CERT="${PSY_ROOT}/certs/100.76.9.50.pem"
KEY="${PSY_ROOT}/certs/100.76.9.50-key.pem"
LANDING="${PSY_ROOT}/landing_page"
PORT=8082

pkill -f "dev_https_server" 2>/dev/null || true
sleep 0.3

exec /home/conan777/psy/.venv/bin/python3 - <<PYEOF
import ssl, http.server, os, sys
os.chdir("${LANDING}")
class Handler(http.server.SimpleHTTPRequestHandler):
    server_version = "dev_https_server"
    def log_message(self, fmt, *args):
        print(fmt % args, flush=True)
httpd = http.server.HTTPServer(("0.0.0.0", ${PORT}), Handler)
ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ctx.load_cert_chain("${CERT}", "${KEY}")
httpd.socket = ctx.wrap_socket(httpd.socket, server_side=True)
print("Dev server → https://100.76.9.50:${PORT}", flush=True)
httpd.serve_forever()
PYEOF
