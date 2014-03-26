junos-ipint-dnsgen
======================== 

Usage : ./parser.pl sys                              # outputs system section config
        ./parser.pl int                              # outputs interfaces section config
        ./parser.pl int [int-name]                   # outputs specific interface section config
        ./parser.pl int ge-1/1/7                     # outputs ge-1/1/7 interface section config
        ./parser.pl int [int-name] [unit-id]         # outputs specific interface unit IP address
        ./parser.pl int ge-1/1/7 1001                # outputs ge-1/1/7 interface unit 1001 IP address

