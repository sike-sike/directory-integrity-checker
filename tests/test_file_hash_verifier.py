import sys
sys.path.append(".")

from pathlib import Path
from src.verify_file_hashes import verify_manifest

verify_manifest(Path("./test/test-artifacts/test-dir"))
