#!/bin/bash

# Remove directory structure
rm_dir_structure() {
	if [ -d ./test/test-artifacts/test-dir ] 
	then
		echo -e "\nRemoving pre-existing directory structure..."
		rm -rv './test/test-artifacts/test-dir'
	fi
}
