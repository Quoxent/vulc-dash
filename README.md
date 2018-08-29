# vulc-dash

![Vulcano Home Node Dashboard](/client/src/img/screenshot.png?raw=true "Vulcano Home Node Dashboard")

## Requirements
The follow items are required by the system:
- golang 1.10+
- vulcano node already setup with rpc information


## Production
Automatically install the latest production release of the vulc-dash system.

### Install
_Under active development_

To install the system please run `wget https://raw.githubusercontent.com/vulcanocrypto/vulc-dash/master/script/install.sh && sudo bash install.sh`.


## Development
For development please follow the flow outlined below.

### Download
To download the source code please run `go get github.com/vulcanocrypto/vulc-dash`.  

The source code will be placed in `$GOPATH/src/github.com/vulcanocrypto/vulc-dash`.

### Build
Go to the source code folder `cd $GOPATH/src/github.com/vulcanocrypto/vulc-dash`.

Run the build script `./script/local_build.sh`.  This will also build the web client using `webpack` located in `./client` folder.

Binary files will be placed in architecture and os specific folders in `./bin`.  

For example `./bin/linux-arm` and `./bin/linux-am64` for the linux operating system, ARM and x86_64 cpu architectures.

### Package
To package the files please run `./script/pkg.sh` from the project source folder as well.

Files will be `tar.gz` and placed in the `./build` folder.
