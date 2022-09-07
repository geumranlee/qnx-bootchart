#!/bin/sh

execute_dir=/usr_data
boot_script=bootchart_tool/application_start.sh

script_modify()
{
	echo "Start bootchart" >> $boot_script
	echo "cd /usr_data/bootchart_tool" >> $boot_script
	echo "./bootchartd cap &" >> $boot_script
	echo "cd -" >> $boot_script
}

setup()
{
	echo ">>> bootchart_helper.sh - copy bootchart_tool to $execute_dir"
	scp -P 10022 -r bootchart_tool root@192.168.105.100:/$execute_dir
	#ssh -p 10022 root@192.168.105.100 $execute_dir/bootchart_tool/board_setup.sh
}

run()
{
	echo ">>> bootchart_helper.sh: bootchartd start"
	ssh -p 10022 root@192.168.105.100 $execute_dir/bootchart_tool/run.sh
}

restore()
{
	ssh -p 10022 root@192.168.105.100 $execute_dir/bootchart_tool/board_setup.sh restore
}

ssh_connect()
{
	ssh -p 10022 root@192.168.105.100
}

log_copy()
{
	echo ">>> bootchart_helper.sh: copy log files to host"
	if [ -e bootchart ]; then
		rm -rf bootchart
	fi
	scp -P 10022 -r root@192.168.105.100:/log/bootchart .
}

gen_svg()
{
	echo ">>> bootchart_helper.sh: generate bootchart in svg format"
	OUTPUT_PATH=bootchart.svg
	./pybootchartgui.py --no-prune --show-pid --format svg bootchart -o $OUTPUT_PATH
	ls -al $OUTPUT_PATH
}

display_help()
{
	echo " bootchart_helper.sh usage: $0 {setup|run|svg}"
	echo "  -to profile a running system, run:"
	echo "   1) ./bootchartd setup"
	echo "   2) ./bootchartd run"
	echo "      ex) ./bootchartd run(default)"
	echo "      ex) ./bootchartd run -m 2 -t 10 start"
	echo "      ex) ./bootchartd run -m 2 start sleep 10"
	echo "   3) ./bootchartd svg"
	echo "  -run options:"
	echo "   -m capture mode"
	echo "     1: capture from boottime"
	echo "     2: capture from bootchartd starttime(default)"
	echo "     3: capture after bootchartd start time and include boottime data"
	echo "   -t capture time(sec)(default: 10sec)"
	echo "   -o output log path(default: /log/bootchart)"
}

case "$1" in
       "setup")
               #script_modify
               setup
               ;;
       "run")
               run
               ;;
       "copy")
               log_copy
               ;;
       "ssh")
               ssh_connect
               ;;
       "svg")
	       log_copy
               gen_svg
               ;;
       "restore")
               restore
               ;;
       *)
               display_help
               ;;
esac
