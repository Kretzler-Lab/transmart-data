#!/bin/bash

echo "Directory Name for study (ex: Neptune_V16): "
read studyName

source vars
dos2unix ./samples/studies/$studyName/expression.params
mac2unix ./samples/studies/$studyName/expression.params
dos2unix ./samples/studies/$studyName/expression/*.txt
mac2unix ./samples/studies/$studyName/expression/*.txt

PLATFORM=`sed -n '2p' samples/studies/$studyName/expression/*_Mapping.txt | cut -d ' ' -f2 | awk '{print $4}'`

PLATFORM_LOADED=`psql -d transmart -c "select exists (select platform from deapp.de_gpl_info where platform = '$PLATFORM');" -tA`
if [ $PLATFORM_LOADED = 't' ]; then
        echo "Platform already loaded, skipping platform load"
else
        nohup make -C samples/postgres load_annotation_$PLATFORM > $PLATFORM.annotation.out &
fi

nohup make -C samples/postgres load_expression_$studyName > $studyName.expression.out &

echo "Tailing log file\n"
tail -f $studyName.expression.out

