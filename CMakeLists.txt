cmake_minimum_required(VERSION 3.8)
project(GPUBURN LANGUAGES CXX)

find_package(PkgConfig REQUIRED)
pkg_check_modules(CUDART REQUIRED cudart-10.0)
pkg_check_modules(CUBLAS REQUIRED cublas-10.0)

set(ENV{CUDACXX} "/usr/local/cuda-10.0/bin/nvcc")
enable_language(CUDA)
link_directories(${CUDART_LIBRARY_DIRS})

add_library(compare OBJECT compare.cu)
set_property(TARGET compare PROPERTY CUDA_PTX_COMPILATION ON)
add_executable(gpu_burn gpu_burn-drv.cpp)

target_include_directories(gpu_burn PUBLIC ${CUDART_INCLUDE_DIRS} ${CUBLAS_INCLUDE_DIRS})
# Note: CUDART_LIBRARIES did not include -lcuda
target_link_libraries(gpu_burn ${CUDART_LIBRARIES} ${CUBLAS_LIBRARIES} -lcuda)

if(NOT DEFINED GPUBURN_INSTALLDIR)
  set(GPUBURN_INSTALLDIR "gpu_burn")
endif()

install(TARGETS gpu_burn RUNTIME DESTINATION "${GPUBURN_INSTALLDIR}")
# Would like to use install(TARGETS compare...) here but that preserves
# the subdirectory structure, which we don't want.
install(FILES $<TARGET_OBJECTS:compare> DESTINATION "${GPUBURN_INSTALLDIR}")

