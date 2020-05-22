#--------------------------------------------------------------------------------------------------
# Are we installing Qt (ON by default)
#--------------------------------------------------------------------------------------------------
OPTION(INSTALL_QT5 "Install Qt5" ON)

if("${QtVersion}" STREQUAL "")
  set(QtVersion "5.12")
endif()

if("${QtVersion}" STREQUAL "5.9")
  set(Qt599 "1")
  set(Qt512 "0")
  set(Qt514 "0")
endif()

if("${QtVersion}" STREQUAL "5.12")
  set(Qt599 "0")
  set(Qt512 "1")
  set(Qt514 "0")
endif()

if("${QtVersion}" STREQUAL "5.14")
  set(Qt599 "0")
  set(Qt512 "0")
  set(Qt514 "1")
endif()



# ------------------------------------------------------------------------------
# Qt 5.9.x is a LTS release
if(Qt599)
  if(Qt512 OR Qt514)
    message(FATAL_ERROR "Please set the -DQtVersion=(5.9 | 5.12 | 5.14) to select the version of Qt5 that you want to build against.")
  endif()
  set(qt5_version_major "5.9")
  set(qt5_version_full "5.9.9")
  set(qt5_version_short "5.9.9")
  # This variable is used inside the javascript file that performs the Qt installation
  # Up to maybe Qt5.9.5 we use this
  set(qt5_installer_version "595")
  # At some point then the installer changed to the following form
  set(qt5_installer_version "qt5.599")
endif()

# ------------------------------------------------------------------------------
# Qt 5.12 should STAY at 5.12.4. 5.12.7 had issues with DREAM3D configuration throwing errors.
# Qt 5.12.8 Now works with CMake
# Qt 5.12 is a LTS release
if(Qt512)
  if(Qt599 OR Qt514)
    message(FATAL_ERROR "Please set the -DQtVersion=(5.9 | 5.12 | 5.14) to select the version of Qt5 that you want to build against.")
  endif()
  set(qt5_version_major "5.12")
  set(qt5_version_full "5.12.4")
  set(qt5_version_short "5.12.4")
  # This variable is used inside the javascript file that performs the Qt installation
  set(qt5_installer_version "qt5.5124")
endif()

# ------------------------------------------------------------------------------
# Qt 5.14.x
# Qt 5.12 is a LTS release
if(Qt514)
  if(Qt599 OR Qt512)
    message(FATAL_ERROR "Please set the -DQtVersion=(5.9 | 5.12 | 5.14) to select the version of Qt5 that you want to build against.")
  endif()
  set(qt5_version_major "5.14")
  set(qt5_version_full "5.14.2")
  set(qt5_version_short "5.14.2")
  # This variable is used inside the javascript file that performs the Qt installation
  set(qt5_installer_version "qt5.5142")
endif()


set(extProjectName "Qt${qt5_version_full}")

if("${INSTALL_QT5}" STREQUAL "OFF" AND "${Qt5_QMAKE_EXECUTABLE}" STREQUAL "")
  message(FATAL_ERROR "INSTALL_QT5=${INSTALL_QT5}\nYou have indicated that Qt5 is already installed. Please use -DQt5_QMAKE_EXECUTABLE=/path/to/qmake cmake variable to point to the location of the qmake(.exe) executable.")
  return()
endif()

