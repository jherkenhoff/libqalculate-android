cmake_minimum_required(VERSION 3.10.2)
project("libqalculate")

include(ExternalProject)
find_package(SWIG REQUIRED COMPONENTS java)
if(SWIG_FOUND)
    message("SWIG found: ${SWIG_EXECUTABLE}")
endif()
include(UseSWIG)

# C compiler wrapper
set(C_COMPILER_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/c_compiler_wrapper)
file( WRITE  ${C_COMPILER_WRAPPER} "#!/bin/bash\n")
file( APPEND  ${C_COMPILER_WRAPPER} "${CMAKE_C_COMPILER} --target=${CMAKE_C_COMPILER_TARGET} \"$@\"")
execute_process(COMMAND chmod +x ${C_COMPILER_WRAPPER})

# CXX compiler wrapper
set(CXX_COMPILER_WRAPPER ${CMAKE_CURRENT_BINARY_DIR}/cxx_compiler_wrapper)
file( WRITE  ${CXX_COMPILER_WRAPPER} "#!/bin/bash\n")
file( APPEND  ${CXX_COMPILER_WRAPPER} "${CMAKE_CXX_COMPILER} --target=${CMAKE_CXX_COMPILER_TARGET} \"$@\"")
execute_process(COMMAND chmod +x ${CXX_COMPILER_WRAPPER})

set(CROSS_COMPILE_PREFIX CC=${C_COMPILER_WRAPPER} LD=${CMAKE_LD} CXX=${CXX_COMPILER_WRAPPER} AR=${CMAKE_AR} AS=${C_COMPILER_WRAPPER} RANLIB=${CMAKE_RANLIB} STRIP=${CMAKE_STRIP})

ExternalProject_Add(gmp
        URL https://gmplib.org/download/gmp/gmp-6.3.0.tar.gz
        URL_HASH MD5=3390cf8cc96bbec5a9123f2fb22480db
        CONFIGURE_COMMAND ${CROSS_COMPILE_PREFIX} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --host ${ANDROID_LLVM_TRIPLE}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        STEP_TARGETS install
        )
ExternalProject_Get_property(gmp INSTALL_DIR)
set(GMP_INSTALL_DIR ${INSTALL_DIR})

add_library(libgmp SHARED IMPORTED)
add_dependencies(libgmp gmp-install)
IF(NOT EXISTS "${GMP_INSTALL_DIR}/lib/libgmp.so")
file(WRITE ${GMP_INSTALL_DIR}/lib/libgmp.so "")
ENDIF()
file(MAKE_DIRECTORY ${GMP_INSTALL_DIR}/include)
set_target_properties(libgmp PROPERTIES
        IMPORTED_LOCATION "${GMP_INSTALL_DIR}/lib/libgmp.so"
        INTERFACE_INCLUDE_DIRECTORIES "${GMP_INSTALL_DIR}/include")




ExternalProject_Add(mpfr
        URL https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz
        URL_HASH MD5=7c32c39b8b6e3ae85f25156228156061
        CONFIGURE_COMMAND ${CROSS_COMPILE_PREFIX} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --host ${ANDROID_LLVM_TRIPLE} --with-gmp=${GMP_INSTALL_DIR}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        STEP_TARGETS install
        DEPENDS libgmp
        )
ExternalProject_Get_property(mpfr INSTALL_DIR)
set(MPFR_INSTALL_DIR ${INSTALL_DIR})

add_library(libmpfr SHARED IMPORTED)
add_dependencies(libmpfr mpfr-install)
IF(NOT EXISTS "${MPFR_INSTALL_DIR}/lib/libmpfr.so")
file(WRITE ${MPFR_INSTALL_DIR}/lib/libmpfr.so "")
ENDIF()
file(MAKE_DIRECTORY ${MPFR_INSTALL_DIR}/include)
set_target_properties(libmpfr PROPERTIES
        IMPORTED_LOCATION "${MPFR_INSTALL_DIR}/lib/libmpfr.so"
        INTERFACE_INCLUDE_DIRECTORIES "${MPFR_INSTALL_DIR}/include")




ExternalProject_Add(iconv
        URL https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.18.tar.gz
        URL_HASH MD5=1af69958b42981d3c3029ffb4c7ebaed
        CONFIGURE_COMMAND ${CROSS_COMPILE_PREFIX} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --host ${ANDROID_LLVM_TRIPLE}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        STEP_TARGETS install
        )
ExternalProject_Get_property(iconv INSTALL_DIR)
set(ICONV_INSTALL_DIR ${INSTALL_DIR})

add_library(libiconv SHARED IMPORTED)
add_dependencies(libiconv iconv-install)
IF(NOT EXISTS "${ICONV_INSTALL_DIR}/lib/libiconv.so")
file(WRITE ${ICONV_INSTALL_DIR}/lib/libiconv.so "")
ENDIF()
file(MAKE_DIRECTORY ${ICONV_INSTALL_DIR}/include)
set_target_properties(libiconv PROPERTIES
        IMPORTED_LOCATION "${ICONV_INSTALL_DIR}/lib/libiconv.so"
        INTERFACE_INCLUDE_DIRECTORIES "${ICONV_INSTALL_DIR}/include")







