#!/bin/bash

create_key_pair() {
	gpg --homedir=$GPG_HOME --batch --gen-key <<EOF
Key-Type: RSA
Key-Length: 1024
Name-Real: John Doe
Name-Email: john@example.com
Subkey-Type: RSA
Subkey-Length: 1024
Expire-Date: 2
%no-protection
EOF

	PUBKEY_FINGERPRINT=$(gpg --homedir=$GPG_HOME --with-colons --with-subkey-fingerprints --list-keys | awk -F: '/^pub:/ { pubkey_id=$1 } pubkey_id && $1=="fpr" { print $10; exit }')

	gpg --homedir './test/test-artifacts/.gnupg' --export $PUBKEY_FINGERPRINT > $PUBKEY_FILE
	
	sed -i "s/^PUBKEY_FINGERPRINT=.*/PUBKEY_FINGERPRINT=${PUBKEY_FINGERPRINT}" './test/.testenv'
}

test_sign_manifest_file() {
	SUBKEY_FINGERPRINT=$(gpg --homedir=$GPG_HOME --with-colons --with-subkey-fingerprints --list-keys | awk -F: '/^sub:/ {subkey_id=$5} /^fpr:/ && subkey_id {last_fpr=$10} END {print last_fpr}')

	# Test the sign_file() function
	sign_manifest_file
	if [ $? -eq $SIGN_SUCCESS ]
	then
		echo "Test pass"
	else
		echo "Test fail"
	fi
}

test_verify_signature()
{
	# Test the verify_signature() function
	verify_directory_integrity
	if [ $? -eq $VERIFY_SUCCESS ]
	then
		echo "Test pass"
	else
		echo "Test fail"
	fi
}

main() {
	source './test/.testenv'
	source './src/verify_directory_integrity.sh'
	source './src/sign_manifest_file.sh'
	
	create_key_pair

	test_sign_manifest_file

	if test_verify_directory_integrity
	then
		'./test/test_hasher_verifier.sh'
	else
		exit 1
	fi
}

main "$@"
