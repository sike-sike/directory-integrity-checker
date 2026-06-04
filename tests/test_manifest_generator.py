import sys
sys.path.append(".")

from pathlib import Path
from src.manifest_generator import create_manifest

create_manifest(Path("./test/test-artifacts/test-dir"))
