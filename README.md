# clouldflare-ddns-linux
 
Test

## How to Download the shell file
```
curl -LJO https://raw.githubusercontent.com/kornadian/clouldflare-ddns-linux/main/cloudflare-ddns-from-linux.sh
```

## PRE-QUALIFICATION
 You have to install these packages : \n
    - "dnsutils" to use dig command
    - "jq" to parse JSON data

## Install dnsutils and jq packages
 In order to install, you can use the following command
  ```
  sudo yum install dnsutils jq -y
  ```
  
## After download the script file, locate it and change the permission
```
sudo cp cloudflare-ddns-from-linux.sh /usr/local/bin/cloudflare-ddns-from-linux.sh
sudo chmod +x /usr/local/bin/cloudflare-ddns-from-linux.sh
```
  
## How to User Cronjob (2nd Way)

will bring you into the cron editor.
 ```
 sudo crontab -e
 ```
crontab scripting offers log data on "/tmp/cloudflare-ddns-log.log"
```
* * * * * /usr/local/bin/cloudflare-ddns-from-linux.sh >/dev/null 2>&1
```


### How to Verify the cronjob running properly
$ tail /var/log/cron