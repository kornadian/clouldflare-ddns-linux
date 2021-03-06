# YOU CAN FIND OUT THIS ON OVERVIEW PAGE OF CLOUDFLARE
DNS_ZONE=<YOUR_ZONE>

ACOUNT_ID=<YOUR ACCOUNT ID>


# AUTH_KEY CAN BE VIEWED IN THE (MY PROFILE > API TOKENS > API KEYS) PAGE
AUTH_EMAIL=<CF EMAIL>
AUTH_KEY=<API GLOBAL KEY>

TARGET_DOMAIN=<FQDN>
#####################################################
# PRE-QUALIFICATION
# You have to install these packages :
#    - "dnsutils" to use dig command
#    - "jq" to parse JSON data

# with the following command
#    sudo yum install dnsutils,jq
# ================================================= #
# Alex's Code Start
echo "#date | Alex Code has been started" > /tmp/cloudflare-ddns-log.log



# lookup the current public IP of the target DNS record
CUR_IP=$(dig +short $TARGET_DOMAIN )
#echo $CUR_IP

# Install `dig` via `dnsutils` for faster IP lookup.
command -v dig &> /dev/null && {
	_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
} || {
	_IP=$(curl --silent https://api.ipify.org)
} || {
	exit 1
}


#========= TO FIND A DNS RECORD ID
#echo $DNS_ZONE

curl "https://api.cloudflare.com/client/v4/zones/$DNS_ZONE/dns_records?type=A&name=$TARGET_DOMAIN&content=$CUR_IP&proxied=false&page=1&per_page=20&order=type&direction=desc&match=all" \
	 --silent \
	 -X GET \
	 -H "Content-Type: application/json" \
	 -H "X-Auth-Email: $AUTH_EMAIL" \
	 -H "X-Auth-Key: $AUTH_KEY" | jq '.' > temp-record-result




if($(jq '.success' temp-record-result -r) == true) then
	RECORD_ID=$(jq '.result[0].id' temp-record-result -r)
	echo "$(date) : DNZ_RECORD_ID finder  | $TARGET_DOMAIN  | Success DNS_RECORD_ID=$RECORD_ID   " >> /tmp/cloudflare-ddns-log.log

else	
	echo "$(date) : DNZ_RECORD_ID finder  |  $(jq '.success' temp-record-result -r) \t $(jq '.error[0]' temp-record-result -r) \t $(jq '.messages[0]' temp-record-result -r)" >> /tmp/cloudflare-ddns-log.log

fi

_UPDATE=$( cat << EOF
{ "type": "A",
"name": "$TARGET_DOMAIN",
"content": "$_IP",
"ttl": 120,
"proxied": false}
EOF
)

curl "https://api.cloudflare.com/client/v4/zones/$DNS_ZONE/dns_records/$RECORD_ID" \
	 --silent \
	 -X PUT \
	 -H "Content-Type: application/json" \
	 -H "X-Auth-Email: $AUTH_EMAIL" \
	 -H "X-Auth-Key: $AUTH_KEY" \
	 -d "$_UPDATE" | jq '.' > temp-record-result

echo "$(date) : DNZ_RECORD UPDATE  |  $(jq '.' temp-record-result -r)" >> /tmp/cloudflare-ddns-log.log


rm temp-record-result
