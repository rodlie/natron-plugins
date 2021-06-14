cmake_minimum_required(VERSION 3.0)
project(natron-plugins VERSION 20210614)
include(GNUInstallDirs)
install(DIRECTORY
    BL Channel Color Draw Filter GLSL Keyer Merge mS Relight SB Time Transform Utility Views V_Tools
    DESTINATION
    ${CMAKE_INSTALL_DATAROOTDIR}/Natron/Plugins
)
install(FILES
    Licenses/GPL-2.0
    Licenses/CC-BY-2.0
    README.md
    DESTINATION
    ${CMAKE_INSTALL_DOCDIR}-${PROJECT_VERSION}
)
