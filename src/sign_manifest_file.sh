#!/bin/bash

sign_manifest_file() {
	GPG_HOME=$1
	KEY_ID=$2
	DIRECTORY_PATH=$3

	FILE_TO_SIGN=$DIRECTORY_PATH/manifest.sha256
	if [ -f $FILE_TO_SIGN.asc ]
	then
		echo "Deleting previous file signature"
		rm $FILE_TO_SIGN.asc
	fi

	if [ ! -d $DIRECTORY_PATH ]
	then
		echo "$DIRECTORY_PATH does not exist. Exiting..."
		return 1
	fi

	if python3 './src/__main__.py' -H $DIRECTORY_PATH
	then
		echo "Signing the manifest file..."
		KEY_ID=$KEY_ID!
		if gpg --homedir="$GPG_HOME" --local-user $KEY_ID --detach-sign --armour "$FILE_TO_SIGN"
		then
			echo "Successfully signed the manifest file"
		else
			echo "Signing failed"
		fi
	else
		echo "Error: Hashing failed"
		return 1
	fi
}
