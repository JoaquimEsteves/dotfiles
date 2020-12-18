#!/usr/bin/python3

from pathlib import Path
import stat
import os


def add_script_to_path(script_path: str) -> int:
    """
    Quickly add a script to `~/.local/bin` as a symbolic link
    """
    proper_path = Path(script_path).resolve()
    final_path = Path("~/.local/bin/" + Path(script_path).stem).expanduser()
    if not proper_path.exists():
        raise Exception(f'{proper_path} is not a valid path!')
    if final_path.exists():
        raise Exception(f'{final_path} already exists!')
    if not os.access(proper_path, os.X_OK):
        # Give the file the proper access
        proper_path.chmod(proper_path.stat().st_mode | stat.S_IEXEC)

    # Finally, create symlink
    print('Creating the following Symlink:')
    print(f'{proper_path} -> {final_path}')
    print('[Y/y]?')
    if input() not in ('Y','y'):
        print('Goodbye')
        return 1
    os.symlink(proper_path, final_path)
    return 0

if __name__ == "__main__":
    import sys
    sys.exit(add_script_to_path(sys.argv[1]))


