#!/bin/bash

# Creating directory structure
create_dir_structure() {
	if [ ! -d './test/test-artifacts/test-dir' ]
	then
		echo -e "\nCreating directory structure..."
		mkdir -pv './test/test-artifacts/test-dir/dir1/dir2'
		
		touch './test/test-artifacts/test-dir/file1.txt' './test/test-artifacts/test-dir/file2.txt' './test/test-artifacts/test-dir/dir1/file3.txt' './test/test-artifacts/test-dir/dir1/file4.txt' './test/test-artifacts/test-dir/dir1/dir2/file5.txt'
		
		echo 'test_dir_file1' > './test/test-artifacts/test-dir/file1.txt'
		echo 'test_dir_file2' > './test/test-artifacts/test-dir/file2.txt'
		echo 'dir1_file3' > './test/test-artifacts/test-dir/dir1/file3.txt'
		echo 'dir1_file4' > './test/test-artifacts/test-dir/dir1/file4.txt'
		echo 'dir2_file5' > './test/test-artifacts/test-dir/dir1/dir2/file5.txt'
	fi
}
