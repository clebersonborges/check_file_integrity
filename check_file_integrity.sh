#!/bin/bash

# Desenvolvido por Cleberson Borges - clebersonborges@gmail.com

#VARIAVEIS NAGIOS
NAGIOS_OK=0
NAGIOS_WARNING=1
NAGIOS_CRITICAL=2
NAGIOS_UNKNOWN=3

CKSUM=/usr/bin/cksum

ARQ_MONITORADO=$1
BASE=`basename $ARQ_MONITORADO`

ARQ_CKSUM=/tmp/$BASENAME.cksum

if [ ! -x "$CKSUM" ]
then
	echo "cksum not found!";
	exit ${NAGIOS_UNKNOWN};
fi

# Se não existir o arquivo de cksum, ele cria [reinicio do servidor e primeira execução]
if [ ! -f "$ARQ_CKSUM" ]; then cksum $ARQ_MONITORADO | awk '{print $1}' > $ARQ_CKSUM; fi
CKSUM_BASE=`cat $ARQ_CKSUM`

CKSUM_FILE=$(cksum $ARQ_MONITORADO | awk '{print $1}')
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
        echo "UNKNOWN: $ARQ_MONITORADO problem";
        exit $NAGIOS_UNKNOWN;
fi

if [ "$CKSUM_BASE" = "$CKSUM_FILE" ]; then
	echo "OK: $ARQ_MONITORADO ok";
	exit $NAGIOS_OK;
else
	echo "CRITIAL: $ARQ_MONITORADO changed";
	exit $NAGIOS_CRITICAL;
fi

exit $NAGIOS_UNKNOWN;