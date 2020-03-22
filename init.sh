#!bin/bash

npm intall
git pull
git submodule update --init --recursive
cd theme/next
git remote add origin https://github.com/zheyangc/hexo-theme-next.git