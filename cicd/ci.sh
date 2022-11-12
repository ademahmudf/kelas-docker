#!/bin/bash

export GIT_COMMIT_SHORT=$(echo $GIT_COMMIT | head -c 7)
cd 4-membuat-image/app/
echo "===== BUILD & PUSH IMAGE===="
docker build . -f Dockerfile -t ademahmudf/todo-app:$GIT_COMMIT_SHORT
docker push ademahmudf/todo-app:$GIT_COMMIT_SHORT