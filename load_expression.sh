#!/bin/bash

echo "Directory Name for study (ex: Neptune_V16): "
read studyName

source vars
dos2unix ./samples/studies/$studyName/expression.params
mac2unix ./samples/studies/$studyName/expression.params

nohup make -C samples/postgres load_expression_$studyName > $studyName.expression.out &

echo "Tailing log file\n"
tail -f $studyName.expression.out

