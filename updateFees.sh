#!/bin/bash

BASEFEE_MSAT=1
FEERATE_SAT=0.000005
TIMELOCKDELTA=39

#BASEFEE_MSAT=0
#FEERATE_SAT=0
#TIMELOCKDELTA=140

lncli updatechanpolicy ${BASEFEE_MSAT} ${FEERATE_SAT} ${TIMELOCKDELTA}

echo "Base fee set to ${BASEFEE_MSAT} millisatoshis"
echo "Feerate set to ${FEERATE_SAT} per routed satoshi"
echo "Timelock delta set to ${TIMELOCKDELTA} blocks"
