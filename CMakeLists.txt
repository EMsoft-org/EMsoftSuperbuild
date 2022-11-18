
if(${CMAKE_MAJOR_VERSION} STREQUAL "3")
  # CMake 3.0 introduces VERSION variables for each Project.
  cmake_policy(SET CMP0048 NEW)
  # CMake 3.1 introduces if() policies on dereferencing variables in quotes
  cmake_policy(SET CMP0054 NEW)
endif()

cmake_minimum_required(VERSION 3.14.5)

project(EMsoftSuperBuild VERSION 1.0.0.0 LANGUAGES C CXX Fortran)

if(WIN32)

  message(STATUS "**************************************************************************")
  message(STATUS "* Platform: Windows")
  message(STATUS "* ONLY NVidia GPUs are supported on Windows platforms. Please ensure that")
  message(STATUS "* the NVidia GPU computing toolkit version 10.0 is installed on your")
  message(STATUS "* computer before trying to compile EMsoft.")
  message(STATUS "**************************************************************************")

endif()


# This allows us to just use the "include()" command and the name of the project
set(CMAKE_MODULE_PATH 
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake" 
        "${CMAKE_CURRENT_SOURCE_DIR}/projects" 
        ${CMAKE_MODULE_PATH})

set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE string "" FORCE)
endif()

# Set up some standard defaults, these will be passed down into external the
# projects.
include(BuildType)
include(BuildLocation)
include(ExternalProject)
include(download_dir)

# Use multiple CPU cores to build
include(ProcessorCount)
ProcessorCount(CoreCount)


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


if( "${EMsoft_SDK}" STREQUAL "")
  message(FATAL_ERROR "Please specify the EMsoft_SDK cmake variable which is the top level directory where all the EMsoft dependent libraries will be built")
endif()

set(EMsoft_SDK_FILE ${EMsoft_SDK}/EMsoft_SDK.cmake)
set(download_dir ${EMsoft_SDK})


message(STATUS "EMsoft_SDK Folder: ${EMsoft_SDK}")
message(STATUS "EMsoft_SDK_FILE:   ${EMsoft_SDK_FILE}")


set(CLONE_EMSOFT_REPO 1)
if("${WORKSPACE_DIR}" STREQUAL "")
  #get_filename_component(WORKSPACE_DIR ${EMsoftSuperBuild_SOURCE_DIR} DIRECTORY)  
  set(CLONE_EMSOFT_REPO 0)
endif()
message(STATUS "Workspace Folder:   ${WORKSPACE_DIR}")

set(BUILD_SHARED_LIBS ON)

if(APPLE)
  set(OSX_DEPLOYMENT_TARGET "10.15")
  set(OSX_SDK "NOT-FOUND")
  EXEC_PROGRAM(uname ARGS -v  OUTPUT_VARIABLE DARWIN_VERSION)
  STRING(REGEX MATCH "[0-9]+" DARWIN_VERSION ${DARWIN_VERSION})
  IF (DARWIN_VERSION LESS 19) 
    set(MACOS_NAME "Yosemite")
    set(OSX_DEPLOYMENT_TARGET "10.10")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk")
    message(STATUS "Found macOS ${OSX_DEPLOYMENT_TARGET} ${MACOS_NAME} as the host. Darwin Version:${DARWIN_VERSION}")
    message(FATAL_ERROR "MacOS ${OSX_DEPLOYMENT_TARGET} ${MACOS_NAME} NOT supported. macOS Catalina is the minimum system")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 19) # macOS 10.15 Catalina (Xcode 11.x or Xcode 12.x)
    set(MACOS_NAME "Catalina")
    set(OSX_DEPLOYMENT_TARGET "10.15")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
    message(STATUS "Found macOS ${OSX_DEPLOYMENT_TARGET} ${MACOS_NAME} as the host. Darwin Version:${DARWIN_VERSION}")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 20) # macOS 11.00 Big Sur (Xcode 12.x)
    set(MACOS_NAME "Big Sur")
    set(OSX_DEPLOYMENT_TARGET "11.00")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
    set(OSX_DEPLOYMENT_TARGET "11.00")
    message(STATUS "Found macOS ${OSX_DEPLOYMENT_TARGET} ${MACOS_NAME} as the host. Darwin Version:${DARWIN_VERSION}")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 21) # macOS 12.00 Monterey (Xcode 12.x/Xcode 13.x)
    set(MACOS_NAME "Monterey")
    set(OSX_DEPLOYMENT_TARGET "12.3")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
    message(STATUS "Found macOS ${OSX_DEPLOYMENT_TARGET} ${MACOS_NAME} as the host. Darwin Version:${DARWIN_VERSION}")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 22) # macOS 13.00 Ventura (Xcode 13.x)
    set(MACOS_NAME "Ventura")
    set(OSX_DEPLOYMENT_TARGET "13.0")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
    message(STATUS "Found macOS ${OSX_DEPLOYMENT_TARGET} ${MACOS_NAME} as the host. Darwin Version:${DARWIN_VERSION}")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 21) # macOS 12.00 Monterey (Xcode 13.x)
    message(STATUS "Found macOS 12.00 Monterey as the host. Darwin Version:${DARWIN_VERSION}")
    set(OSX_DEPLOYMENT_TARGET "12.00")
  ENDIF ()


  if("${OSX_SDK}" STREQUAL "NOT-FOUND")
    message(FATAL_ERROR "This version of macOS (${DARWIN_VERSION}) is not recognized.\
      The following versions are supported:\n\
      (19) macOS 10.15 Catalina\n\
      (20) macOS 11.00 Big Sur\n\
      (21) macOS 12.00 Monterey\n\
      Please edit ${CMAKE_CURRENT_LIST_FILE} and add this version of macOS to the detection logic.
    ")

  endif()
  message(STATUS "CMAKE_HOST_SYSTEM_PROCESSOR: ${CMAKE_HOST_SYSTEM_PROCESSOR}")


  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/projects/apple/OSX_EMsoft_SDK.cmake
              ${EMsoft_SDK}/EMsoft_SDK.cmake @ONLY )
