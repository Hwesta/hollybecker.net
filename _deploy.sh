#!/bin/bash -e
echo 'Git pull website'
git pull --rebase
echo 'Git pull resume'
pushd ./resume
git pull --rebase
popd
echo 'Copy resume files over'
mkdir -p assets/resume
cp ./resume/index.html assets/resume/
cp -r ./resume/css/ assets/resume
echo 'Lektor build'
lektor clean --yes
lektor build
echo 'Deploy via rsync'
lektor deploy adrestia
