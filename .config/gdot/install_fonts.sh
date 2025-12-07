#!/bin/sh
set -e
FONT_DIR="$1"

install_nerdfont() {
	ZIP_URL=$1
	FONT_FAMILY=$(echo "$ZIP_URL" | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}')
	TEMP_DIR="/tmp/nerd-fonts"

	mkdir -p "$TEMP_DIR"
	mkdir -p "$FONT_DIR"
	curl -L "$ZIP_URL" -o "$TEMP_DIR/font.zip"
	unzip "$TEMP_DIR/font.zip" -d "$TEMP_DIR"
	find "$TEMP_DIR" -name "*.ttf" -exec mv {} "$FONT_DIR" \;
	rm -rf "$TEMP_DIR"

}
URL_BASE="https://github.com/ryanoasis/nerd-fonts/releases/download"
install_nerdfont "$URL_BASE/v3.2.1/SourceCodePro.zip"
install_nerdfont "$URL_BASE/v3.2.1/JetBrainsMono.zip"

if [ "$OS" = "linux" ]; then
	echo "Refreshing font cache..."
	fc-cache -fv
fi
