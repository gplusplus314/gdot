#!/usr/bin/env bash

MAIN_DIR="$HOME/.gdot"
BACKUP_DIR="$HOME/.gdot_backup"

cd $HOME
rm -rf $MAIN_DIR
git clone --bare https://github.com/gplusplus314/gdot $MAIN_DIR

function gdot {
	git --git-dir=$MAIN_DIR --work-tree=$HOME $@
}

function doCheckout {
	gdot checkout
	if [ $? = 0 ]; then
		echo "Checked out gdot dotfiles..."
	else
		echo "Backing up pre-existing dotfiles."
		FILES=$(gdot checkout 2>&1 | grep -Po "^\s+(\S+)\$" | awk {'print $1'})
		for FILE in $FILES; do
			DIR=$(dirname $FILE)
			mkdir -p $BACKUP_DIR/$DIR
			mv $FILE $BACKUP_DIR/$FILE
		done
		doCheckout
	fi
}
doCheckout

gdot config status.showUntrackedFiles no
