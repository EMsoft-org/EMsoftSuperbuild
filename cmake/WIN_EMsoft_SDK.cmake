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
# These settings are specific to DREAM3D. DREAM3D needs these variables to
# configure properly.
set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()

