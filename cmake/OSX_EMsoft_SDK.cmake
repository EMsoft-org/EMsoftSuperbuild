# This is the EMsoft_SDK File. This file contains all the paths to the dependent libraries.
if(NOT DEFINED EMsoft_FIRST_CONFIGURE)
  message(STATUS "*******************************************************")
  message(STATUS "* EMsoft First Configuration Run                    *")
  message(STATUS "* EMsoft_SDK Loading from ${CMAKE_CURRENT_LIST_DIR}  *")
  message(STATUS "*******************************************************")
  set(CMAKE_CXX_FLAGS "-Wmost -Wno-four-char-constants -Wno-unknown-pragmas -mfpmath=sse" CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD 11 CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE STRING "" FORCE)
endif()

#--------------------------------------------------------------------------------------------------
# Only Run this the first time when configuring EMsoft. After that the values
# are cached properly and the user can add additional plugins through the normal
# CMake GUI or CCMake programs.
if(NOT DEFINED EMsoft_FIRST_CONFIGURE)
  set(EMsoft_FIRST_CONFIGURE "ON" CACHE STRING "Determines if EMsoft has already been configured at least once.")
endif()

#-------------------------------------------------------------------------------
# These settings are specific to EMsoft. EMsoft needs these variables to
# configure properly.
set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()

message(STATUS "The Current Build type being used is ${BUILD_TYPE}")

#-------------------------------------------------------------------------------
# We are going to assume the use of GFortran for macOS systems. This will definitely
# mess up the use of Intel IFort on macOS. I'll cross that bridge when someone
# complains about it.
set(EMsoft_USE_GFORTRAN 1)
# This also will help when using IDE's like QtCreator be able to find the compiler
if(EMsoft_USE_GFORTRAN)
  set(CMAKE_Fortran_COMPILER "/usr/local/gfortran/bin/gfortran" CACHE PATH "Path to GFortran" FORCE)
else()

endif()

set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
