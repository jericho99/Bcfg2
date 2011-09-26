#cmd=`ping -t1 10.10.1.143`
ping -c1 10.10.1.170
    RC=$?
    if [ $RC -ne 0 ]; then
        echo "not good"
    else
echo "good"
    fi


