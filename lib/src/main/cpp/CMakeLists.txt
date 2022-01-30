cmake_minimum_required(VERSION 3.10.2)
project("libqalculate")

include(ExternalProject)

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
        URL https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz
        URL_HASH MD5=03a31d8cbaf29d136252f8f38875ed82
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
        URL https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.xz
        URL_HASH MD5=bdd3d5efba9c17da8d83a35ec552baef
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







ExternalProject_Add(xz
        URL https://fossies.org/linux/misc/xz-5.2.5.tar.xz
        URL_HASH MD5=aa1621ec7013a19abab52a8aff04fe5b
        CONFIGURE_COMMAND ${CROSS_COMPILE_PREFIX} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --host ${ANDROID_LLVM_TRIPLE}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        STEP_TARGETS install
        )
ExternalProject_Get_property(xz INSTALL_DIR)
set(XZ_INSTALL_DIR ${INSTALL_DIR})

add_library(liblzma SHARED IMPORTED)
add_dependencies(liblzma xz-install)
IF(NOT EXISTS "${XZ_INSTALL_DIR}/lib/liblzma.so")
file(WRITE ${XZ_INSTALL_DIR}/lib/liblzma.so "")
ENDIF()
file(MAKE_DIRECTORY ${XZ_INSTALL_DIR}/include)
set_target_properties(liblzma PROPERTIES
        IMPORTED_LOCATION "${XZ_INSTALL_DIR}/lib/liblzma.so"
        INTERFACE_INCLUDE_DIRECTORIES "${XZ_INSTALL_DIR}/include")




ExternalProject_Add(iconv
        URL https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz
        URL_HASH MD5=7d2a800b952942bb2880efb00cfd524c
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
        URL ftp://xmlsoft.org/libxml2/libxml2-2.9.12.tar.gz
        URL_HASH MD5=f433a39be087a9f0b197eb2307ad9f75
        CONFIGURE_COMMAND ${CROSS_COMPILE_PREFIX} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --host ${ANDROID_LLVM_TRIPLE}  --without-python --with-lzma=${XZ_INSTALL_DIR}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        STEP_TARGETS install
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
        URL https://github.com/Qalculate/libqalculate/releases/download/v3.22.0/libqalculate-3.22.0.tar.gz
        URL_HASH MD5=447a0cd929b5bf855fb9463d56143b00
        PATCH_COMMAND patch <SOURCE_DIR>/libqalculate/util.cc < ${CMAKE_CURRENT_LIST_DIR}/liqalculate_util.patch
        CONFIGURE_COMMAND ${CROSS_COMPILE_PREFIX} <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --host ${ANDROID_LLVM_TRIPLE} --without-icu --without-libcurl --without-libintl-prefix CPPFLAGS=${QALCULATE_CPPFLAGS} LDFLAGS=${QALCULATE_LDFLAGS} LIBXML_CFLAGS=${QALCULATE_LIBXML_CFLAGS} LIBXML_LIBS=${QALCULATE_LIBXML_LIBS}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        STEP_TARGETS install
        DEPENDS libgmp libmpfr libiconv libxml2
        )
ExternalProject_Get_property(qalculate INSTALL_DIR)
set(QALCULATE_INSTALL_DIR ${INSTALL_DIR})

add_library(libqalculate SHARED IMPORTED)
add_dependencies(libqalculate qalculate-install)
file(WRITE ${QALCULATE_INSTALL_DIR}/lib/libqalculate.so "")
file(MAKE_DIRECTORY ${QALCULATE_INSTALL_DIR}/include)
set_target_properties(libqalculate PROPERTIES
        IMPORTED_LOCATION "${QALCULATE_INSTALL_DIR}/lib/libqalculate.so"
        INTERFACE_INCLUDE_DIRECTORIES "${QALCULATE_INSTALL_DIR}/include")


add_library(libqalculate-test
        SHARED
        native-lib.cpp)

add_dependencies(libqalculate-test libgmp libmpfr liblzma libiconv libxml2 libqalculate)

find_library(log-lib log)

target_link_libraries(libqalculate-test

        ${log-lib}
        libqalculate)