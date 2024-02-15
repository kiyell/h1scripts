# h1scripts - HackerOne API bash scripts to retrieve latest scope additions

It necessary to first setup the environmental variable `h1_secret` to authenticate against the HackerOne API.
That can been done with `export h1_secret=username:apikey` added to your bash profile or similar location.

(Learn how to get a HackerOne API key here: https://api.hackerone.com/getting-started/#getting-started)

After that the `run_h1scripts.sh` script will call the other scripts to pull down program handles & scopes and process them. 

In the end you will have a `url_list_processed_h1scopes_latest.txt` file which will have the total in-scope urls and `url_list_new_urls.txt` which will have new urls that have not been seen since the last run.

## NOTE ##
1. You may need to edit the number of pages that are scraped in `pull_programs.sh` from 15 in case you are a part of many more private programs.
2. For now asterix scopes are not fully supported and are a work in progress.
