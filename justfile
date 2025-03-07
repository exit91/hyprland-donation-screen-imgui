_default:
    just --list

build-and-run:
    just clean && just configure && just build && just run

configure:
    meson setup ./build --reconfigure --buildtype=release

build:
    cd build && ninja

run:
    ./build/hypr-donate-pls

clean:
    rm ./build ./.cache -rf
