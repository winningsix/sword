#!/bin/bash
set -x
DIR_NAME=`date +%s`
#DIR_NAME=1487028262
LOG_DIR=logs/$DIR_NAME
BB_DIR=Big-Data-Benchmark-for-Big-Bench

function getApplicationByID(){
  APP_ID=$1
  LOG_NAME="${APP_ID}.log"
  if [ ! -f $LOG_NAME ];then
    hadoop fs -ls -R / | grep application | grep $APP_ID | grep -v "drw" | grep "tmp" | tr -s ' ' | cut -d' '  -f8 | xargs -I {} hadoop fs -copyToLocal {} $LOG_NAME 
  fi
}

function process_log(){
  cp ProcessLOG.class latest/
  cd latest
  java ProcessLOG > result
  cd ..
}

function findStr(){
  echo "Find str from application $1"
  cd latest
  if line=$(grep -s -m 1 -e "incorrect" current);then
    if [ ! -f wrong.log ];then
      getApplicationByID $1
      cat -A "${1}.log" | grep "[XY][XY][XY]" > wrong.log
    fi
  else
    if [ ! -f right.log ]; then
      getApplicationByID $1
      cat -A "${1}.log" | grep "[XY][XY][XY]" > right.log
    fi
  fi
  cd ..
}

mkdir -p $LOG_DIR
rm -rf latest
ln -s $LOG_DIR latest 
for VARIABLE in {1..10}
do
  echo "Hi $VARIABLE"
  $BB_DIR/bin/bigBench runBenchmark > "$LOG_DIR/bb_log_$VARIABLE" 2>&1
  echo "============ Round $VARIABLE begins ==========" >> "$LOG_DIR/xucheng"
  find $BB_DIR -name q24_hive_engine_validation_power_test_0.log | xargs ls  | tail -n 1 | xargs cat | tee -a "$LOG_DIR/xucheng" > latest/current 2>&1  
  app_id=$(grep -s -m 1 "yarn application -kill " "${LOG_DIR}/current"  | cut -d ' ' -f 7)
  findStr $app_id "current"
  echo "============ Round $VARIABLE ends ===========" >> "$LOG_DIR/xucheng"
  if [ -f latest/right.log ] && [ -f latest/wrong.log ] ;then
    process_log
    break
  fi	
done
