#!/bin/bash

echo "Directory Name for study (ex: Neptune_V16): "
read studyName

source vars
dos2unix ./samples/studies/$studyName/clinical.params
mac2unix ./samples/studies/$studyName/clinical.params

nohup make -C samples/postgres load_clinical_$studyName > $studyName.clinical.out &

echo "Tailing log file\n"
tail -f $studyName.clinical.out
