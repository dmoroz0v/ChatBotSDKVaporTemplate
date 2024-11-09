#!/bin/bash

source .env

(cd Cert; curl POST https://api.telegram.org/bot$BOT_TOKEN/deleteWebhook)
