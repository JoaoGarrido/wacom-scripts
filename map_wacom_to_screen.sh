#!/bin/sh
n_monitors=$(xrandr --listactivemonitors | head -1 | cut -d' ' -f2)
max_monitor_id=$(($n_monitors-1))
echo "Choose monitor to map wacom to (0-$max_monitor_id):"
xrandr --listactivemonitors | tail -$n_monitors | cut -d' ' -f2,6
read monitor_id
if (( $monitor_id > $max_monitor_id || $monitor_id < 0)); then
	echo "Wrong input. Default to primary screen"
	monitor_name=$(xrandr | grep "primary"| awk '{print $1;}')
else 
	sed_args="$(($monitor_id+1))q;d"
	monitor_name=$(xrandr --listactivemonitors | tail -$n_monitors | awk 'NF{ print $NF }' | sed "$sed_args")
fi
echo Mapping to $monitor_name
xinput | grep Wacom | cut -d "=" -f2 | awk '{print $1;}' | xargs -I '{}' xinput map-to-output '{}' $monitor_name
