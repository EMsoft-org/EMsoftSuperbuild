# EMsoft SDK Superbuild #

## IMPORTANT NOTE ##

If you find bugs and fix them **PLEASE** consider submitting a "Pull Request" from your fork to the official repository. This will allow the entire EMsoft community to benefit from your bug fixes.

## Introduction ##

This cmake project will build an EMsoft SDK by downloading all the necessary 3rd party libraries as prebuilt binaries or as source code and compiling those libraries.  Note that this Develop branch builds the SDK for the regular EMsoft package (up to version 5.X), whereas the DevelopOO branch covers the SDK for the object oriented version 6 EMsoftOO of this package.

## Prerequisites ##

+ CMake 3.15.x or later installed on system (preferably 3.25)
+ Compiler Suite installed on system (on OS X, preferably installed via "brew install gcc")
+ Fortran compiler installed on system (OS X: brew install gcc will install gfortran as well)
+ Git installed on the system

## Supported Platforms ##

| Operating System | C/C++ Compiler | Fortran Compiler |
|------------------|----------------|------------------|
| macOS (>=10.13) | Xcode Native tools (10/11) | GFortran 6.3.0 or Intel Fortran 19\*\* |
| Windows (10) | Visual Studio 2015 (CE/Pro) | Intel Fortran v17/v19 |
| Linux (Ubuntu 16.x, CentOS 7.x) | GCC 7.x and Above, Clang 3.8 and greater | GNU Fortran 6.3.5 20160904 or newer |

\*\*macOS Note: If you are installing Intel Fortran try to install into a location **other** then /opt/intel which is the default. Try /opt/intel_sw instead.

## Git Locations ##

Git verison 2.x is required.

| Operating System |  Notes  |
|------------------|--------------|
| macOS (10.13) | CLI comes with Xcode, [SourceTree](http://www.sourcetreeapp.com) for a nice GUI application |
| Windows (10) | [SourceTree](http://www.sourcetreeapp.com). Download and install the app  |
| Linux (Ubuntu 16.x, CentOS 7.x) | Use your package manager to install git.|

## Libraries that are Compiled ##

| Library | Version | Notes |
|---------|---------|-------|
| HDF5 | 1.12.2 | Compiled from Source |
| HDF5pl | 1.12.2 | Plugin library, compiled from Source |
| CLFortran | 0.0.1 | Compiled from Source on GitHub |
| FFTW | 3.3.5 | Compiled (macOS/Linux) |
| Intel MKL | 2019_xxxx | Precompiled for IFort compilers (windows & macos) |
| Json-Fortran | 4.2.1 | Compiled from source on GitHub |
| Eigen | 3.3.5 | Compiled from Source |
| Qt 5 | 5.12.4 | Precompiled Binaries from [www.qt.io](http://download.qt.io) |

## EMsoft versions ##
EMsoft 5.0.X requires a build of the regular develop branch in the EMsoftSuperbuild repository.  For the Object Oriented version, EMsoftOO, (which is effectively EMsoft 6.0)please use the developOO branch of the EMsoftSuperbuild repository.

## macOS/Linux Instructions ##

1. Install your compiler tools
2. Install CMake on your system
3. Install a Fortran compiler on your system
4. Install Git on your system
5. Clone this repository onto your hard disk.
6. open a terminal and invoke the following commands

        cd EMsoftSuperbuild
        mkdir Debug
        cd Debug
        cmake -DEMsoft_SDK=/Some/Path/To/EMsoft_SDK -DCMAKE_BUILD_TYPE=Debug ../
        make -j
        cd ../
        mkdir Release
        cd Release
        cmake -DEMsoft_SDK=/Some/Path/To/EMsoft_SDK -DCMAKE_BUILD_TYPE=Release ../
        make -j


Note that the Superbuild has been successfully installed on the arm64 M1 platform using XCode 13 on Monterey and XCode 14 on Ventura.

## Windows Instructions ##

*Currently ONLY NMake files are supported. Visual Studio support is being looked at*

1. Install your compiler tools
2. Install CMake on your system
3. Install a Fortran compiler on your system
4. Install Git on your system
5. Create the following Directories:
    + C:/Users/[USERNAME]/EMsoft_SDK
    + C:/Users/[USERNAME]/EMsoft-Dev
6. Open a command prompt and invoke the following commands

        cd C:/Users/[USERNAME]/EMsoft-Dev
		git clone git://www.github.com/emsoft-org/EMsoftSuperbuild
        cd EMsoftSuperbuild
        mkdir Debug
        cd Debug
        cmake -G "NMake Makefiles" -DEMsoft_SDK=C:/Users/[USERNAME]/EMsoft_SDK -DCMAKE_BUILD_TYPE=Debug ../
        nmake
        cd ../
        mkdir Release
        cd Release
        cmake -G "NMake Makefiles" -DEMsoft_SDK=C:/Users/[USERNAME]/EMsoft_SDK -DCMAKE_BUILD_TYPE=Release ../
        make -j

7. The initial run of CMake is going to take  **REALLY** long time because it will be downloading the full Qt 5.x installer which is about 3~4 GB in size. On macOS systems it then must verify the .dmg, mount it and run the installer (which verifies the .app). Go get coffee. Compiling (the 'make -j' part) should not take that long, only about 5 minutes or so.

**NOTE**: there is currently a known issue where the Qt 5.x installer will NOT actually run during the Linux cmake process. If the user does *NOT* want to build the GUI application then this is fine. If the user does want to build the GUI application then they will need to install Qt 5.x themselves. The download will be at /path/to/EMsoft_SDK/superbuild/Qt/download

The developer can use CMakeGui if they would like instead of the command lines. The only required variable are the path to where you want the EMsoft_SDK folder and the build type (Debug or Release)

Once the SDK builds correctly, no errors are reported on the command line, then the developer can proceed to clone and build EMsoft itself.
