## Homework #3

Command in one line for connect to internal server over bastion:  
* Method №1  
ssh -i ~/.ssh/appuser -A -J appuser@35.195.49ю221 appuser@10.132.0.3

* Method №2:  
ProxyCommand in my SSH config  
1. https://askubuntu.com/questions/311447/how-do-i-ssh-to-machine-a-via-b-in-one-command
2. https://estl.tech/ssh-into-the-dmz-via-a-bastion-host-85f90c94a8a9

~/.ssh/config  
Host someinternalhost  
HostName 10.132.0.3  
User appuser  
ProxyCommand ssh -i ~/.ssh/appuser -A appuser@35.195.49.221  nc %h %p

or

Host *
 ForwardAgent yes
Host bastion
 HostName 35.195.49.221
 User appuser
 IdentityFile ~/.ssh/appuser

Host someinternalhost
 HostName 10.132.0.3
 ProxyJump bastion
 User appuser
 IdentityFile ~/.ssh/appuser  



* Command: ssh someinternalhost  

* Summary info  
bastion_IP=35.195.49.221  
someinternalhost_IP=10.132.0.3  

##  Homework №4

* Create instance with startup script on localhost
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --scopes storage-ro \
  --metadata-from-file startup-script=./startup_script_reddit_app.sh

* Create bucket over gsutil

Manual: https://cloud.google.com/storage/docs/creating-buckets  
gsutil mb gs://infra-207419

* Upload my script to bucket

Manual: https://cloud.google.com/storage/docs/uploading-objects  
gsutil cp ./startup_script_reddit_app.sh gs://infra-207419/  

* Create instance over startup-script-url  

* for privat gs-url  
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --scopes storage-ro \
  --metadata startup-script-url=gs://infra-207419/startup_script_reddit_app.sh

* for public https-url  
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://storage.googleapis.com/infra-207419/startup_script_reddit_app.sh

* Create firewall rule over gcloud  
gcloud compute firewall-rules create puma-default-server --target-tags="puma-server" --source-ranges="0.0.0.0/0" --allow tcp:9292

* Summary info:  
testapp_IP = 35.189.244.133  
testapp_port = 9292

## Homework №5
* Создан базовый образ виртуального сервера
image family: reddit-base
* Создан полный образ с уже установленными и сконфигурированным сервисом
image family: reddit-full
* Описана команда создающая виртуальный сервер на основе полного образа средствами утилиты gcloud
gcloud compute instances create reddit-app-full \
--boot-disk-size=10GB \
--image-family=reddit-full \
--image-project=infra-207419 \
--machine-type=f1-micro \
--tags puma-server \
--restart-on-failure
