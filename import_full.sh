#!/bin/bash

DB=$1
echo "++++++++++++++++++ HELLO, DB = $DB"

echo '++++++++++++++++++ SOCRBASE TABLE CREATED'
pgdbf _data/SOCRBASE.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ CENTERST TABLE CREATED'
pgdbf _data/CENTERST.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ CURENTST TABLE CREATED'
pgdbf _data/CURENTST.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ DADDROB TABLE CREATED'
pgdbf _data/DADDROB.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ DHOUSE TABLE CREATED'
pgdbf _data/DHOUSE.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ DNORDOC TABLE CREATED'
pgdbf _data/DNORDOC.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ ENTSTAT TABLE CREATED'
pgdbf _data/ENTSTAT.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ FLATTYPE TABLE CREATED'
pgdbf _data/FLATTYPE.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ OPERSTAT TABLE CREATED'
pgdbf _data/OPERSTAT.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ ROOMTYPE TABLE CREATED'
pgdbf _data/ROOMTYPE.DBF | iconv -f cp866 -t utf-8 | psql  $DB

echo '++++++++++++++++++ CHECKING ADDROBJ FILES'
if [ -f ./_data/ADDROB01.DBF ]; then
   mv ./_data/ADDROB01.DBF ./_data/ADDROBJ.DBF
   echo '++++++++++++++++++ ADDROBJ INITIAL FILE MOVED'
fi
pgdbf ./_data/ADDROBJ.DBF | iconv -f cp866 -t utf-8 | psql  $DB
echo '++++++++++++++++++ INITIAL ADDROBJ TABLE CREATED'

for FULLPATH in `find ./_data/ADDROB* -type f`
do
    FILE="${FULLPATH##*/}"
    TABLE="${FILE%.*}"

    if [ $TABLE = 'ADDROBJ' ]; then
      echo 'SKIPPING ADDROBJ'
    else
      pgdbf $FULLPATH | iconv -f cp866 -t utf-8 | psql  $DB
      echo "++++++++++++++++++ TABLE $TABLE CREATED"

      echo "++++++++++++++++++ INSERT $TABLE DATA INTO ADDROBJ"
      psql -d $DB -c "INSERT INTO addrobj SELECT * FROM $TABLE; DROP TABLE $TABLE;"
    fi

done

echo '++++++++++++++++++ CHECKING NORDOC FILES'
if [ -f ./_data/NORDOC01.DBF ]; then
   mv ./_data/NORDOC01.DBF ./_data/NORDOC.DBF
   echo '++++++++++++++++++ NORDOC INITIAL FILE MOVED'
fi
pgdbf ./_data/NORDOC.DBF | iconv -f cp866 -t utf-8 | psql  $DB
echo '++++++++++++++++++ INITIAL NORDOC TABLE CREATED'

for FULLPATH in `find ./_data/NORDOC* -type f`
do
    FILE="${FULLPATH##*/}"
    TABLE="${FILE%.*}"

    if [ $TABLE = 'NORDOC' ]; then
      echo 'SKIPPING NORDOC'
    else
      pgdbf $FULLPATH | iconv -f cp866 -t utf-8 | psql  $DB
      echo "++++++++++++++++++ TABLE $TABLE CREATED"

      echo "++++++++++++++++++ INSERT $TABLE DATA INTO NORDOC"
      psql -d $DB -c "INSERT INTO NORDOC SELECT * FROM $TABLE; DROP TABLE $TABLE;"
    fi

done

echo '++++++++++++++++++ CHECKING HOUSE FILES'
if [ -f ./_data/HOUSE01.DBF ]; then
   mv ./_data/HOUSE01.DBF ./_data/HOUSE.DBF
   echo '++++++++++++++++++ HOUSE INITIAL FILE MOVED'
fi
pgdbf ./_data/HOUSE.DBF | iconv -f cp866 -t utf-8 | psql  $DB
echo '++++++++++++++++++ INITIAL HOUSE TABLE CREATED'

for FULLPATH in `find ./_data/HOUSE* -type f`
do
    FILE="${FULLPATH##*/}"
    TABLE="${FILE%.*}"

    if [ $TABLE = 'HOUSE' ]; then
      echo 'SKIPPING HOUSE'
    else
      pgdbf $FULLPATH | iconv -f cp866 -t utf-8 | psql  $DB
      echo "++++++++++++++++++ TABLE $TABLE CREATED"

      echo "++++++++++++++++++ INSERT $TABLE DATA INTO HOUSE"
      psql -d $DB -c "INSERT INTO HOUSE SELECT * FROM $TABLE; DROP TABLE $TABLE;"
    fi

done

echo '++++++++++++++++++ CHECKING STEAD FILES'
if [ -f ./_data/STEAD01.DBF ]; then
   mv ./_data/STEAD01.DBF ./_data/STEAD.DBF
   echo '++++++++++++++++++ STEAD INITIAL FILE MOVED'
fi
pgdbf ./_data/STEAD.DBF | iconv -f cp866 -t utf-8 | psql  $DB
echo '++++++++++++++++++ INITIAL STEAD TABLE CREATED'

for FULLPATH in `find ./_data/STEAD* -type f`
do
    FILE="${FULLPATH##*/}"
    TABLE="${FILE%.*}"

    if [ $TABLE = 'STEAD' ]; then
      echo 'SKIPPING STEAD'
    else
      pgdbf $FULLPATH | iconv -f cp866 -t utf-8 | psql  $DB
      echo "++++++++++++++++++ TABLE $TABLE CREATED"

      echo "++++++++++++++++++ INSERT $TABLE DATA INTO STEAD"
      psql -d $DB -c "INSERT INTO STEAD SELECT * FROM $TABLE; DROP TABLE $TABLE;"
    fi

done
