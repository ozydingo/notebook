import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('one', nargs='?', type=int, default=None)

args = parser.parse_args()
print args
