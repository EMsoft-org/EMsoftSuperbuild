
set(extProjectName "fftw")
message(STATUS "External Project: ${extProjectName}" )

set(FFTW_VERSION "3.3.5")
set(FFTW_PREFIX "${EMsoft_SDK}/superbuild/${extProjectName}")
set(FFTW_FOLDER_NAME "fftw-${FFTW_VERSION}-pl2.tar.gz")
set(FFTW_DOWNLOAD_DIR "${EMsoft_SDK}/superbuild/${extProjectName}")
set(FFTW_BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build")
set(FFTW_SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source")
set(FFTW_STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp")
set(FFTW_TEMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Tmp")
set(FFTW_INSTALL_DIR "${EMsoft_SDK}/fftw-${FFTW_VERSION}")
set(FFTW_DOWNLOAD_FILE ${FFTW_FOLDER_NAME}.tar.gz)
if(WIN32)
  set(FFTW_INSTALL_DIR "${EMsoft_SDK}/fftw-${FFTW_VERSION}-dll64")
  set(FFTW_FOLDER_NAME "fftw-${FFTW_VERSION}-dll64")
endif()

#set(FFTW_url_server "http://dream3d.bluequartz.net/binaries/EMSoft_SDK/")
# ftp://ftp.fftw.org/pub/fftw/fftw-3.3.5-dll64.zip
set(FFTW_url_server "ftp://ftp.fftw.org/pub/fftw")

if(WIN32)
  set(FFTW_DOWNLOAD_FILE fftw-${FFTW_VERSION}-dll64.zip)
elseif(APPLE)
  set(FFTW_DOWNLOAD_FILE fftw-${FFTW_VERSION}.tar.gz)
else()
  set(FFTW_DOWNLOAD_FILE fftw-${FFTW_VERSION}.tar.gz)
endif()

set(FFTW_URL "${FFTW_url_server}/${FFTW_DOWNLOAD_FILE}")

set_property(DIRECTORY PROPERTY EP_BASE ${FFTW_PREFIX})

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

#-- On OS X systems we are going to simply download FFTW archive
if(APPLE)
# http://www.fftw.org/fftw-3.3.4-pl2.tar.gz
# http://www.fftw.org/fftw-3.3.4.tar.gz

  ExternalProject_Add(${extProjectName}
    DOWNLOAD_NAME ${FFTW_DOWNLOAD_FILE}
    URL ${FFTW_URL}

    TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp"
    STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp"
    DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}/Download
    SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source"
    #BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build"
    INSTALL_DIR "${FFTW_INSTALL_DIR}"

    #DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ${EMsoft_SDK}/superbuild/${extProjectName}/Source/configure --prefix=${FFTW_INSTALL_DIR} --enable-shared
    BUILD_COMMAND make -j${CoreCount}
    INSTALL_COMMAND make install
    TEST_COMMAND ""

    BUILD_IN_SOURCE 1

    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
  )

elseif(WIN32)

  if(MSVC90)
    message(FATAL_ERROR "Visual Studio Version 9 is NOT supported.")
  endif(MSVC90)
  if(MSVC10)
    message(FATAL_ERROR "Visual Studio Version 10 is NOT supported.")
  endif(MSVC10)
  if(MSVC11)
    message(FATAL_ERROR "Visual Studio Version 11 is NOT supported.")
  endif(MSVC11)
  if(MSVC12)
    message(FATAL_ERROR "Visual Studio Version 12 is NOT supported.")
  endif(MSVC12)
  if(MSVC14)
    set(FFTW_CMAKE_GENERATOR "Visual Studio 14 2015 Win64")
    set(FFTW_VS_VERSION "14.0")
  endif()

  configure_file(
    "${_self_dir}/fftw/Build_fftw.bat.in"
    "${EMsoft_SDK}/superbuild/${extProjectName}/Build/Build_FFTW.bat"
    @ONLY
    )

  set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)

  ExternalProject_Add(${extProjectName}
    DOWNLOAD_NAME ${FFTW_DOWNLOAD_FILE}
    URL ${FFTW_URL}
    TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp"
    STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp"
    DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}
    SOURCE_DIR "${FFTW_INSTALL_DIR}"
    BINARY_DIR "${FFTW_INSTALL_DIR}"
    INSTALL_DIR "${FFTW_INSTALL_DIR}"

    CONFIGURE_COMMAND ""
    PATCH_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "${EMsoft_SDK}/superbuild/${extProjectName}/Build/Build_FFTW.bat"

    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
  )

else()
  ExternalProject_Add(${extProjectName}
      DOWNLOAD_NAME ${FFTW_DOWNLOAD_FILE}
      URL ${FFTW_URL}

      TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp"
      STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp"
      DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}/Download
      SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source"
      #BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build"
      INSTALL_DIR "${FFTW_INSTALL_DIR}"

      #DOWNLOAD_COMMAND ""
      UPDATE_COMMAND ""
      PATCH_COMMAND ""
      CONFIGURE_COMMAND ${EMsoft_SDK}/superbuild/${extProjectName}/Source/configure --prefix=${FFTW_INSTALL_DIR} --enable-shared
      BUILD_COMMAND make -j${CoreCount}
      INSTALL_COMMAND make install
      TEST_COMMAND ""

      BUILD_IN_SOURCE 1

      LOG_DOWNLOAD 1
      LOG_UPDATE 1
      LOG_CONFIGURE 1
      LOG_BUILD 1
      LOG_TEST 1
      LOG_INSTALL 1
    )


endif()


FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# FFTW ${FFTW_VERSION} Location\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_INSTALL \"\${EMsoft_SDK_ROOT}/fftw-${FFTW_VERSION}\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_VERSION \"${FFTW_VERSION}\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_INSTALL \"\${EMsoft_SDK_ROOT}/fftw-${FFTW_VERSION}-dll64/fftw-${FFTW_VERSION}-dll64\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_VERSION \"${FFTW_VERSION}\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_INCLUDE_DIR \"\${EMsoft_SDK_ROOT}/fftw-${FFTW_VERSION}-dll64\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_LIBRARY \"\${EMsoft_SDK_ROOT}/fftw-${FFTW_VERSION}-dll64/libfftw3-3.lib\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_IS_SHARED TRUE)\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_INSTALL \"\${EMsoft_SDK_ROOT}/fftw-${FFTW_VERSION}\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_VERSION \"${FFTW_VERSION}\")\n")
endif()
