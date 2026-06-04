# Directory Integrity Verifier

## Fetching the repository
```
git clone https://github.com/sike-sike/directory-integrity-checker.git
```

## Signing Key availability
First sign ensure key is available in your keyring for signing files. Use apropriate `GNUPGHOME` directory

## Runnign signer or verifier
The Script for signing/verifying the integrity of given directory is `src/file_integrity_checker.sh`

1. Make the script executable by
```
chmod 700 ./src/file_integrity_checker.sh
```
2. Run the script with appropriatie flags
Example
```
./file_integrity_checker.sh -G '<GPG HOME DIRECTORY PATH>' -D '<DIRECTORY PATH>' -I <KEY FINGERPRINT> -S
```

## Flags

### GPG home directory
> Use `-G <GPG HOME DIRECTORY PATH>` to specify GPG home directory to be used`

### Directory to be verified
> Use `-D <DIRECTORY PATH>` to specify the directory for which the integrity is to be checked

### Specifying Keys
> If Public key is available in the keyring, mention the key ID(Use full fingerprint) using `-I <PUBLIC KEY ID>`
> Otherwise, specify a key using `-F <KEY FINGERPRINT>`

### Signing or verification
> Use `-S` for signing
> Use `-V` for verifying
