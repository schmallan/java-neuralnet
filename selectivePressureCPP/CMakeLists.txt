cmake_minimum_required(VERSION 3.26)
project(selectivePressure C CXX)

find_package(SDL3 REQUIRED)

add_executable(selectivePressure)

target_sources(selectivePressure
PRIVATE
    selectivePressure.C
    helper.C
)

target_link_libraries(selectivePressure SDL3::SDL3)