if(NOT INSTALL_QT5 AND NOT "${Qt5_QMAKE_EXECUTABLE}" STREQUAL "")

  execute_process(
    COMMAND "${Qt5_QMAKE_EXECUTABLE}" -query QT_VERSION
    OUTPUT_VARIABLE qt5_version_full
    OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_STRIP_TRAILING_WHITESPACE
  )
  execute_process(
    COMMAND "${Qt5_QMAKE_EXECUTABLE}" -query QT_INSTALL_LIBS
    OUTPUT_VARIABLE QT_INSTALL_LIBS
    OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_STRIP_TRAILING_WHITESPACE
  )

  set(extProjectName "Qt${qt5_version_full}")
  message(STATUS "Using Installed ${extProjectName}: -DQt5_QMAKE_EXECUTABLE=${Qt5_QMAKE_EXECUTABLE}" )

  FILE(APPEND ${EMsoft_SDK_FILE} "\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "# Qt5 ${qt5_version_full} Library\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"${QT_INSTALL_LIBS}/cmake/Qt5\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${Qt5_DIR})\n")
  return()
endif()

if("${INSTALL_QT5}")
  message(STATUS "Building: ${extProjectName} ${qt5_version_full}: -DINSTALL_QT5=${INSTALL_QT5}" )
endif()

set(qt5_INSTALL "${EMsoft_SDK}/${extProjectName}${qt5_version_full}")
set(qt5_BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build")

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

set(QT_INSTALL_LOCATION "${EMsoft_SDK}/${extProjectName}")

if(APPLE)
  set(qt5_Headless_FILE "apple/Qt_HeadlessInstall_OSX.js")
elseif(WIN32)
  set(qt5_Headless_FILE "win32/Qt_HeadlessInstall_Win64.js")
else()
  set(qt5_Headless_FILE "unix/Qt_HeadlessInstall.js")
endif()

set(QT_MSVC_VERSION_NAME "")
if(MSVC13)
   set(QT_MSVC_VERSION_NAME "msvc2013_64")
endif()
if(MSVC14)
  set(QT_MSVC_VERSION_NAME "msvc2015_64")
endif()
if(MSVC_VERSION GREATER 1900)
  set(QT_MSVC_VERSION_NAME "msvc2017_64")
endif()

set(JSFILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.js")
configure_file(
  "${_self_dir}/${qt5_Headless_FILE}"
  "${JSFILE}"
  @ONLY
)

if(APPLE)
  set(qt5_url "http://qt.mirror.constant.com/archive/qt/${qt5_version_major}/${qt5_version_short}/qt-opensource-mac-x64-${qt5_version_full}.dmg")

  set(Qt5_OSX_BASE_NAME qt-opensource-mac-x64-${qt5_version_full})

  set(Qt5_OSX_DMG_ABS_PATH "${EMsoft_SDK}/superbuild/${extProjectName}/${Qt5_OSX_BASE_NAME}.dmg")
  set(Qt5_DMG ${Qt5_OSX_DMG_ABS_PATH})

  configure_file(
    "${_self_dir}/apple/Qt5_osx_install.sh.in"
    "${CMAKE_BINARY_DIR}/Qt5_osx_install.sh"
    @ONLY
  )


  if(NOT EXISTS "${Qt5_DMG}")
    message(STATUS "===============================================================")
    message(STATUS "    Downloading ${extProjectName} Offline Installer")
    message(STATUS "    ${qt5_url}")
    message(STATUS "    Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${qt5_url} "${Qt5_DMG}" SHOW_PROGRESS)
  endif()


  if(NOT EXISTS "${QT_INSTALL_LOCATION}/${qt5_version_short}/clang_64/bin/qmake")
    message(STATUS "    Running Qt5 Installer. A GUI Application will pop up on your machine.")
    message(STATUS "    This may take some time for the installer to start.")
    message(STATUS "    Please wait for the installer to finish.")
    execute_process(COMMAND "${CMAKE_BINARY_DIR}/Qt5_osx_install.sh"
                    OUTPUT_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt5-offline-out.log"
                    ERROR_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt5-offline-err.log"
                    ERROR_VARIABLE mount_error
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )

  endif()
  set(Qt5_QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/${qt5_version_short}/clang_64/bin/qmake)

elseif(WIN32)
  set(qt5_online_installer "qt-opensource-windows-x86-${qt5_version_full}.exe")
  set(qt5_url "http://qt.mirror.constant.com/archive/qt/${qt5_version_major}/${qt5_version_short}/qt-opensource-windows-x86-${qt5_version_full}.exe")

  if(NOT EXISTS "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}")
    message(STATUS "===============================================================")
    message(STATUS "   Downloading ${extProjectName}")
    message(STATUS "   Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${qt5_url} "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}" SHOW_PROGRESS)
  endif()

  set(QT5_ONLINE_INSTALLER "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}")
  configure_file(
    "${_self_dir}/win32/Qt_HeadlessInstall.bat"
    "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.bat"
    @ONLY
  )

  if(NOT EXISTS "${EMsoft_SDK}/${extProjectName}")
    message(STATUS "Executing the Qt5 Installer... ")
    execute_process(COMMAND "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.bat"
                    OUTPUT_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/qt-unified-out.log"
                    ERROR_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/qt-unified-err.log"
                    ERROR_VARIABLE installer_error
                    WORKING_DIRECTORY ${qt5_BINARY_DIR} )
  endif()
  set(Qt5_QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/${qt5_version_short}/${QT_MSVC_VERSION_NAME}/bin/qmake.exe)
else()
  set(qt5_online_installer "qt-opensource-linux-x64-${qt5_version_full}.run")
  set(qt5_url "http://qt.mirror.constant.com/archive/qt/${qt5_version_major}/${qt5_version_short}/${qt5_online_installer}")

  if(NOT EXISTS "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}")
    message(STATUS "===============================================================")
    message(STATUS "   Downloading ${extProjectName}")
    message(STATUS "   Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${qt5_url} "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}" SHOW_PROGRESS)
  endif()

  set(QT5_ONLINE_INSTALLER "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}")
  configure_file(
    "${_self_dir}/unix/Qt5_linux_install.sh.in"
    "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.sh"
  )

  if(NOT EXISTS "${EMsoft_SDK}/${extProjectName}")
    message(STATUS "Executing the Qt5 Installer... ")
    execute_process(COMMAND "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.sh"
                    OUTPUT_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/qt-unified-out.log"
                    ERROR_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/qt-unified-err.log"
                    ERROR_VARIABLE installer_error
                    WORKING_DIRECTORY ${qt5_BINARY_DIR} )
    message(STATUS "installer_error: ${installer_error}")
  endif()

  set(Qt5_QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/${qt5_version_short}/gcc_64/bin/qmake)
endif()


ExternalProject_Add(Qt5

  TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Download"
  SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source"
  BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build"
  INSTALL_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Install"

  DOWNLOAD_COMMAND ""
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  TEST_COMMAND ""
  )

#-- Append this information to the EMsoft_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# Qt ${qt5_version_full} Library\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK}/${extProjectName}/${qt5_version_short}/clang_64/lib/cmake/Qt5\" CACHE PATH \"\")\n")
  set(Qt5_DIR "${EMsoft_SDK}/${extProjectName}/${qt5_version_short}/clang_64/lib/cmake/Qt5" CACHE PATH "")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK}/${extProjectName}/${qt5_version_short}/${QT_MSVC_VERSION_NAME}/lib/cmake/Qt5\" CACHE PATH \"\")\n")
  set(Qt5_DIR "${EMsoft_SDK}/${extProjectName}/${qt5_version_short}/${QT_MSVC_VERSION_NAME}/lib/cmake/Qt5" CACHE PATH "")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK}/${extProjectName}/${qt5_version_short}/gcc_64/lib/cmake/Qt5\" CACHE PATH \"\")\n")
  set(Qt5_DIR "${EMsoft_SDK}/${extProjectName}/${qt5_version_short}/gcc_64/lib/cmake/Qt5" CACHE PATH "")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${Qt5_DIR})\n")


