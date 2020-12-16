# This is the EMsoft_SDK File. This file contains all the paths to the dependent libraries.
if(NOT DEFINED EMsoft_FIRST_CONFIGURE)
  message(STATUS "*******************************************************")
  message(STATUS "* EMsoft First Configuration Run                    *")
  message(STATUS "* EMsoft_SDK Loading from ${CMAKE_CURRENT_LIST_DIR}  *")
  message(STATUS "*******************************************************")
  set(CMAKE_CXX_FLAGS "-Wmost -Wno-four-char-constants -Wno-unknown-pragmas -mfpmath=sse" CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE STRING "" FORCE)
    # Set our Deployment Target to match Qt
  set(CMAKE_OSX_DEPLOYMENT_TARGET "@OSX_DEPLOYMENT_TARGET@" CACHE STRING "" FORCE)
  set(CMAKE_OSX_SYSROOT "@OSX_SDK@" CACHE STRING "" FORCE)
endif()

#-------------------------------------------------------------------------------
# Only Run this the first time when configuring EMsoft. After that the values
# are cached properly and the user can add additional plugins through the normal
# CMake GUI or CCMake programs.
if(NOT DEFINED EMsoft_FIRST_CONFIGURE)
  set(EMsoft_FIRST_CONFIGURE "ON" CACHE STRING "Determines if EMsoft has already been configured at least once.")
endif()

#-------------------------------------------------------------------------------
# This function is a convenience wrapper to check the existance of the support
# library directories and fail early if they do not exist
function(Check3rdPartyDir)
  set(options )
  set(oneValueArgs DIR)
  set(multiValueArgs)
  cmake_parse_arguments(Z "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  if(NOT EXISTS "${Z_DIR}")
    message(FATAL_ERROR "Support Lib does not exist: ${Z_DIR}")
  else()
    message(STATUS "Support Lib Exists: ${Z_DIR}")
  endif()
endfunction()

#-------------------------------------------------------------------------------
# These settings are specific to EMsoft. EMsoft needs these variables to
# configure properly.
set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()

message(STATUS "The Current Build type being used is ${BUILD_TYPE}")

#-------------------------------------------------------------------------------
# This also will help when using IDE's like QtCreator be able to find the compiler
set(CMAKE_Fortran_COMPILER "@CMAKE_Fortran_COMPILER@" CACHE PATH "Path to Fortran Compiler")


set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
message(STATUS "BUILD_SHARED_LIBS: ${BUILD_SHARED_LIBS}")
