
find_library(ALSA_LIB NAMES asound)

add_executable(musicplayer musicplayer.cpp)
add_compile_options(-fomit-frame-pointer -g)
target_link_libraries(musicplayer PUBLIC ${ALSA_LIB})