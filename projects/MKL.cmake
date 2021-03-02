
set(mkl_version_major "2019.5")
set(mkl_version_full "2019.5.281")
set(mkl_version_short "2019.5.281")

set(extProjectName "MKL${mkl_version_full}")
message(STATUS "External Project: ${extProjectName}" )

if(APPLE)
  set(mkl_url "http://dream3d.bluequartz.net/binaries/SDK/Sources/intel/m_mkl_${mkl_version_full}.dmg")
elseif(WIN32)
  set(mkl_version_major "2019.4")
  set(mkl_version_full "2019.4.245")
  set(mkl_version_short "2019.4.245")
  set(mkl_url "http://dream3d.bluequartz.net/binaries/SDK/Sources/intel/w_mkl_${mkl_version_full}.exe")
else()
  set(mkl_url "http://dream3d.bluequartz.net/binaries/SDK/Sources/intel/l_mkl_${mkl_version_full}.tgz")
endif()

set(mkl_INSTALL "${EMsoft_SDK}/${extProjectName}${mkl_version_full}")
set(mkl_BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build")

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

set(MKL_INSTALL_LOCATION "${EMsoft_SDK}/intel")

if(APPLE)
  set(mkl_Headless_FILE "apple/mkl_HeadlessInstall_OSX.cfg.in")
elseif(WIN32)
  set(mkl_Headless_FILE "win32/mkl_HeadlessInstall_Win64.cfg.in")
else()
  set(mkl_Headless_FILE "unix/mkl_HeadlessInstall.cfg.in")
endif()

set(MKL_CONFIG_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/mkl_config.cfg")
configure_file(
  "${_self_dir}/${mkl_Headless_FILE}"
  "${MKL_CONFIG_FILE}"
  @ONLY
)


#--------------------------------------------------------------------------------------------------
# APPLE Case First
if(APPLE)
  set(MKL_IS_INSTALLED 0)
  # Let's look around to see if any other Intel Products have been installed on the system
  message(STATUS "|-- Searching for previous Intel MKL Installations... ")
  if(EXISTS "/opt/intel")
    message(STATUS "|-- Found Previous Intel Installation at /opt/intel")
    if(EXISTS "/opt/intel/.pset/db/intel_sdp_products.tgz.db")
      message(STATUS "|-- Reading install log '/opt/intel/.pset/db/intel_sdp_products.tgz.db' ")
      file(STRINGS "/opt/intel/.pset/db/intel_sdp_products.tgz.db" intel_install_log)
      list(LENGTH intel_install_log install_log_length)
      message(STATUS "|-- ${install_log_length} entries in install log. Using the first one to extract install location.")
      list(GET intel_install_log 0 install_line)
      string(REPLACE "|" ";" install_line ${install_line})
      list(GET install_line 3 MKL_INSTALL_LOCATION)
      # Intel likes to end the path with a "/" but that will mess up some other things so get rid of it
      string(REGEX REPLACE "[/]$" "" MKL_INSTALL_LOCATION ${MKL_INSTALL_LOCATION})
      message(STATUS "|-- MKL_INSTALL_LOCATION: ${MKL_INSTALL_LOCATION}")
      set(MKL_IS_INSTALLED 1)
      # since we have a location already, change the install location
      configure_file(
        "${_self_dir}/${mkl_Headless_FILE}"
        "${MKL_CONFIG_FILE}"
        @ONLY
      )

    endif()
  endif()


  set(mkl_OSX_BASE_NAME m_mkl_${mkl_version_full})

  set(mkl_OSX_DMG_ABS_PATH "${EMsoft_SDK}/superbuild/${extProjectName}/${mkl_OSX_BASE_NAME}.dmg")
  set(mkl_DMG ${mkl_OSX_DMG_ABS_PATH})
  set(mkl_INSTALL_SCRIPT "${EMsoft_SDK}/superbuild/${extProjectName}/Download/mkl_osx_install.sh")
  set(MKL_INSTALL_LOG_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/mkl-offline-out.log")
  set(MKL_INSTALL_ERR_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/mkl-offline-err.log")

  configure_file(
    "${_self_dir}/apple/mkl_osx_install.sh.in"
    "${mkl_INSTALL_SCRIPT}"
    @ONLY
  )

  if(NOT EXISTS "${mkl_DMG}" AND NOT MKL_IS_INSTALLED )
    message(STATUS "===============================================================")
    message(STATUS "    Downloading ${extProjectName} Offline Installer")
    message(STATUS "    ${mkl_url}")
    message(STATUS "    Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${mkl_url} "${mkl_DMG}" SHOW_PROGRESS)
  endif()


  if(NOT EXISTS "${MKL_INSTALL_LOCATION}/compilers_and_libraries_${mkl_version_full}")
    message(STATUS "|-- Running MKL Installer. ")
    message(STATUS "|-- This may take some time for the installer to start.")
    message(STATUS "|-- Please wait for the installer to finish.")
    execute_process(COMMAND "${mkl_INSTALL_SCRIPT}"
                    OUTPUT_FILE ${MKL_INSTALL_LOG_FILE}
                    ERROR_FILE ${MKL_INSTALL_ERR_FILE}
                    ERROR_VARIABLE mkl_install_error
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )
    message(STATUS "|-- mkl_install_error: ${mkl_install_error}")
  endif()
  set(MKL_DIR ${MKL_INSTALL_LOCATION}/mkl)
elseif(WIN32) #--------------------------------------------------------------------------------------------------
  # The ONLY configuration that is supported on Windows is Intel Fortran. When ifort
  # is installed MKL is also installed with it so there is no need to actuall7 install
  # MKL at this time. If EMsoft ever supports GFortran on Windows then this will
  # need to be revisited.
  get_filename_component(IFORT_COMPILER_ROOT_DIR ${CMAKE_Fortran_COMPILER} DIRECTORY)
  get_filename_component(IFORT_COMPILER_ROOT_DIR ${IFORT_COMPILER_ROOT_DIR} DIRECTORY)
  get_filename_component(IFORT_COMPILER_ROOT_DIR ${IFORT_COMPILER_ROOT_DIR} DIRECTORY)

  set(MKL_DIR "${IFORT_COMPILER_ROOT_DIR}/mkl")

  # recent (as of spring 2021) ifort changes mean that MKL can be installed in a different location in bundled w/ 'oneAPI'
  # w/ oneAPI the ifort root dir is e.g. C:/Program Files (x86)/Intel/oneAPI/compiler/2021.1.1/windows
  # but the mkl root dir is e.g. C:/Program Files (x86)/Intel/oneAPI/mkl/2021.1.1
  if(NOT EXISTS ${MKL_DIR} AND ${IFORT_COMPILER_ROOT_DIR} MATCHES ".+[/\]Intel[/\]oneAPI[/\]compiler[/\].+[/\]windows")
    get_filename_component(ONE_API_ROOT_DIR ${IFORT_COMPILER_ROOT_DIR} DIRECTORY) # e.g. C:/Program Files (x86)/Intel/oneAPI/compiler/2021.1.1
    get_filename_component(ONE_API_VERSION  ${ONE_API_ROOT_DIR}        NAME     ) # e.g. 2021.1.1
    get_filename_component(ONE_API_ROOT_DIR ${ONE_API_ROOT_DIR}        DIRECTORY) # e.g. C:/Program Files (x86)/Intel/oneAPI/compiler
    get_filename_component(ONE_API_ROOT_DIR ${ONE_API_ROOT_DIR}        DIRECTORY) # e.g. C:/Program Files (x86)/Intel/oneAPI
    set(MKL_DIR "${ONE_API_ROOT_DIR}/mkl/${ONE_API_VERSION}")
  endif()

  # in either case having the value wrong makes debugging much harder down the line
  if(NOT EXISTS ${MKL_DIR})
    message(FATAL_ERROR "failed to determine MKL directory (tried ${MKL_DIR})")
  endif()

else()

endif()


#-- Append this information to the EMsoft_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# MKL ${mkl_version_full} Library\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(MKL_DIR \"${MKL_INSTALL_LOCATION}/mkl\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(INTEL_DIR \"${MKL_INSTALL_LOCATION}\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(MKL_DIR \"${MKL_DIR}\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(MKL_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}/${mkl_version_short}/gcc_64/lib/cmake/MKL\" CACHE PATH \"\")\n")
  set(MKL_DIR "${EMsoft_SDK}/${extProjectName}/${mkl_version_short}/gcc_64/lib/cmake/MKL" CACHE PATH "" FORCE)
endif()
#FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${MKL_DIR})\n")




