#!/bin/bash

CHANNEL_SIZE=500000
ONCHAIN_FEES=1

SERVER="$(cut -d'@' -f2 <<< $1)"
PUBKEY="$(cut -d'@' -f1 <<< $1)"

echo "Network Address: ${SERVER}"
echo "Public Key: ${PUBKEY}"
echo "----------------------------------------"

echo "Is there already a channel?"
CHANNEL_CHECK="$(lncli listchannels | grep ${PUBKEY})"
if [ "${CHANNEL_CHECK}" == "" ]
then
	echo " --> No"
else
	echo " --> Yes. Abort channel creation."
	exit;
fi

echo "Connecting to Node"
OUTPUT_CONNECTION="$(lncli connect --perm $1)" 
echo " --> ${OUTPUT_CONNECTION}"

echo "Short Pause: Letting Connection mature ..."
sleep 10

echo "Open Channel"
CHANNEL_CREATION="$(lncli openchannel --sat_per_byte ${ONCHAIN_FEES} --remote_csv_delay 1000 ${PUBKEY} ${CHANNEL_SIZE} 0)"
echo " --> ${CHANNEL_CREATION}"

echo "Wallet Balance"
WALLET_BALANCE="$(lncli walletbalance)"
echo " --> ${WALLET_BALANCE}"
