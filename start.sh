#!/bin/sh

PATH=$HOME/.cargo/bin:$PATH
export PATH
cd /blog
make clean
make html
cd /blog/output
python3 -m http.server
