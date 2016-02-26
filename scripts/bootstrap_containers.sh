#!/usr/bin/env bash

docker pull vfarcic/books-ms-tests

docker tag vfarcic/books-ms-tests 10.100.198.200:5000/books-ms-tests

docker push 10.100.198.200:5000/books-ms-tests
