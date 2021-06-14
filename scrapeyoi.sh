#!/bin/sh
exec >logfile.txt 2>&1
set -x

### Change this depending on your setup
#PY=/usr/local/bin/python3
#AOE_SCRAPE_WORK_ID="`cygpath -w /cygdrive/c/Users/HM/Desktop/fanfic/radiolarian/AO3Scraper/ao3_work_ids.py`"
#AOE_SCRAPE_GET_FANFIC="`cygpath -w /cygdrive/c/Users/HM/Desktop/fanfic/radiolarian/AO3Scraper/ao3_get_fanfics.py`"
#WORKSPACE=/cygdrive/c/Users/HM/Desktop/fanfic/radiolarian/scrape
##################

PY=D:/Anna/AO3Scraper/venv/Scripts/python.exe
AOE_SCRAPE_WORK_ID=D:/Anna/AO3Scraper/ao3_work_ids.py
AOE_SCRAPE_GET_FANFIC=D:/Anna/AO3Scraper/ao3_get_fanfics.py
WORKSPACE=D:/Anna/AO3ScraperW/
FICS="fanfics.csv"
IDS="work_ids.csv"


URL="https://archiveofourown.org/works?utf8=%E2%9C%93&work_search%5Bsort_column%5D=revised_at&work_search%5Bother_tag_names%5D=&work_search%5Bexcluded_tag_names%5D=&work_search%5Bcrossover%5D=F&work_search%5Bcomplete%5D=&work_search%5Bwords_from%5D=&work_search%5Bwords_to%5D=&work_search%5Bdate_from%5D=2018-01-01&work_search%5Bdate_to%5D=2019-12-31&work_search%5Bquery%5D=&work_search%5Blanguage_id%5D=en&commit=Sort+and+Filter&tag_id=Yuri%21%21%21+on+Ice+%28Anime%29"

echo Cleaning up...

rm -rf $WORKSPACE
mkdir $WORKSPACE
cd $WORKSPACE || exit


echo Starting Search...
$PY $AOE_SCRAPE_WORK_ID \
  "$URL" \
  --out_csv work_ids \
  --num_to_retrieve 1

CMD="$PY $AOE_SCRAPE_GET_FANFIC $IDS \
  --csv $FICS"

echo Pulling Fanfics...
#$PY $AOE_SCRAPE_GET_FANFIC work_ids.csv \
#  --csv $FICS
if eval "$CMD"; then
  echo "Exit code $?, success"
else
  echo "Exit code $?, failure"
  #set var of length of work_ids
  LENWORK=$(wc -l < $IDS)
  #set var of length of fics csv w/o header
  LENFICS=$(($(wc -l < $FICS) - 1))

  #while last id in fanfics.csv < last id in work_ids
  while [ $LENFICS -lt "$LENWORK" ]
  do
    NEXTID=$((LENFICS + 1))
    RESTART=$(sed "${NEXTID}q;d" $IDS | awk -F, '{print $1}')
    RES="$CMD \
    --restart $RESTART"
    echo "Going to restart at ${RESTART}"
    #try at restart
    sleep 5
    if eval "$RES"
    then
      echo "Exit code $?, success"
      break #exit while loop
    fi
    #update last uncollected id
    OLDLEN=$LENFICS
    LENFICS=$(($(wc -l < $FICS) - 1))
    if [ $OLDLEN -eq $LENFICS ]
    then
      #if retry fails, write the id to fanfics.csv
      echo "skipping ${RESTART}"
      echo "${RESTART},,,,,,,,,,,,,,,,,,,,," >> $FICS
      LENFICS=$(($(wc -l < $FICS) - 1))
    fi
  done
fi

echo Done!