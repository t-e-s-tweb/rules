#!/bin/bash

case "$(uname -m)" in
    x86_64 | x64 | amd64 )
        cpu=amd64
    ;;
    i386 | i686 )
        cpu=386
    ;;
    armv8 | armv8l | arm64 | aarch64 )
        cpu=arm64
    ;;
    armv7l )
        cpu=arm
    ;;
    * )
    echo "Current architecture $(uname -m) is not supported"
    exit
    ;;
esac


warpendipv4v6(){
  echo "1. Preferred endpoint IP for IPv4"
  echo "2. Preferred endpoint IP for IPv6"
  echo "0. Exit"
  
  menu="1" # always select option 1
  
  if [ "$menu" == "1" ];then
    cfwarpIP && endipv4 && endipresult
  elif [ "$menu" == "2" ];then
    cfwarpIP && endipv6 && endipresult
  else 
    exit
  fi
}


cfwarpIP(){
echo "Downloading WARP preferred program"
if [[ -n $cpu ]]; then
curl -L -o warpendpoint -# --retry 2 https://proxy.freecdn.ml?url=https://gitlab.com/rwkgyg/CFwarp/raw/main/point/$cpu
fi
}

endipv4(){
    n=0
    iplist=50
    while true
    do
        temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
        temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
        temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
        temp[$n]=$(echo 188.114.96.$(($RANDOM%256)))
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
        temp[$n]=$(echo 188.114.97.$(($RANDOM%256)))
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
        temp[$n]=$(echo 188.114.98.$(($RANDOM%256)))
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
        temp[$n]=$(echo 188.114.99.$(($RANDOM%256)))
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
    done
    while true
    do
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo 162.159.192.$(($RANDOM%

256)))
            n=$[$n+1]
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
            n=$[$n+1]
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
            n=$[$n+1]
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo 188.114.96.$(($RANDOM%256)))
            n=$[$n+1]
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo 188.114.97.$(($RANDOM%256)))
            n=$[$n+1]
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo 188.114.98.$(($RANDOM%256)))
            n=$[$n+1]
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo 188.114.99.$(($RANDOM%256)))
            n=$[$n+1]
        fi
    done
}

endipv6(){
    n=0
    iplist=50
    while true
    do
        temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
        temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
        n=$[$n+1]
        if [ $n -ge $iplist ]
        then
            break
        fi
    done
    while true
    do
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo

 [2606:4700:d0::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
            n=$[$n+1]
        fi
        if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
        then
            break
        else
            temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
            n=$[$n+1]
        fi
    done
}

endipresult(){
    echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u > ip.txt
    ulimit -n 102400
    chmod +x warpendpoint
    ./warpendpoint
    clear
    cat result.csv | awk -F, '$3!="timeout ms" {print} ' | sort -t, -nk2 -nk3 | uniq | head -11 | awk -F, '{print "Endpoint "$1" Packet Loss "$2" Average Latency "$3}' 
    rm -rf ip.txt warpendpoint
    exit
}


echo "1. WARP-V4V6 Optimal Endpoint IP"
echo "0. Exit"
menu="1"
if [ "$menu" == "1" ];then
    warpendipv4v6
else 
    exit
fi
