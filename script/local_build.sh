#!/bin/bash

echo "Building website..."
cd client
yarn run build
cd ..

echo "Removing old builds..."
rm -fR bin
mkdir bin
rm -fR build
mkdir build

echo "Building binaries..."
GOOS=linux GOARCH=arm CGO_ENABLED=1 CC=arm-linux-gnueabi-gcc go build -o bin/linux-arm/vulc-cron cmd/vulc-cron/*.go
GOOS=linux GOARCH=arm CGO_ENABLED=1 CC=arm-linux-gnueabi-gcc go build -o bin/linux-arm/vulc-dash cmd/vulc-dash/*.go
echo "- Linux ARM done!"
GOOS=linux GOARCH=amd64 go build -o bin/linux-amd64/vulc-cron cmd/vulc-cron/*.go
GOOS=linux GOARCH=amd64 go build -o bin/linux-amd64/vulc-dash cmd/vulc-dash/*.go
echo "- Linux AMD64 done!"
