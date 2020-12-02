#!/usr/bin/env bash


#

rp_module_id="citra"
rp_module_desc="3ds emulator"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to  $romdir/3ds"
rp_module_licence="GPL2 https://github.com/citra-emu/citra/blob/master/license.txt"
rp_module_section="exp"
rp_module_flags="!arm"

function depends_citra() {
    if compareVersions $__gcc_version lt 7; then
        md_ret_errors+=("Sorry, you need an OS with gcc 7.0 or newer to compile citra")
        return 1
    fi

    # Additional libraries required for running
    local depends=(libsdl2-dev doxygen qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev build-essential clang libc++-dev cmake qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev)
    getDepends "${depends[@]}"
}

function sources_citra() {
    gitPullOrClone "$md_build" https://github.com/citra-emu/citra.git
}

function build_citra() {
    cd "$md_build/citra"
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    make
    md_ret_require="$md_build/build/bin"

}

function install_citra() {
      md_ret_files=(
      '/build/bin/citra'
      '/build/bin/citra-qt'
      ''
      )

}

function configure_citra() {

    mkRomDir "3ds"

    ensureSystemretroconfig "3ds"



    addEmulator 0 "$md_id" "3ds" "$md_inst/citra %ROM%"
    addEmulator 1 "$md_id-qt" "3ds" "$md_inst/citra-qt %ROM%"
    addSystem "3ds"


}
