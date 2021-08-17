#!/bin/bash
version="1.0.3.4"

function installJava(){
  command -v apt >/dev/null 2>&1 && (apt-get update; apt-get install openjdk-8-jdk -y; return;)
  command -v yum >/dev/null 2>&1 && (yum install java-1.8.0-openjdk -y; return;)
}

function installUnzip(){
  command -v apt >/dev/null 2>&1 && (apt-get update; apt-get install unzip -y; return;)
  command -v yum >/dev/null 2>&1 && (yum install unzip -y; return;)
}

function download(){
  wget -O "/tmp/BILIBILI-HELPER.zip" "https://glare.now.sh/xxxbrian/BILIBILI-HELPER/BILIBILI-HELPER-v${1}.zip"
  mkdir "${HOME}/BILIBILI-HELPER"
  command -v unzip >/dev/null 2>&1 || installUnzip
  unzip -o "/tmp/BILIBILI-HELPER.zip" -d "${HOME}/BILIBILI-HELPER"
  mv "${HOME}/BILIBILI-HELPER/BILIBILI-HELPER-v${1}.jar" "${HOME}/BILIBILI-HELPER/BILIBILI-HELPER.jar" -f
}

function setCron(){
  file="/var/spool/cron/${USER}"
  if [ ! -f "$file" ]; then
    touch "$file"
  else
    find=`grep "BILIBILI-HELPER" "$file"`
    if [ -z "$find" ]; then
      echo "" >> "$file"
	  echo "30 10 * * * cd ${HOME}/BILIBILI-HELPER; java -jar ./BILIBILI-HELPER.jar ${1} ${2} ${3} ${4} >>/var/log/cron.log 2>&1 &" >> "$file"
	  service crond reload
	  service cron reload
	fi
  fi
}

function update() {
  wget -O "/tmp/BILIBILI-HELPER.zip" "https://glare.now.sh/xxxbrian/BILIBILI-HELPER/BILIBILI-HELPER-v${1}.zip"
  mkdir "/tmp/BILIBILI-HELPER"
  command -v unzip >/dev/null 2>&1 || installUnzip
  unzip -o "/tmp/BILIBILI-HELPER.zip" -d "/tmp/BILIBILI-HELPER"
  mv "/tmp/BILIBILI-HELPER/BILIBILI-HELPER-v${1}.jar" "${HOME}/BILIBILI-HELPER/BILIBILI-HELPER.jar" -f
}

function clean() {
    rm "/tmp/BILIBILI-HELPER.zip" -f
    rm "/tmp/BILIBILI-HELPER" -rf
}

echo -e "\033[47;30mBILIBILI-HELPER\033[0m"
if [ ! -d "${HOME}/BILIBILI-HELPER" ]; then
  echo -e "\033[36m初次安装，配置Cookie信息：\033[0m"
  read -p "请粘贴SESSDATA并回车:" SESSDATA
  read -p "请粘贴DEDEUSERID并回车:" DEDEUSERID
  read -p "请粘贴BILI_JCT并回车:" BILI_JCT
  read -p "请输入额外参数并回车(没有请留空):" ARG
  download $version
  setCron "${DEDEUSERID}" "${SESSDATA}" "${BILI_JCT}" "${ARG}"
  command -v java >/dev/null 2>&1 || installJava
else
  echo -e "\033[33m检测到旧版本存在，仅更新jar包文件(v${version})\033[0m"
  update $version
fi
clean
echo -e "\033[32m执行完成\033[0m"