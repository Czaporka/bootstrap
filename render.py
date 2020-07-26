import argparse
from jinja2 import Environment, FileSystemLoader
import os
from posixpath import dirname


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("in_file")
    parser.add_argument("out_file")
    args = parser.parse_args()

    # for k, v in sorted(os.environ.items()):
    #     print(k, v, sep="\t")

    with open(args.in_file) as fh:
        input_ = fh.read()

    template = Environment(loader=FileSystemLoader(dirname(args.in_file)))\
        .from_string(input_)
    output = template.render(os=os)

    os.makedirs(dirname(args.out_file), exist_ok=True)
    with open(args.out_file, "w") as fh:
        fh.write(output)
