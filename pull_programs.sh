#!/bin/bash
timemark=`date +"%d-%b-%Y_%H%M_%S"`
output_file=h1programs_${timemark}.txt
echo "===== kiyell HackerOne Program scraper                           =====" 
echo "===== Output file: ${output_file}                                ====="
for i in {1..15}
do
     echo "Scraping page: $i "
     curl -s -X GET \
  "https://api.hackerone.com/v1/hackers/programs?page%5Bsize%5D=100&page%5Bnumber%5D=$i" \
  -H 'Accept: */*' \
  -u "$h1_secret" \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Host: api.hackerone.com' \
  -H 'User-Agent: PostmanRuntime/7.15.2' \
  -H 'cache-control: no-cache'  2>&1 >> ${output_file}
done

cat ${output_file} |jq .data[].attributes.handle > program_w_quotes.txt 
cat program_w_quotes.txt |cut -d '"' -f2 > formatted_programs_${timemark}.txt

## make latest programs list
diff -u formatted_programs_latest.txt formatted_programs_${timemark}.txt |grep  '^\+\w'| > program_list_new_handles.txt
cp formatted_programs_${timemark}.txt formatted_programs_latest.txt

## clean up
mv ${output_file} archive/${output_file}
mv formatted_programs_${timemark}.txt archive/
rm program_w_quotes.txt
