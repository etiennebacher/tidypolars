from pathlib import Path

with Path("file").open("w") as f:
    for line in lines:
        f.write(line)
