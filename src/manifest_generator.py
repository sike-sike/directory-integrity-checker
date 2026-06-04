from pathlib import Path
import hashlib

def get_sha256(file_path):
    sha256_hash = hashlib.sha256()
    with file_path.open("rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

def create_manifest(directory):
    manifest_file = directory / 'manifest.sha256'

    manifest_lines = []
    
    # Collect all hashes (excluding the manifest itself)
    for file_path in directory.rglob('*'):
        if file_path.is_file() and file_path != manifest_file:
            # Store relative path to keep the manifest portable
            rel_path = file_path.relative_to(directory)
            digest = get_sha256(file_path)
            manifest_lines.append(f"{digest}  {rel_path}")
    
    manifest_content = "\n".join(manifest_lines)
    
    with manifest_file.open("w") as f:
        f.write(str(manifest_content))
    print(f"Manifest created at {manifest_file}")
