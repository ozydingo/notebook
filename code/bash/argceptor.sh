args=( "$@" )
first=${args[0]}
args[0]=ONE
echo ${args[*]}
echo "$args"
