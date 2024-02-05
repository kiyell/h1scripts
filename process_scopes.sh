#!/bin/bash
filename=$1
timemark=`date +"%d-%b-%Y_%H%M_%S"`
output_file=url_list_processed_h1scopes_${timemark}.txt
echo "===== kiyell HackerOne Scope Processor                           =====" 
echo "===== Output file: ${output_file}                                ====="

cat $1 |jq '.relationships.structured_scopes.data[] | select (.attributes.eligible_for_bounty==true) | select (.attributes.asset_type=="URL")' | jq .attributes.asset_identifier |cut -d '"' -f2|grep -v '*'|grep -v '(' |grep -v ',' | grep '.'|grep '://' > urls_w_http${timemark}.txt

cat $1 |jq '.relationships.structured_scopes.data[] | select (.attributes.eligible_for_bounty==true) | select (.attributes.asset_type=="URL")' | jq .attributes.asset_identifier |cut -d '"' -f2|grep -v '*'|grep -v '(' |grep -v ',' | grep '.'|grep -v '://' > urls_wo_http${timemark}.txt

cat urls_wo_http${timemark}.txt | while read line; do echo "https://"${line}; done >> urls_added_http${timemark}.txt

cat urls_w_http${timemark}.txt urls_added_http${timemark}.txt > ${output_file}

### New changes file ###
echo "Creating new changes file"

diff -u url_list_processed_h1scopes_latest.txt ${output_file} |grep \+|grep http|cut -d '+' -f2 > url_list_new_urls.txt
cp ${output_file} url_list_processed_h1scopes_latest.txt

## cleanup ##
echo "Cleaning up"


mv urls_wo_http${timemark}.txt archive/
mv urls_w_http${timemark}.txt archive/
mv urls_added_http${timemark}.txt archive/
mv ${output_file} archive/

### Asterix urls processing ##
echo "Asterix url processing"

cat $1 |jq '.relationships.structured_scopes.data[] | select (.attributes.eligible_for_bounty==true) | select (.attributes.asset_type=="URL")' | jq .attributes.asset_identifier |cut -d '"' -f2|grep '\*\.'|grep -v '(' |grep -v ',' | grep '.'|grep '://'|grep '\/\*' | cut -d '/' -f3 > star_urls_wo_http1${timemark}.txt

cat $1 |jq '.relationships.structured_scopes.data[] | select (.attributes.eligible_for_bounty==true) | select (.attributes.asset_type=="URL")' | jq .attributes.asset_identifier |cut -d '"' -f2|grep '\*\.'|grep -v '(' |grep -v ',' | grep '.'|grep -v '://'|grep '^\*\.\w\+'|cut -d '/' -f1 > star_urls_wo_http2${timemark}.txt

cat star_urls_wo_http1${timemark}.txt star_urls_wo_http2${timemark}.txt |cut -d '.' -f2,3,4,5,6,7,8,9,10 > url_list_asterix_processed_h1stardomains_${timemark}.txt

mv star_urls_wo_http1${timemark}.txt archive/
mv star_urls_wo_http2${timemark}.txt archive/

## for now move asterix stuff to archive
## mv url_list_asterix_processed_h1stardomains_${timemark}.txt archive/


