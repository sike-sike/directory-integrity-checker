import os
import sys
import argparse
from pathlib import Path

from manifest_generator import create_manifest
from verify_file_hashes import verify_manifest

def main():
    # Initialize the parser
    parser = argparse.ArgumentParser(description="Process path and choose between hashing and verifying.")

    # Add the path argument
    parser.add_argument("path", help="The directory path to process")

    # Add the mutually exclusive group for -H and -V
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-H", "--hash", action="store_true", help="Select hashing mode")
    group.add_argument("-V", "--verify", action="store_true", help="Select verification mode")

    args = parser.parse_args()

    # Logic to exit if directory does not exist
    if not os.path.isdir(args.path):
        print(f"Error: The path {args.path} is not a valid directory")
        sys.exit(1)

    # Logic to handle the selection
    if args.hash:
        create_manifest(Path(args.path))
    else:
        verify_manifest(Path(args.path))

    return 0

if __name__ == "__main__":
    sys.exit(main())
