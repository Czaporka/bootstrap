#!/usr/bin/env python3
"""Render file `in_file` and dump the result as `out_file`."""
import argparse
import logging
import os
from posixpath import dirname
import sys

from jinja2 import Environment, FileSystemLoader


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("in_file", type=os.path.realpath)
    parser.add_argument("out_file", type=os.path.realpath)
    args = parser.parse_args()

    logging.basicConfig(
        level="INFO",
        format="%(filename)s:%(lineno)d %(levelname)s %(message)s")

    os.makedirs(dirname(args.out_file), exist_ok=True)

    _, ext = os.path.splitext(args.in_file)
    if ext != ".j2":
        if os.path.exists(args.out_file):
            if args.out_file == args.in_file:
                logging.debug(
                    f"{args.in_file}: in_file and out_file are the same...")
                sys.exit(0)
            else:
                os.remove(args.out_file)
        logging.debug(f"{args.in_file}: creating symlink...")
        os.symlink(args.in_file, args.out_file)
        sys.exit(0)

    logging.info(f"{args.in_file}: rendering...")
    with open(args.in_file) as fh:
        input_ = fh.read()

    template = Environment(loader=FileSystemLoader(dirname(args.in_file)))\
        .from_string(input_)
    output = template.render(os=os)

    with open(args.out_file, "w") as fh:
        fh.write(output)
