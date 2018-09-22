#!/bin/bash

## TODO: use ENV to specify a different Apsim release

# Build the build container
docker build -t ${USER}/apsim-classic:build . -f Dockerfile.build

# Extract artifact
docker create --name extract ${USER}/apsim-classic:build
docker cp -L extract:/apsim/Release/Apsim.binaries.LINUX.X86_64.exe .
docker rm -f extract

# Build the runtime container
docker build -t ${USER}/apsim-classic:79 .

# Cleanup
rm -f Apsim*.binaries.LINUX.X86_64.exe
echo Remember to "docker rmi ${USER}/apsim-classic:build" if the runtime container build was successful!
