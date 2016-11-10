#!/usr/bin/env python

import argparse
import BaseHTTPServer
import os
import SimpleHTTPServer
import socket
import ssl

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Serve up directory with ssl')
  parser.add_argument('--dir', default='/var/www')
  parser.add_argument('--port', type=int, default=8443)
  parser.add_argument('--certfile', default='/root/cert.pem')
  parser.add_argument('--cafile', default='/root/ca-cert.pem')

  args = parser.parse_args()

  print('Serving directory ' + args.dir + ' via HTTPS at port ' + str(args.port))

  os.chdir(args.dir)

  server = BaseHTTPServer.HTTPServer(('', args.port), SimpleHTTPServer.SimpleHTTPRequestHandler)
  server.socket = ssl.wrap_socket (server.socket, certfile=args.certfile, ca_certs=args.cafile, server_side=True, cert_reqs=ssl.CERT_REQUIRED)
  server.serve_forever()
