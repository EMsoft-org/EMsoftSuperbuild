# This is the EMsoft_SDK File. This file contains all the paths to the dependent libraries.
if(NOT DEFINED EMsoft_FIRST_CONFIGURE)
  message(STATUS "*******************************************************")
  message(STATUS "* EMsoft First Configuration Run                    *")
  message(STATUS "* EMsoft_SDK Loading from ${CMAKE_CURRENT_LIST_DIR}  *")
  message(STATUS "*******************************************************")
  set(CMAKE_Fortran_FLAGS "/W1 /nologo /fpp /libs:dll /threads /assume:byterecl" CACHE STRING "" FORCE)
  set(CMAKE_EXE_LINKER_FLAGS " /machine:x64 /STACK:100000000" CACHE STRING "" FORCE)
  set(CMAKE_EXE_LINKER_FLAGS_DEBUG "/INCREMENTAL" CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_DEBUG "/D_DEBUG /MTd /Zi /Ob0 /Od /RTC1 /MTd" CACHE STRING "" FORCE)

endif()

#--------------------------------------------------------------------------------------------------
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

#--------------------------------------------------------------------------------------------------
# These settings are specific to EMsoft. EMsoft needs these variables to
# configure properly.
set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()

set(BUILD_SHARED_LIBS ON CACHE BOOL "")
message(STATUS "BUILD_SHARED_LIBS: ${BUILD_SHARED_LIBS}")
