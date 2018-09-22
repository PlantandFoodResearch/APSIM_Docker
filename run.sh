#!/bin/bash
docker run -u ${UID}:${GID} --rm -v /storage:/storage --name=${USER}_apsim79 apsim-classic:79 Apsim.exe "$@"
