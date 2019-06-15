#!/usr/bin/env bash
#
# Start bc, calculate 1 + 2 + 3 + ... until the sum > 100.
#

if ! which sexpect >& /dev/null; then
    echo "sexpect not found in your \$PATH"
    exit 1
fi

export SEXPECT_SOCKFILE=/tmp/sexpect-bc-iGciUZ.sock
sexpect spawn -idle 10 -timeout 5 bc

if ! sexpect expect -cstr -re 'warranty.*[\r\n]'; then
    sexpect kill -kill

    echo "oops! aren't you using GNU bc?"
    exit 1
fi

sum=0
max=100
for ((i = 1; ; ++i)); do
    sexpect send -cr "$sum + $i"
    if ! sexpect expect -cstr -re '[\r\n]([0-9]+)[\r\n]'; then
        sexpect kill -kill

        echo "oops! something wrong"
        exit 1
    fi
    sum=$(sexpect expect_out -index 1)

    if [[ $sum -gt $max ]]; then
        sexpect send -cstr '\cd'
        sexpect wait
        exit
    fi
done

#
# EXAMPLE OUTPUT:
#
#   $ bash bc.sexp.sh
#   bc 1.06.95
#   Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006 Free Software Foundation, Inc.
#   This is free software with ABSOLUTELY NO WARRANTY.
#   For details type `warranty'.
#   0 + 1
#   1
#   1 + 2
#   3
#   3 + 3
#   6
#   6 + 4
#   10
#   10 + 5
#   15
#   15 + 6
#   21
#   21 + 7
#   28
#   28 + 8
#   36
#   36 + 9
#   45
#   45 + 10
#   55
#   55 + 11
#   66
#   66 + 12
#   78
#   78 + 13
#   91
#   91 + 14
#   105
#
