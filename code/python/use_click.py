#!/usr/bin/env python

import click

@click.command()
@click.option("-x", default="x")
@click.option("-y", default="y")
def cli(y, x):
  print("hello")
  print(f"x: {x}")
  print(f"y: {y}")

if __name__ == "__main__":
  cli()
