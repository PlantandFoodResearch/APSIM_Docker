# ARCHIVE NOTICE
The information in this repository is now out of date, as it relates to APSIM Classic release 7.9. Please see https://github.com/APSIMInitiative/APSIMClassic for up to date versions.

# Docker container for APSIM Classic Build

This container builds APSIM Classic, and creates a self-extracting binary as an artifact, which is then used for the Runtime container. The following comments explain the logic behind how the Build container was created.

## Generic build instructions for APSIM Classic

APSIM's documentation is quite terse, and scattered all over the place. There are no step-by-step build/install instructions, so a lot of guess-work is required. The general flow is:

1. Download the source code using subversion from the upstream server (https://apsrunet.apsim.info/svn/apsim/trunk/)
2. Install OS's pre-requisites as listed under [Compiling under LINUX](https://www.apsim.info/Documentation/TechnicalandDevelopment/BuildingAPSIMfromsource.aspx), making sure to use Mono 4.6 or 4.8
3. Install the required R packages
4. Install pre-requisites not listed as needed (based on trial and error by attemptimg the build several times)
5. Run the `BuildAll.sh` script under `Model/Build`
6. Export the APSIM environment variable pointing to the right location, and create a self-extracting archive for distribution with `Release/Release.sh`

## Generic installation instructions

1. Run the self-extracting archive, optionally specifying a destination path
2. Export `LD_LIBRARY_PATH` to the location of `$apsim_path/Model`
3. `mono Apsim.exe` is the main program. `ApsimModel.exe` is a native (libc) application. See [this thread](https://www.apsim.info/Support/tabid/254/forumid/1/postid/327/scope/posts/Default.aspx) for more info.

## Container-specific notes

- Ubuntu:Xenial was chosen, but Debian:Wheezy would probably work as well
- We need Mono 4.6 or 4.8 based on the comments by the developer (Peter deVoil <p.devoil@uq.edu.au>)
- APSIM apparently needs `/etc/localtime` to run so we have to install tzdata. While we're are it, we configure our local timezone
- Subversion is needed to pull the source code. The while loop works around an issue where `svn co` dies with a "Connection reset by peer" error
    - **TODO:** It may be better to pre-download the source code and mount it as a volume when the container runs
    - **TODO:** We could use ENV variables to choose and build a different release from upstream
- `p7zip-full` is needed to provide `7z`, used by the Cotton model Makefile
- `p7zip` is needed to provide `7zr`, used by the `Release.sh` which creates the self-extracting artifact
- `mono-vbnc` is needed to provide `System.Windows.Forms, Version=4.0.0.0` (used by `ApsimToSim.exe`)
- `libmonosgen-2.0-1` is needed to provide `libmonosgen-2.0-1` (used by `ApsimModel.exe`)
- The file `CottonPassword.txt` is hardcoded on the Cotton model Makefile and expected to be found under `/etc/CottonPassword.txt`. The file was provided by the developer (Dean Holzworth <Dean.Holzworth@csiro.au>). **YOU MUST GET THE PASSWORD FROM THE DEVELOPERS or the Docker build will fail.** Alternatively, you can also disable building the model by commenting out the `Compile Cotton` section in `files/BuildAll.xml`
- These files have been hacked so that the build actually works
    - `Model/TclLink/Makefile` and `Model/RLink/Makefile.linux`: Prepended `ProcessDataTypesInterface.exe` with `mono` instead of calling it directly, so that we don't have to use bimfmt as described [here](http://www.mono-project.com/archived/guiderunning_mono_applications/#registering-exe-as-non-native-binaries-linux-only)
    - `Model/Build/BuildAll.xml`: Disabled building unit tests (requires NUnit v3 for which there is no Debian package and installing from source feels like an overkill)
