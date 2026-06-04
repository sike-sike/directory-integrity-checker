#!/bin/bash

# Removing directory structure(Optional)
# if [ -d ./test/test-artifacts/test-dir ] 
# then
# 	echo -e "\nRemoving pre-existing directory structure..."
# 	rm -rv './test/test-artifacts/test-dir'
# fi

# Creating directory structure
# if [ ! -d './test/test-artifacts/test-dir' ]
# then
# 	echo -e "\nCreating directory structure..."
# 	mkdir -pv './test/test-artifacts/test-dir/dir1/dir2'
# 	
# 	touch './test/test-artifacts/test-dir/file1.txt' './test/test-artifacts/test-dir/file2.txt' './test/test-artifacts/test-dir/dir1/file3.txt' './test/test-artifacts/test-dir/dir1/file4.txt' './test/test-artifacts/test-dir/dir1/dir2/file5.txt'
# 	
# 	echo 'test_dir_file1' > './test/test-artifacts/test-dir/file1.txt'
# 	echo 'test_dir_file2' > './test/test-artifacts/test-dir/file2.txt'
# 	echo 'dir1_file3' > './test/test-artifacts/test-dir/dir1/file3.txt'
# 	echo 'dir1_file4' > './test/test-artifacts/test-dir/dir1/file4.txt'
# 	echo 'dir2_file5' > './test/test-artifacts/test-dir/dir1/dir2/file5.txt'
# fi

# Testing hasher
test_hasher_verifier() {
	# Source functions for creating and removing directories
	source './test/create_dir_structure.sh'
	source './test/remove_dir_structure.sh'

	# rm_dir_structure
	create_dir_structure

	echo -e '\nTesting manifest file generator...'
	python3 './test/test_manifest_generator.py'
	cat './test/test-artifacts/test-dir/manifest.sha256'
	
	# Testing verifier
	echo -e '\n\nTesting file hash verifier...'
	echo 'dir2_file6' > './test/test-artifacts/test-dir/dir1/dir2/file5.txt' # Corrupt file5.txt
	echo -e 'Corrupted file5.txt. Running verifier.py'
	python3 './test/test_file_hash_verifier.py'
	
	echo 'dir2_file5' > './test/test-artifacts/test-dir/dir1/dir2/file5.txt' # Revert file5.txt
	echo -e 'Reverted file5.txt. Running verifier.py'
	python3 './test/test_file_hash_verifier.py'
}

test_hasher_verifier "$@"
