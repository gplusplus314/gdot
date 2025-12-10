#!/bin/sh
set -e
set -x
OS=$(uname -s)
OS=${OS,,}
install_nerdfont() {
	ZIP_URL=$1
	FONT_FAMILY=$(echo "$ZIP_URL" | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}')

	if [ "$OS" = "darwin" ]; then
		FONT_DIR="$HOME/Library/Fonts"
	elif [ "$OS" = "linux" ]; then
		FONT_DIR="$HOME/.local/share/fonts/$FONT_FAMILY"
	else
		echo "Unexpected OS when installing font: $OS"
		exit 1
	fi

	TEMP_DIR=$(mktemp -d -t install_nerdfont_XXXXXX)
	echo "TEMP_DIR: $TEMP_DIR"

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
	fc-cache -fv || fc-cache -fv
fi
