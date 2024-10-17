#! /bin/bash

count() {
    echo "$#"
}

echo "\"\$@\": $@"
count "$@"
for arg in "$@"
do
    echo $arg
done
echo -e "\n---\n"

echo "\$@: $@"
count $@
for arg in $@
do
    echo $arg
done
echo -e "\n---\n"

echo "\"\$*\": $*"
count "$*"
for arg in "$*"
do
    echo $arg
done
echo -e "\n---\n"

echo "\$*: $*"
count $*
for arg in $*
do
    echo $arg
done
echo -e "\n---\n"
