#!/bin/bash
timemark=`date +"%d-%b-%Y_%H%M_%S"`
script_name=$(basename -- "$0")

mkdir -p archive

if pidof -x "$script_name" -o $$ >/dev/null;then
   echo "DUPLICATE instance of script already running - exiting..."
   exit 1
fi

echo "START run_h1scripts.sh - ${timemark}"
cd /root/pentest/h1scripts

if ./pull_programs.sh && ./pull_scopes.sh formatted_programs_latest.txt && ./process_scopes.sh formatted_scopes_latest.txt ; then
if [ -s url_list_new_urls.txt ]; then
echo "#running example.sh"
# Enter here what scans you want to run on the latest urls

else
	echo "new url list empty - no scans run"
fi
else
	echo "h1script error"
fi

echo "END run_h1scripts.sh - ${timemark}"
