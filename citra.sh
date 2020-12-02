#!/usr/bin/env bash


#

rp_module_id="citra"
rp_module_desc="3ds emulator"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to  $romdir/3ds"
rp_module_licence="GPL2 https://github.com/citra-emu/citra/blob/master/license.txt"
rp_module_section="exp"

function _params_lr-desmume() {
    local params=()
    isPlatform "arm" && params+=("platform=armvhardfloat")
    isPlatform "aarch64" && params+=("DENABLE_QT=OFF")
    echo "${params[@]}"
}

function depends_lr-desmume() {
    if compareVersions $__gcc_version lt 7; then
        md_ret_errors+=("Sorry, you need an OS with gcc 7.0 or newer to compile citra")
        return 1
    fi

    # Additional libraries required for running
    local depends=(libsdl2-dev doxygen qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev build-essential clang libc++-dev cmake qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev)
    getDepends "${depends[@]}"
}

function sources_lr-desmume() {
    gitPullOrClone "$md_build" https://github.com/libretro/citra.git
}

function build_lr-desmume() {
    cd desmume/src/frontend/libretro
    make clean
    make $(_params_lr-desmume)
    md_ret_require="$md_build/desmume/src/frontend/libretro/citra_libretro.so"
}

function install_lr-desmume() {
    md_ret_files=(
        'desmume/src/frontend/libretro/citra_libretro.so'
    )
}

function configure_lr-desmume() {
    mkRomDir "3ds"
    ensureSystemretroconfig "3ds"

    addEmulator 0 "$md_id" "3ds" "$md_inst/citra_libretro.so"
    addSystem "3ds"
}


 
