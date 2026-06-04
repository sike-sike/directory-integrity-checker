#!/bin/bash

# verify_signature <GPG_HOME> <KEY_ID/KEY_FILE> <KEY_IN_KEYRING> <DIRECTORY_PATH>
verify_directory_integrity() {
	GPG_HOME=$1
	# PUBKEY_ID=$2
	# PUBKEY_FILE=$2
	KEY_IN_KEYRING=$3
	DIRECTORY_PATH=$4

	if [ ! -d $DIRECTORY_PATH ]
	then
		echo "Directory path does not exist"
		return 1
	fi

	FILE_TO_VERIFY="$DIRECTORY_PATH/manifest.sha256"
	SIG_FILE="$FILE_TO_VERIFY.asc"

	VERIFICATION_OUTPUT=""

	if [ $KEY_IN_KEYRING == true ]
	then
		PUBKEY_ID=$2
		if [ ! gpg --home_dir=$GPG_HOME --list-keys $PUBKEY_ID > /dev/null 2>&1 ]
		then
			echo "Key not found in the keyring"
			return 1
		else
			VERIFICATION_OUTPUT=$(gpg --homedir="$GPG_HOME" --batch --status-fd 1 --verify "$SIG_FILE" "$FILE_TO_VERIFY" 2>/dev/null)
		fi
	else
		PUBKEY_FILE=$2
		if [ ! -f $PUBKEY_FILE ]
		then
			echo "Key file not found"
			return 1
		else
			VERIFICATION_OUTPUT=$(gpg --homedir="$GPG_HOME" --batch --status-fd 1 --no-default-keyring --keyring "$PUBKEY_FILE" --verify "$SIG_FILE" "$FILE_TO_VERIFY" 2>/dev/null)
		fi
	fi
	
	# We use --status-fd 1 to get machine-readable output 
	# then grep for 'VALIDSIG' followed by our fingerprint.
	# This ensures the signature is not just 'good', but belongs to our specific key.

	echo "Verifying signature..."
	echo "Verifying $FILE_TO_VERIFY..."
	echo $VERIFICATION_OUTPUT

	if echo "$VERIFICATION_OUTPUT" | grep -q "VALIDSIG $KEY_ID"; then
	    echo "✅ Success: Signature is valid and matches the expected fingerprint."
	    python3 './src/__main__.py' -V $DIRECTORY_PATH
	else
	    echo "❌ CRITICAL ERROR: Signature verification failed or fingerprint mismatch!"
	    return 1
	fi
}
