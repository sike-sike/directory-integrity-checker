#!/bin/bash

main() {
	# Setting the root of the project to the directory before root
	FILE_INTEGRITY_VERIFIER_ROOT="$(dirname $0)/.."
	cd $FILE_INTEGRITY_VERIFIER_ROOT

	local GPG_HOME=""
	local SIGN=false
	local VERIFY=false
	local KEY_ID=""
	local KEY_ID_PROVIDED=false
	local KEY_FILE=""
	local KEY_FILE_PROVIDED=false
	local DIRECTORY_PATH=""
	local DIRECTORY_PATH_PROVIDED=false
	local HELP=false

	while getopts ":SVG:I:F:D:h" opt
	do
		case $opt in
			G)
				GPG_HOME=$OPTARG
				;;
			S) 
				SIGN=true
				;;
			V) 
				VERIFY=true
				;;
			I) 
				KEY_ID=$OPTARG
				KEY_ID_PROVIDED=true
				;;
			F)
				KEY_FILE=$OPTARG
				KEY_FILE_PROVIDED=true
				;;
			D)
				DIRECTORY_PATH=$OPTARG
				DIRECTORY_PATH_PROVIDED=true
				;;
			h)
				HELP=true
				;;
			\?)
				echo "Invalid Option -$OPTARG"
				exit 1
				;;
			:)
				echo "Option -$OPTARG requires an argument"
				exit 1
				;;
		esac
	done

	if [[ $HELP == true && -z "$GPG_HOME" && $SIGN==false && $VERIFY==false && -z "$KEY_ID" && -z "$KEY_FILE" && -z "$DIRECTORY_PATH" ]]
	then
		echo "Help:"
		echo "-S for Signing"
		echo "-V for Verification"
		echo "-I for specifying Key ID"
		echo "-F for specifying Key file"
		echo "-D for specifying the directory path"
		echo "-h for help"
		exit 0
	elif [ $HELP == true ] && [[ -n "$GPG_HOME" || $SIGN==true || $VERIFY==true || -n "$KEY_ID" || -n "$KEY_FILE" || -n "$DIRECTORY_PATH" ]]
	then
		echo "ERROR: Help cannot be displayed with other options"
		exit 1
	fi

	if [[ $HELP=false && -z $GPG_HOME ]]
	then
		echo "ERROR: GPG home directory not specified"
		exit 1
	fi

	if [ ! -d $GPG_HOME ]
	then
		echo "$GPG_HOME does not exist to qualify as home directory for gpg. Exiting..."
		exit 1
	fi

	if [ $KEY_ID_PROVIDED == true ]
	then
		if [[ ! $KEY_ID =~ ^[A-F0-9]{40}$ ]]
		then
			echo "KEY ID does not match appropriate format. Exiting..."
			exit 1
		fi
	elif [ $KEY_FILE_PROVIDED != true ]
	then
		echo "Key ID nor Key file provided. Exiting..."
		exit 1
	fi

	if [ $DIRECTORY_PATH_PROVIDED == true ]
	then
		if [ ! -d $DIRECTORY_PATH ]
		then
			echo "$DIRECTORY_PATH does not exist. Exiting..."
			exit 1
		fi

		if [ $SIGN == true ]
		then
			if [ -n "$KEY_ID" ]
			then
				source ./src/sign_manifest_file.sh

				# sign_file $GPG_HOME $KEY_ID $DIRECTORY_PATH
				if sign_manifest_file "$GPG_HOME" $KEY_ID "$DIRECTORY_PATH"
				then
					echo "Successfully generated SHA256 hashes of files in $DIRECTORY_PATH and signed the manifest file"
				else
					echo "Signing process failed"
					exit 1
				fi
			else
				echo "ERROR: No signing key specified"
			fi

		elif [ $VERIFY == true ]
		then
			source ./src/verify_directory_integrity.sh
			if [ $KEY_ID_PROVIDED == true ]
			then
				# Signature verification function call (With Key ID)

				# verify_signature <GPG_HOME> <KEY_ID> <KEY_IN_KEYRING> <DIRECTORY_PATH>
				if verify_directory_integrity "$GPG_HOME" $KEY_ID true "$DIRECTORY_PATH"
				then
					echo "Verification complete..."
				else
					echo "Verification process could not be completed"
					exit 1
				fi

			elif [ $KEY_FILE_PROVIDED == true ]
			then
				# Signature verification function call (With Key file path)

				# verify_signature <GPG_HOME> <PUBKEY_FILE> <KEY_IN_KEYRING> <DIRECTORY_PATH>
				if verify_directory_integrity "$GPG_HOME" "$KEY_FILE" false "$DIRECTORY_PATH"
				then
					echo "Verification complete..."
				else
					echo "Verification process could not be completed"
					exit 1
				fi

			else
				echo "ERROR: No Key ID or Key File specified."
				exit 1
			fi

		else
			echo "ERROR: Not mentioned the action(-S/-V) to be taken"
			exit 1
		fi
	else
		if [[ $HELP == false && -z $DIRECTORY_PATH ]]
		then
			echo "ERROR: Directory path not specified"
			exit 1
		fi
	fi
}

main "$@"
