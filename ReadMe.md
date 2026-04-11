# EMsoft SDK Superbuild #

## IMPORTANT NOTE ##

If you find bugs and fix them **PLEASE** consider submitting a "Pull Request" from your fork to the official repository. This will allow the entire EMsoft community to benefit from your bug fixes.

## Introduction ##

This cmake project will build an EMsoft SDK by downloading all the necessary 3rd party 
libraries as prebuilt binaries or as source code and compiling those libraries. In this developOO branch,
the cmake code will build an EMsoftOO_SDK that is suitable for linking against the EMsoftOO object oriented 
source code base. Note that this SDK can co-exist alongside the regular SDK built by the develop branch.

**This branch is still under development and there is no guarantee that it will always work properly...**

## Prerequisites ##

+ CMake 3.25 or later installed on the system. The Visual Studio 2022 bundled CMake 3.31.x works.
+ Compiler suite installed on the system
+ Fortran compiler installed on the system
+ Git 2.x installed on the system
+ On Windows for this branch, install Visual Studio 2022 plus Intel oneAPI Base Toolkit and HPC Toolkit so that `ifx` and MKL are available

## Supported Platforms ##

| Operating System | C/C++ Compiler | Fortran Compiler | Status |
|------------------|----------------|------------------|--------|
| macOS (>=10.13) | Xcode Native tools (10/11) | GFortran 6.3.0 or Intel Fortran 19\*\* | Legacy instructions |
| Windows 11 | Visual Studio 2022 | Intel oneAPI `ifx` | Validated on this branch |
| Linux (Ubuntu 16.x, CentOS 7.x) | GCC 7.x and above, Clang 3.8 and greater | GNU Fortran 6.3.5 20160904 or newer | Legacy instructions |

\*\*macOS Note: If you are installing Intel Fortran try to install into a location **other** then /opt/intel which is the default. Try /opt/intel_sw instead.

## Git Locations ##

Git version 2.x is required.

| Operating System |  Notes  |
|------------------|--------------|
| macOS (10.13) | CLI comes with Xcode, [SourceTree](http://www.sourcetreeapp.com) for a nice GUI application |
| Windows (10) | [SourceTree](http://www.sourcetreeapp.com). Download and install the app  |
| Linux (Ubuntu 16.x, CentOS 7.x) | Use your package manager to install git.|

## Libraries that are Compiled ##

| Library | Version | Notes |
|---------|---------|-------|
| HDF5 | 1.12.2 | Compiled from Source |
| CLFortran | 0.0.1 | Compiled from Source on GitHub |
| FFTW | 3.3.5 | Compiled (macOS/Linux) |
| Intel MKL | oneAPI install | Uses the MKL installation that ships with Intel oneAPI on Windows |
| Json-Fortran | 4.2.1 | Compiled from source on GitHub |
| Eigen | 3.3.5 | Compiled from Source |
| Qt 5 | 5.12.4 | Precompiled Binaries from [www.qt.io](http://download.qt.io) |
| bspline-fortran | 7.4.0 | Compiled from Source on GitHub (added 11/21/2024) |

## macOS/Linux Instructions ##

1. Install your compiler tools
2. Install CMake on your system
3. Install a Fortran compiler on your system (use "brew install gcc")
4. Install Git on your system
5. Clone this repository onto your hard disk.
6. open a terminal and invoke the following commands

        cd EMsoftSuperbuild
        mkdir Debug
        cd Debug
        cmake -DEMsoftOO_SDK=/Some/Path/To/EMsoftOO_SDK -DCMAKE_BUILD_TYPE=Debug ../
        make -j
        cd ../
        mkdir Release
        cd Release
        cmake -DEMsoftOO_SDK=/Some/Path/To/EMsoftOO_SDK -DCMAKE_BUILD_TYPE=Release ../
        make -j

## Windows Instructions ##

This branch is currently validated on Windows with the `NMake Makefiles` generator, Visual Studio 2022, and Intel oneAPI `ifx` (tested with oneAPI 2025.3 and the Visual Studio 2022 bundled CMake 3.31.x).

### Toolchain Installation ###

1. Install Visual Studio 2022 with the Desktop development with C++ workload.
2. Install Intel oneAPI Base Toolkit and Intel oneAPI HPC Toolkit. This provides MKL and the `ifx` Fortran compiler.
3. Install Git.
4. Install CMake 3.25 or later, or use the CMake that ships with Visual Studio 2022.

### Configure and Build ###

1. Open a Command Prompt window.
2. Initialize the Visual Studio 2022 and Intel oneAPI build environment:

        call "C:\Program Files (x86)\Intel\oneAPI\setvars.bat" intel64 vs2022

3. Choose an SDK install location, for example:

        C:/Users/[USERNAME]/EMsoftOO_SDK

4. Clone the repository and configure a Release build:

        cd C:/Users/[USERNAME]
        git clone https://github.com/EMsoft-org/EMsoftSuperbuild.git
        cd EMsoftSuperbuild
        cmake -S . -B build-ifx -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_Fortran_COMPILER=ifx -DEMsoftOO_SDK=C:/Users/[USERNAME]/EMsoftOO_SDK -DINSTALL_QT5=OFF

5. Build the SDK:

        cmake --build build-ifx

6. After a successful build, the generated SDK configuration file will be located at:

        C:/Users/[USERNAME]/EMsoftOO_SDK/EMsoftOO_SDK.cmake

7. To generate a Debug SDK, use a different build directory and switch `-DCMAKE_BUILD_TYPE=Debug`.

### Notes ###

+ `-DINSTALL_QT5=OFF` builds the command-line dependency stack only. Set `-DINSTALL_QT5=ON` if you also want Qt 5 and EBSDLib.
+ Enabling Qt will trigger a very large Qt download during the first configure.
+ The developer can also use CMake GUI. The required variables are `EMsoftOO_SDK` and `CMAKE_BUILD_TYPE`.

Once the SDK builds correctly, no errors are reported on the command line, then the developer can proceed to clone and build EMsoft itself.
