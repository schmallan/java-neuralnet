cmake_minimum_required(VERSION 3.26)
project(selectivePressure C CXX)

find_package(SDL3 REQUIRED)

add_executable(selectivePressure)

#note: target sources are CASE SENSITIVE (make sure to capitalize the .C)
target_sources(selectivePressure
PRIVATE
    selectivePressure.C
    render.C
    body.C
    world.C
    neural.C
)

target_link_libraries(selectivePressure SDL3::SDL3)