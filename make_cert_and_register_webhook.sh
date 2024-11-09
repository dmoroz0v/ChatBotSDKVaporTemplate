#!/bin/bash

source .env

(cd Cert; openssl req -newkey rsa:2048 -sha256 -nodes -keyout key.pem -x509 -days 3650 -out cert.pem -subj "/C=$CERT_COUNTRY/ST=$CERT_CITY/L=$CERT_CITY/O=$CERT_COMPANY/OU=$CERT_DEPARTMENT/CN=$BOT_DOMAIN")

(cd Cert; curl -F "url=https://$BOT_DOMAIN:8443/webhook" -F "certificate=@cert.pem" https://api.telegram.org/bot$BOT_TOKEN/setWebhook)
