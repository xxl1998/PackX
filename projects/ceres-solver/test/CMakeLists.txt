cmake_minimum_required(VERSION 3.5)
project(ceres_test)

set(CMAKE_CXX_STANDARD 11)

find_package(Ceres REQUIRED)

include_directories(
  ${CERES_INCLUDE_DIRS}
  ${GLOG_INCLUDE_DIRS}
)

link_directories(
  ${GLOG_LIBRARY_DIRS}
)

add_executable(ceres_test ceres_test.cpp)

target_link_libraries(ceres_test
  ${CERES_LIBRARIES}
  ${GLOG_LIBRARIES}
)
