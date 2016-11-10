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

  args = parser.parse_args()

  print('Serving directory ' + args.dir + ' via HTTP at port ' + str(args.port))

  os.chdir(args.dir)

  server = BaseHTTPServer.HTTPServer(('', args.port), SimpleHTTPServer.SimpleHTTPRequestHandler)
  server.serve_forever()
