#!bin/bash

git pull

# pull all changes for the submodules
git submodule update --remotee

# if first time then use this command instead 
# git submodule update --init --recursive
