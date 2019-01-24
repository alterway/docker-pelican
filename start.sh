#!/bin/sh

cd /blog
make clean
make html
cd /blog/output
python3 -m http.server
