import os
from http.server import BaseHTTPRequestHandler
from http.server import HTTPServer
from subprocess import Popen, PIPE

ADDR = os.getenv("SERVER_ADDR", "0.0.0.0")
PORT = os.getenv("SERVER_PORT", 80)


class Z3RequestHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        self.send_response(200)
        self.send_header('Content-type', 'plain/text')
        self.end_headers()
        out, err = call_z3(self.read_body())
        self.wfile.write(out)  # write std out to response body

    def read_body(self) -> bytes:
        """Read request body to bytes"""
        request_headers = self.headers
        length = int(request_headers.get('content-length', 0))
        return self.rfile.read(length)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        BaseHTTPRequestHandler.end_headers(self)


def call_z3(payload) -> (bytes, bytes):
    """Outputs a tuple containing the STDOUT and STDERR responses"""
    p = Popen(["z3", "-smt2", "-in"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
    std_response = p.communicate(input=payload)
    p.wait()
    return std_response


def run(server_class=HTTPServer, handler_class=Z3RequestHandler):
    server_address = (ADDR, int(PORT))
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()


run()
