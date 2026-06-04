*All commands to be executed from **root** of the project*

# Ensure Directory is created with appropriate permissions
```
mkdir './test/test-artifacts/.gnupg --mode=700
```


# Create a key for testing,
*Optional(Creation & Removal of .gnupg)*
```
if [ ! -d './test/test-artifacts/.gnupg' ] 
then
    mkdir -pv .'/test/test-artifacts/.gnupg'
fi
```
```
gpg --homedir='./test/test-aritfacts/.gnupg' --gen-key --batch <<EOF
Key-Type: RSA
Key-Length: 4096
Name-Real: John Doe
Name-Email: john@example.com
Expire-Date: 0
%no-protection
EOF
```

# Get the fingerprint of the created key
```
gpg --homedir='./test/test-aritfacts/.gnupg' --with-colons --with-subkey-fingerprints --list-keys | awk -F: '/^sub:/ {subkey_id=$5} /^fpr:/ && subkey_id {last_fpr=$10} END {print last_fpr}'
```

# Export the key in a file or write the key fingerprint to .testenv file
```
gpg --homedir='./test/test-aritfacts/.gnupg' --armour --export $FINGERPRINT > './test/test-artifacts/mainifest.sha256.asc'
```

# Sign the the manifest file
```
gpg --homedir='./test/test-aritfacts/.gnupg' -u $FINGERPRINT --armor --detach-sign './test/test-artifacts/test-dir/manifest.sha256'
```

# To verify the signature,
```
gpg --homedir='./test/test-aritfacts/.gnupg' --verify './test/test-artifacats/test-dir/manifest.sha256.asc' './test/test-artifacts/test-dir/manifest.sha256'
```

# Execute the sha256 verification test
```
./test/test_hash_verifier.sh
```

# Delete keys
```
gpg --homedir='./test/test-aritfacts/.gnupg' --delete-secret-and-public-key $FINGERPRINT --yes
```
*Optional*
```
if [  -d './test/test-artifacts/.gnupg' ]
then
    rm -rv .'/test/test-artifacts/.gnupg'
fi
```
