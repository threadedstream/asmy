
find_library(ALSA_LIB NAMES asound)

add_executable(musicplayer musicplayer.c)
target_compile_options(musicplayer PUBLIC "-g")
target_link_libraries(musicplayer PUBLIC ${ALSA_LIB})