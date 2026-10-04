#!/bin/bash

create_gpg_home_directory() {
	if [ ! -d './test/test-artifacts/.gnupg' ] 
	then
	    mkdir -pv .'/test/test-artifacts/.gnupg'
	fi
}

gpg_generate_key() {
	gpg --homedir='./tests/test-artifacts/.gnupg' --gen-key --batch <<EOF
	Key-Type: RSA
	Key-Length: 4096
	Name-Real: John Doe
	Name-Email: john@example.com
	Expire-Date: 2d
	%no-protection
EOF
}

gpg_generate_key
