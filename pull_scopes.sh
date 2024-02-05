#!/bin/bash
filename=$1
timemark=`date +"%d-%b-%Y_%H%M_%S"`
output_file=h1scopes_${timemark}.txt
echo "===== kiyell HackerOne Program scraper                           =====" 
echo "===== Output file: ${output_file}                                ====="
while read line; do
     echo "Scraping Program details: $line "
     curl -s -X GET \
  "https://api.hackerone.com/v1/hackers/programs/$line" \
  -H 'Accept: */*' \
  -u "$h1_secret" \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Host: api.hackerone.com' \
  -H 'User-Agent: PostmanRuntime/7.15.2' \
  -H 'cache-control: no-cache'  2>&1 >> ${output_file}
done < $filename

cat ${output_file} > formatted_scopes_${timemark}.txt
cp formatted_scopes_${timemark}.txt formatted_scopes_latest.txt

## cleanup
mv formatted_scopes_${timemark}.txt archive/
mv ${output_file} archive/${output_file}
