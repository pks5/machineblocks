#!/usr/bin/env python3
import argparse
import os
import sys

from mb.commands.examples import register_examples
from mb.commands.thumbnails import register_thumbnails

USAGE_TEMPLATE = """
USAGE:
  {prog} examples render <path>
      Render .scad files from a JSON file or recursively from all JSON files in a directory.

  {prog} thumbnails generate <path> [--target-dir DIR] [--image-width N] [--image-height N] [--image-border N] [--font-path PATH]
      Generate thumbnails (PIL-based). Defaults match the original bash script.

Examples:
  {prog} examples render ./examples.json
  {prog} examples render ./examples/
  {prog} thumbnails generate ./assets
  {prog} thumbnails generate ./assets --target-dir ./out --image-width 2400 --image-height 1800 --image-border 60
"""

def _print_usage_and_exit(msg: str = None, code: int = 2):
    prog = os.path.basename(sys.argv[0]) or "mbcli"
    if msg:
        print(msg)
    print(USAGE_TEMPLATE.format(prog=prog))
    sys.exit(code)

def main():
    parser = argparse.ArgumentParser("mb", add_help=True)
    lvl1 = parser.add_subparsers(dest="command")

    # Top-Level Commands registrieren
    register_examples(lvl1)
    register_thumbnails(lvl1)

    args, unknown = parser.parse_known_args()

    if args.command is None:
        if unknown and not unknown[0].startswith("-"):
            _print_usage_and_exit(f"Error: unknown command '{unknown[0]}'.")
        _print_usage_and_exit("Error: no command provided.")

    handler = getattr(args, "command_handler", None)
    if callable(handler):
        handler(args, unknown, _print_usage_and_exit)
    else:
        _print_usage_and_exit("Error: no handler for command.", 2)
    print("hello")

if __name__ == "__main__":
    main()
