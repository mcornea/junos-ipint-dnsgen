#/bin/bash
PERL='/usr/bin/perl'
PARSER='./parser.pl'
CONFIG_FILE='access-router-config.txt'
CONFIG_SYS='sys'
CONFIG_INT='int'
hostname=`$PERL $PARSER $CONFIG_SYS | grep host-name | sed -e s/host-name// -e s/\;// | tr '\r' ' ' | sed -e s/\ //g`
domain=`$PERL $PARSER $CONFIG_SYS | grep domain-name | sed -e s/domain-name// -e s/\;// | tr '\r' ' ' | sed -e s/\ //g`
for i in `grep "ge-[0-9]\/[0-9]\/[0-9] {\|ae[0-9] {\|lo[0-9] {" $CONFIG_FILE | sed -e s/\ //g  -e s/\{// | tr '\r' ' '`
    do 
        intname=`echo $i | sed s/\\\//-/g`
        for j in `$PERL $PARSER $CONFIG_INT $i | grep unit | sed -e s/\ unit//g  -e s/\{// -e s/\ //g | tr '\r' ' '`
            do
                inetaddr=`$PERL $PARSER $CONFIG_INT $i $j | tr '\r' ' '`
                lastoct=`echo $inetaddr | awk -F '.' {'print $4'}`
                if [ $j -eq 0 ]
                then
                    echo "$intname 300 IN A  $inetaddr"
                    echo "$lastoct  IN  PTR $intname.$hostname.$domain."
                    echo

                else
                    if [ $j -eq 10 ]
                    then
                        echo "$intname 300 IN A  $inetaddr"
                        echo "$lastoct  IN  PTR $intname.$hostname.$domain."
                        echo
                    else
                        echo "$intname-u$j 300 IN A  $inetaddr"
                        echo "$lastoct  IN  PTR $intname-u$j.$hostname.$domain."
                        echo
                    fi
                fi
            done
    done 
