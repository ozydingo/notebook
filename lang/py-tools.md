# pipenv
https://pipenv.readthedocs.io/en/latest/install/

# pyenv

`pyenv install 2.7.12`
pyenv build failed, consult https://github.com/pyenv/pyenv/wiki/Common-build-problems:
`brew install readline xz`
> already installed

> When running Mojave or higher (10.14+) you will also need to install the additional SDK headers by downloading them from Apple Developers. You can also check under /Library/Developer/CommandLineTools/Packages/ as some versions of Mac OS will have the pkg locally.

Run `sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /`, then `pyenv install 2.7.12` succeeded.
