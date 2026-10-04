from pathlib import Path
import hashlib

def verify_manifest(directory):
    manifest_file = directory / 'manifest.sha256'

    if not manifest_file.exists():
        print("Error: Manifest file not found.")
        return

    # Verify individual file integrity
    manifest_lines = manifest_file.read_text().splitlines()
    
    manifest_file_rel_path_list = []

    for line in manifest_lines:
        if not line.strip(): continue
        expected_hash, rel_path = line.split("  ", 1)
        file_path = directory / rel_path

        manifest_file_rel_path_list.append(Path(rel_path))
        
        if not file_path.exists():
            print(f"❌ MISSING: {rel_path}")
            continue
            
        # Calculate current hash
        sha256_hash = hashlib.sha256()
        with file_path.open("rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                sha256_hash.update(chunk)
        
        if sha256_hash.hexdigest() == expected_hash:
            print(f"✅ OK: {rel_path}")
        else:
            print(f"❌ CORRUPT: {rel_path}")

    for most_recent_files_path in directory.rglob('*'):
        if most_recent_files_path.is_file() and most_recent_files_path != manifest_file and most_recent_files_path != (directory / 'manifest.sha256.asc'):

            most_recent_files_rel_path = most_recent_files_path.relative_to(directory)

            if most_recent_files_rel_path not in manifest_file_rel_path_list:
                print(f"🔍 UNTRACKED: {most_recent_files_rel_path}")
