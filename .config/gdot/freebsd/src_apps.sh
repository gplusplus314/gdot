#!/bin/sh

set -e

. "$HOME/.cargo/env"

mkdir -p ~/src
cd ~/src

mkdir -p github.com/LuaLS
cd github.com/LuaLS
rm -rf lua-language-server-rust
git clone https://github.com/LuaLS/lua-language-server-rust.git
cd lua-language-server-rust
git submodule update --init --recursive
cargo build --release -p luals
mkdir -p ~/.local/bin
ln -s $(pwd)/target/release/lua-language-server ~/.local/bin/lua-language-server