ExternalProject_Add(xml2
        URL https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz
        URL_HASH MD5=fcf38f534bb8996984dba978ee3e27f4
        CONFIGURE_COMMAND ${CROSS_COMPILE_PREFIX} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --host ${ANDROID_LLVM_TRIPLE} --without-python --with-iconv=${ICONV_INSTALL_DIR}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        STEP_TARGETS install
        DEPENDS libiconv
        )
ExternalProject_Get_property(xml2 INSTALL_DIR)
set(XML2_INSTALL_DIR ${INSTALL_DIR})

add_library(libxml2 SHARED IMPORTED)
add_dependencies(libxml2 xml2-install)
IF(NOT EXISTS "${XML2_INSTALL_DIR}/lib/libxml2.so")
file(WRITE ${XML2_INSTALL_DIR}/lib/libxml2.so "")
ENDIF()
file(MAKE_DIRECTORY ${XML2_INSTALL_DIR}/include)
set_target_properties(libxml2 PROPERTIES
        IMPORTED_LOCATION "${XML2_INSTALL_DIR}/lib/libxml2.so"
        INTERFACE_INCLUDE_DIRECTORIES "${XML2_INSTALL_DIR}/include")





set(QALCULATE_CPPFLAGS "-I${GMP_INSTALL_DIR}/include -I${MPFR_INSTALL_DIR}/include -I${ICONV_INSTALL_DIR}/include")
set(QALCULATE_LDFLAGS "-L${GMP_INSTALL_DIR}/lib -L${MPFR_INSTALL_DIR}/lib -L${ICONV_INSTALL_DIR}/lib")
set(QALCULATE_LIBXML_CFLAGS "-I${XML2_INSTALL_DIR}/include/libxml2")
set(QALCULATE_LIBXML_LIBS "-L${XML2_INSTALL_DIR}/lib -lxml2")

ExternalProject_Add(qalculate
        URL https://github.com/Qalculate/libqalculate/releases/download/v5.8.2/libqalculate-5.8.2.tar.gz
        URL_HASH MD5=81cdc67904f3de4d9ef68e9cdcd46919
        PATCH_COMMAND patch <SOURCE_DIR>/libqalculate/util.cc < ${CMAKE_CURRENT_LIST_DIR}/src/main/cpp/liqalculate_util.patch
        CONFIGURE_COMMAND ${CROSS_COMPILE_PREFIX} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --host ${ANDROID_LLVM_TRIPLE} --without-icu --without-libcurl --without-libintl-prefix --enable-compiled-definitions CPPFLAGS=${QALCULATE_CPPFLAGS} LDFLAGS=${QALCULATE_LDFLAGS} LIBXML_CFLAGS=${QALCULATE_LIBXML_CFLAGS} LIBXML_LIBS=${QALCULATE_LIBXML_LIBS}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        STEP_TARGETS install
        DEPENDS libgmp libmpfr libiconv libxml2
        )
# Copy qalculate xml files to asset directory
#ExternalProject_Add_Step(qalculate copy_assets
#        COMMAND ${CMAKE_COMMAND} -E copy_directory <INSTALL_DIR>/share/qalculate ${PROJECT_SOURCE_DIR}/src/main/assets
#        DEPENDS install
#        ALWAYS true
#        )
ExternalProject_Get_property(qalculate INSTALL_DIR)
set(QALCULATE_INSTALL_DIR ${INSTALL_DIR})


add_library(libqalculate SHARED IMPORTED)
add_dependencies(libqalculate qalculate-install)
IF(NOT EXISTS "${QALCULATE_INSTALL_DIR}/lib/libqalculate.so")
file(WRITE ${QALCULATE_INSTALL_DIR}/lib/libqalculate.so "")
ENDIF()
file(MAKE_DIRECTORY ${QALCULATE_INSTALL_DIR}/include)
set_target_properties(libqalculate PROPERTIES
        IMPORTED_LOCATION "${QALCULATE_INSTALL_DIR}/lib/libqalculate.so"
        INTERFACE_INCLUDE_DIRECTORIES "${QALCULATE_INSTALL_DIR}/include")

###############################################################################
# SWIG WRAPPER
###############################################################################
set(JAVA_GEN_PACKAGE "com.jherkenhoff.libqalculate")
string(REPLACE "." "/" JAVA_GEN_SUBDIR ${JAVA_GEN_PACKAGE})
list(APPEND CMAKE_SWIG_FLAGS -package ${JAVA_GEN_PACKAGE} -I${QALCULATE_INSTALL_DIR}/include -I${GMP_INSTALL_DIR}/include -I${MPFR_INSTALL_DIR}/include -I${ICONV_INSTALL_DIR}/include)

set(CMAKE_SWIG_OUTDIR ${PROJECT_SOURCE_DIR}/src/main/java/${JAVA_GEN_SUBDIR})
set(SWIG_OUTFILE_DIR ${CMAKE_CURRENT_BINARY_DIR})
set_property(SOURCE ${CMAKE_CURRENT_LIST_DIR}/src/main/cpp/libqalculate.i PROPERTY CPLUSPLUS ON)

swig_add_library(qalculate_swig
        TYPE SHARED
        LANGUAGE java
        SOURCES ${CMAKE_CURRENT_LIST_DIR}/src/main/cpp/libqalculate.i
        )

swig_link_libraries(qalculate_swig libqalculate libgmp libmpfr libiconv libxml2)
add_dependencies(qalculate_swig libqalculate)
