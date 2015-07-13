#!/bin/sh

cd /blog
make clean
make html
cd /blog/output
python -m pelican.server 8000
