# EMsoft SDK Superbuild #

## Introduction ##

This cmake project will build an EMsoft SDK by downloading all the necessary 3rd party 
libraries as prebuilt binaries or as source code and compiling those libraries. 

## Prerequisites ##

+ CMake 3.7.x installed on system
+ Compiler Suite installed on system
+ Fortran compiler installed on system


## Supported Platforms ##

| Operating System | C/C++ Compiler | Fortran Compiler |
|------------------|----------------|------------------|
| macOS (10.10, 10.11, 10.12) | Xcode Native tools (7.x ~ 8.x) | GFortran 5.2 and above |
| Windows (7,8,8.1,10) | Visual Studio 2015 (CE/Express/Pro) | Intel Fortran v17 |
| Linux (Ubuntu 16.x, CentOS 7.x) | GCC 4.8 and Above, Clang 3.8 and greater | GFortran 5.2 and above |


## Installed Libraries ##

| Library | Version | Notes |
|---------|---------|-------|
| HDF5 | 1.8.18 | Compiled from Source |
| CLFortran | 0.0.1 | Compiled from Source on GitHub |
| FFTW | 3.3.4 | Precompiled (Windows) or Compiled (macOS/Linux) |
| Json-Fortran | 4.2.0 | Compiled from source on GitHub |
| Eigen | 3.2.9 | Compiled from Source |
| Qt 5 | 5.6.2 | Precompiled Binaries from www.qt.io |