elseif(WIN32)
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
  if( ${MSVC_VERSION} EQUAL "1900")
    message(FATAL_ERROR "Visual Studio Version 14 2015 is NOT supported.")
  endif()
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/projects/win32/WIN_EMsoft_SDK.cmake
              ${EMsoft_SDK}/EMsoft_SDK.cmake COPYONLY )
else()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/projects/unix/Linux_EMsoft_SDK.cmake
                ${EMsoft_SDK}/EMsoft_SDK.cmake COPYONLY )
endif()
 
FILE(APPEND ${EMsoft_SDK_FILE} "\n#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "set(EMsoft_SDK_ROOT \"${EMsoft_SDK}\")\n")
FILE(APPEND ${EMsoft_SDK_FILE} "set(EMsoft_SDK_VERSION ${EMsoft_SDK_VERSION})\n")

FILE(APPEND ${EMsoft_SDK_FILE} "\n#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# EMsoft does not use QtWebEngine to render the docs anymore. Let the system do it.\n")
FILE(APPEND ${EMsoft_SDK_FILE} "set(EMsoftWorkbench_USE_QtWebEngine OFF)\n")

FILE(APPEND ${EMsoft_SDK_FILE} "\n#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# Always write out the compile_commands.json file to help out things like QtCreator and VS Code\n")
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)\n")


#------------------------------------------------------------------------------
# Get the name of the Fortran compiler for easier decisions
get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

#------------------------------------------------------------------------------
# On Windows we are going to use Intel MKL with the FFTW interface so we do not
# need to install FFTW3
if(${Fortran_COMPILER_NAME} MATCHES "gfortran.*")
  include(FFTW)
elseif (${Fortran_COMPILER_NAME} MATCHES "ifort.*")
  set(OSX_DEPLOYMENT_TARGET "10.13")
  include(MKL)
else()
  message(STATUS "The Fortran compiler is NOT recognized. EMsoft may not support it.")
  message(FATAL_ERROR "Current Fortran Compiler is ${CMAKE_Fortran_COMPILER}")
endif()

include(nlopt)
include(JsonFortran)
include(Bcls)
include(CLFortran)
include(Eigen)
include(HDF5)
# include(HDF5pl)
include(TBB)


#--------------------------------------------------------------------------------------------------
# Are we installing Qt (ON by default)
#--------------------------------------------------------------------------------------------------
OPTION(INSTALL_QT5 "Download and Install Qt5" OFF)

if("${INSTALL_QT5}" STREQUAL "ON")
  if(NOT MSVC)
    include(ghcFilesystem)
  endif()
  include(EbsdLib)
  include(Qt5)
else()
  message(WARNING "Qt5 & EBSDLib are disabled. Only command line tools will be compiled. Use -DINSTALL_QT5=ON to enable Qt5 and EBSDLib installation.")
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


if(CLONE_EMSOFT_REPO)

endif()

