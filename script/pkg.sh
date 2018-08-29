#!/bin/bash

rm -fR build
mkdir build 

cd bin/linux-arm
tar -zcf ../../build/vulc-dash-1.0.0-linux-arm.tar.gz vulc-cron vulc-dash

cd ../linux-amd64
tar -zcf ../../build/vulc-dash-1.0.0-linux-amd64.tar.gz vulc-cron vulc-dash

cd ../../client/build
tar -zcf ../../build/vulc-dash-1.0.0-html.tar.gz *