SergeyKudelin Infra repository/

Command in one line for connect to internal server over bastion:
ssh -i ~/.ssh/appuser -A -tt appuser@35.187.125.248 ssh -tt appuser@10.132.0.3

Method #2:
ProxyCommand in my SSH config
https://askubuntu.com/questions/311447/how-do-i-ssh-to-machine-a-via-b-in-one-command

****~/.ssh/config
Host someinternalhost
HostName 10.132.0.3
User appuser
ProxyCommand ssh -i ~/.ssh/appuser -A appuser@35.187.125.248  nc %h %p
***
Command: ssh someinternalhost

bastion_IP=35.187.125.248 
someinternalhost_IP=10.132.0.3

