#!/bin/bash

help(){
cat << EOF

 Usage: $0 [OPTION] [COMMAND]

 Wrapper script to create definition files of Ansible modules to use with IntelliJ plugin OrchidE.

 Options:
   -h                               display this help text
   -i                               build built-in variant for OrchidE including custom collections

 Commands:
   build-all                        Builds the definition package (clean, download collections, create definitions, pack jar)


EOF
}


TOOLDIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
ANTLIB="${TOOLDIR}/lib"
BUILDFILE=$TOOLDIR/build.xml
LIB="-lib $ANTLIB"

ARGS=""
JVM_ARGS=""
PARAMS=""

if [ $# == 0 ]; then
    help
    exit 1
fi

params=( $* )

for (( i=0; i<$# ; i++ )) ; do
    case ${params[i]} in
        -h )
            help
            exit 1
            ;;
        -i )
            JVM_ARGS="$JVM_ARGS -Dcustom_modules=false"
            ;;
        -p )
            ARGS="$ARGS -p"
            ;;
        -v )
            ARGS="$ARGS -v"
            ;;
        -q )
            ARGS="$ARGS -q"
            ;;
        -f )
            BUILDFILE="${params[i+1]}"
            unset params[i+1]
            ;;
        * )
            if [[ "${params[i]}" =~ .*"-D".* ]] ; then
                JVM_ARGS="${JVM_ARGS} ${params[i]}"
            else
                PARAMS="$PARAMS ${params[i]}"
            fi
            ;;
    esac
done

echo ant $LIB -Dbasedir=$TOOLDIR -Dtooldir=$TOOLDIR -f $BUILDFILE $JVM_ARGS $ARGS $PARAMS

ant $LIB -Dbasedir=$TOOLDIR -Dtooldir=$TOOLDIR -f $BUILDFILE $JVM_ARGS $ARGS $PARAMS




