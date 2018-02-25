#!/bin/bash

#ls -ld * |  sed -n -e 's/^.*-> apps\///p' | awk -F'/' '{print $1" "$2}' | sort > comp1

#declare -a APPMAP
#while read line; do
#  echo $line | cut -d' ' -f 1
#done <comp1

HTML=html.out
rm $HTML
#echo "<html><body><table><tr><th>Service</th><th>From</th><th>To</th></tr>">>$HTML
cat htmlhead.txt >> $HTML
XX=`cat comp1 comp2 | cut -d' ' -f 1 | sort | uniq`
while read service; do
  OLDV=`grep $service comp1 | cut -d' ' -f 2`
  NEWV=`grep $service comp2 | cut -d' ' -f 2`
  #echo "$service. old=${OLDV}, new=${NEWV}"

  if [ "$OLDV" == "$NEWV" ]; then
    ROW_CLASS="sameVersion"
  elif [ -n "$OLDV" ] && [ -n "$NEWV" ]; then
    ROW_CLASS="diffVersion"
  elif [ -z "$OLDV" ] && [ -n "$NEWV" ]; then
    ROW_CLASS="initComponent"
  elif [ -n "$OLDV" ] && [ -z "$NEWV" ]; then
    ROW_CLASS="error"
  fi

  echo "<tr class='${ROW_CLASS}'><td>${service}</td><td>${OLDV}</td><td>${NEWV}</td></tr>">>$HTML

done <<<"$XX"

echo "</table></div></body></html>">>$HTML

cat $HTML
