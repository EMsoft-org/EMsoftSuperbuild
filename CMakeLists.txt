
if(${CMAKE_MAJOR_VERSION} STREQUAL "3")
  # CMake 3.0 introduces VERSION variables for each Project.
  cmake_policy(SET CMP0048 NEW)
  # CMake 3.0 introduces some OS X RPath policies
  cmake_policy(SET CMP0042 OLD)
  # CMake 3.1 introduces if() policies on dereferencing variables in quotes
  cmake_policy(SET CMP0054 NEW)
endif()

cmake_minimum_required(VERSION 3.8.0)

if(MSVC90)
  message(FATAL_ERROR "Visual Studio Version 9 2009 is NOT supported.")
endif(MSVC90)
if(MSVC10)
  message(FATAL_ERROR "Visual Studio Version 10 2010 is NOT supported.")
endif(MSVC10)
if(MSVC11)
  message(FATAL_ERROR "Visual Studio Version 11 2012 is NOT supported.")
endif(MSVC11)
if(MSVC12)
  message(FATAL_ERROR "Visual Studio Version 12 2013 is NOT supported.")
endif(MSVC12)



project(EMsoftSuperBuild VERSION 1.0.0.0 LANGUAGES C CXX Fortran)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()


# Set up some standard defaults, these will be passed down into external the
# projects.
include(BuildType)
include(BuildLocation)
include(ExternalProject)
include(download_dir)

if( "${EMsoft_SDK}" STREQUAL "")
  message(FATAL_ERROR "Please specify the EMsoft_SDK cmake variable which is the top level directory where all the DREAM.3D dependent libraries will be built")
endif()

set(EMsoft_SDK_FILE ${EMsoft_SDK}/EMsoft_SDK.cmake)
set(download_dir ${EMsoft_SDK})


message(STATUS "EMsoft_SDK Folder: ${EMsoft_SDK}")
message(STATUS "EMsoft_SDK_FILE:   ${EMsoft_SDK_FILE}")
if("${WORKSPACE_DIR}" STREQUAL "")
  get_filename_component(WORKSPACE_DIR ${EMsoftSuperBuild_SOURCE_DIR} DIRECTORY)  
endif()
message(STATUS "Workspace Folder:   ${WORKSPACE_DIR}")

set(BUILD_SHARED_LIBS ON)

OPTION(INSTALL_QT5 "Download and Install Qt5" ON)


# Use multiple CPU cores to build
include(ProcessorCount)
ProcessorCount(CoreCount)


if(APPLE)
  EXEC_PROGRAM(uname ARGS -v  OUTPUT_VARIABLE DARWIN_VERSION)
  STRING(REGEX MATCH "[0-9]+" DARWIN_VERSION ${DARWIN_VERSION})
  message(STATUS "DARWIN_VERSION: ${DARWIN_VERSION}")
  IF (DARWIN_VERSION EQUAL 14)
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 15)
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 16)
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk")
  ENDIF ()

  set(OSX_DEPLOYMENT_TARGET "10.10")

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/OSX_EMsoft_SDK.cmake
              ${EMsoft_SDK}/EMsoft_SDK.cmake @ONLY )
elseif(WIN32)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/WIN_EMsoft_SDK.cmake
                ${EMsoft_SDK}/EMsoft_SDK.cmake COPYONLY )
else()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Linux_EMsoft_SDK.cmake
                ${EMsoft_SDK}/EMsoft_SDK.cmake COPYONLY )
endif()


FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "set(EMsoft_SDK_ROOT \"${EMsoft_SDK}\")\n")

include(External_FFTW)
include(External_JsonFortran)
include(External_Bcls)
include(External_CLFortran)
include(External_Eigen)
include(External_HDF5)


if("${INSTALL_QT5}" STREQUAL "ON")
  include(External_Qt5)
else()
  message(WARNING "The EMsoft_SDK.cmake file will be incomplete as intended. The paths to your Qt installation will be missing and DREAM.3D will probably not build.")
endif()


#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
function(CloneRepo)
  set(options )
  set(oneValueArgs DEPENDS PROJECT_NAME GIT_REPOSITORY TMP_DIR STAMP_DIR DOWNLOAD_DIR SOURCE_DIR BINARY_DIR INSTALL_DIR)
  set(multiValueArgs )
  cmake_parse_arguments(Z "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  set(projectName ${Z_PROJECT_NAME})
  message(STATUS "Cloning ${projectName}" )

  set(SOURCE_DIR "${Z_WORKSPACE_DIR}")

  set_property(DIRECTORY PROPERTY EP_BASE ${SOURCE_DIR}/${projectName})

  ExternalProject_Add(${projectName}
    DEPENDS ${Z_DEPENDS}
    TMP_DIR      ${Z_TMP_DIR}
    STAMP_DIR    ${Z_STAMP_DIR}
    DOWNLOAD_DIR ${Z_DOWNLOAD_DIR}
    SOURCE_DIR   ${Z_SOURCE_DIR}
    BINARY_DIR   ${Z_BINARY_DIR}
    INSTALL_DIR  ${Z_INSTALL_DIR}

    GIT_PROGRESS 1
    GIT_REPOSITORY "${Z_GIT_REPOSITORY}"
    GIT_TAG develop

    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    TEST_COMMAND ""

    
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
  )

endfunction()
