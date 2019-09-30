#!/bin/bash

TIME_GAP=$((60 * 60 * 24 * 30 * 2)) # 2 months

NOW=$(date +%s)
CONSIDERED_OLD=$((NOW - TIME_GAP))

echo "--------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "Channel ID\t\tActive\tLast Update\tLocal Balance\tPrivate\t\tFunding Transaction UTXO"
echo "--------------------------------------------------------------------------------------------------------------------------------------------------"

for CHAN_BASE64 in $(lncli listchannels | jq -r '.[][] | @base64')
do
	CHAN=$(echo $CHAN_BASE64 | base64 --decode)
	CHAN_ID=$(echo $CHAN | jq -r '.chan_id')
	ACTIVE=$(echo $CHAN | jq -r '.active')
	LOCAL_BALANCE=$(echo $CHAN | jq -r '.local_balance')
	PRIVATE_CHANNEL=$(echo $CHAN | jq -r '.private')
	CHAN_INFO=$(lncli getchaninfo $CHAN_ID)
	LAST_UPDATE=$(($(echo $CHAN_INFO | jq -r '.last_update')))
	CHAN_POINT=$(echo $CHAN_INFO | jq -r '.chan_point')	
	FUNDING_TX=$(echo $CHAN_POINT | cut -d: -f1)
	FUNDING_OUTPUT=$(echo $CHAN_POINT | cut -d: -f2)
	FUNDING_UTXO=$(echo "${FUNDING_TX} ${FUNDING_OUTPUT}")
	
	if [ $LAST_UPDATE -lt $CONSIDERED_OLD ]
	then
		LAST_UPDATE_FORMATTED=$(date -d @$LAST_UPDATE +"%Y-%m-%d")
		echo -e "$CHAN_ID\t$ACTIVE\t$LAST_UPDATE_FORMATTED\t$LOCAL_BALANCE\t\t$PRIVATE_CHANNEL\t\t$FUNDING_UTXO"
	fi
done

echo -e "\nYou may want to close these channels using the following command:"
echo "lncli closechannel --force [FUNDING TRANSACTION UTXO]"
