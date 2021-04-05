
set -x

### Change this depending on your setup
#PY=/usr/local/bin/python3
#AOE_SCRAPE_WORK_ID="`cygpath -w /cygdrive/c/Users/HM/Desktop/fanfic/radiolarian/AO3Scraper/ao3_work_ids.py`"
#AOE_SCRAPE_GET_FANFIC="`cygpath -w /cygdrive/c/Users/HM/Desktop/fanfic/radiolarian/AO3Scraper/ao3_get_fanfics.py`"
#WORKSPACE=/cygdrive/c/Users/HM/Desktop/fanfic/radiolarian/scrape
##################

PY=/usr/local/bin/python3
AOE_SCRAPE_WORK_ID=/Users/bianchi_dy/Documents/GitHub/AO3Scraper/ao3_work_ids.py
AOE_SCRAPE_GET_FANFIC=/Users/bianchi_dy/Documents/GitHub/AO3Scraper/ao3_get_fanfics.py
WORKSPACE=/Users/bianchi_dy/Documents/GitHub/AO3Scraper2




URL="https://archiveofourown.org/works?utf8=%E2%9C%93&work_search%5Bsort_column%5D=revised_at&work_search%5Bother_tag_names%5D=&work_search%5Bexcluded_tag_names%5D=&work_search%5Bcrossover%5D=F&work_search%5Bcomplete%5D=T&work_search%5Bwords_from%5D=999&work_search%5Bwords_to%5D=5001&work_search%5Bdate_from%5D=&work_search%5Bdate_to%5D=&work_search%5Bquery%5D=&work_search%5Blanguage_id%5D=en&commit=Sort+and+Filter&tag_id=Yuri%21%21%21+on+Ice+%28Anime%29"

echo Cleaning up...

rm -rf $WORKSPACE
mkdir $WORKSPACE
cd $WORKSPACE


echo Starting Search...
$PY $AOE_SCRAPE_WORK_ID \
  $URL \
  --out_csv work_ids \
  --num_to_retrieve 7213

echo Pulling Fanfics...
$PY $AOE_SCRAPE_GET_FANFIC work_ids.csv \
  --csv fanfics.csv

echo Done!
