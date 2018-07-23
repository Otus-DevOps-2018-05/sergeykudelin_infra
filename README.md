## Homework 10
Ansible-3

* Создано разделение на роли
* Создано окружение с использованием динамической инвентаризации через gce.py
* В переменном окружениb передается внутренний адрес БД, через получение переменной при сборе фактов по серверу mongodb
    db_host: "{{ hostvars['reddit-db']['ansible_all_ipv4_addresses'] }}",  
  так же рассмотрен вариант, получение данного реквизита через hostvars полученного при динамической инвентаризации
    db_host: "{{ hostvars['reddit-db']['gce_private_ip'] }}"

# Homework 9 
Ansible-2

* Dynamic inventory
- Создал сервисный аккаунт через утилиту gcloud  
gcloud iam service-accounts create ansible --display-name "Ansible service account"  
gcloud projects add-iam-policy-binding infra-*** --member serviceAccount:ansible@infra-***.iam.gserviceaccount.com --role roles/editor  
gcloud iam service-accounts keys create key.json --iam-account=ansible@infra-***.iam.gserviceaccount.com  
- Для формирования секрета доставил последнюю версию libcloud  
pip install apache-libcloud  
- Сформировал и оставил gce.ini_example  
- Выборка для текущих инстантов:  
./gce.py --instance-tags reddit-app,reddit-db --refresh-cache  

## Homework 8

* Основное задание
1. Установка и конфигурация Ansible
2. Создание inventary файла
3. Созданеи  inventary файла в формате yml
4. Написание playbook-а
5. Исполнение playbook-а
6. Обьяснение ситуации с выполнение playbook-а до удаление каталога и после
 - Первый вариант возвращал что команда выполнена но изменений не было
 - Второй вариант так как каталог был удален, репозиторий был склонирован и результат playbook-а отразил что были внесены изменения на целевой сервер.

Задание со *
В процессе .... 

## Homework 7

Theme: Terraform-2

* Основное задание
1. Провел импортирование существующей инфраструктуры
2. Построил модульную иерархию terraform-а
3. Использованы переменные глобальные в целях моделуй
4. Использованы значение атребутов с других ресурсов
5. Проверна работа явных и не явных зависимостей
6. Проверено выполнение паралельных задач в terraform
7. Создан модуль создания bucket-а

* Самостоятельная работа
1. Создан модуль vpс с использование его в основной конфигурации  
    module "vpc" {
      source        = "../modules/vpc"
    }
2. Созданы конфигурации stage и prod
3. Удалены лишние файлы из корня проекта
4. Параметризированы необходимые переменные  
 - app_disk_image  
 - db_disk_image  
 - app_provision_status  
 - source_ranges  
5. Конфигурационные файлы имеют форматирование согласно terraform fmt

* Задание со *
1. Сконфигурировано хранение state в bucket-е  
Пример: ../stage/backend.tf
2. Проверено хранение state в bucket-е
3. Проверена блокировка state в bucket-е
4. Параметризирован запуск процедура provisioner-а  
    variable "app_provision_status" {  
      description = "enable or disable provision scripts"  
      default     = "true"  
    }  
5. Добавил действие по присвоению значения переменной DATABASE_URL с целью использованния удаленной БД вместо локальной.  
    provisioner "remote-exec" {  
      inline = [  
        "sudo echo DATABASE_URL=${var.database_int_ip} > ${var.puma_env}",  
      ]  
    }  

## Homework №6

* Создан мехнизм создания серверов инфраструктуры на базе terraform с использование input & output переменных
Files: main.tf, outputs.tf, variables.tf
* Выполнена самостоятельная работа
1. Опеределена input переменная зоны  
variable "zone" {  
  description = "Zone"  
  default     = "europe-west1-b"  
}  
2. Определена input переменная приватного ключа для provisioner-а
3. Разметка файлов выполнена с использование Terraform FMT
4. Создан шаблон входных переменных terraform.tfvars.example
* Выполнено задание со *
1. Подключение одного ключа для нескольких пользователей.
Вывод: необходимый формат команды  
metadata {  
    ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}appuser_web:${file  (var.public_key_path_for_appuser_web)}"  
  }  
Так как если определеть поочередно блоками, будет происходить перезапись последним блоков.
2. Подключение ключа через веб-консоль приводит к ее перезатиранию после выполнение скриптов terraform-а, так как он выравниваниет инфраструктуру согласно описанным скриптам.
3. Использовать один приватный ключ для нескольких пользователей не является верным и правильных решением.
* Выполнено задание с **
1. Создан скрипт конфигурации балансировки сервисов
2. Ведена дополнительная переменная count для определения кол-ва создаваемых инстанций а так же для последующей передачи данного набора серверов в группу балансировки
3. Добавлена output переменная с ip-адресов балансировки + скорректирована переменная внешнего адреса каждой инстанции для вывода адресов каждой инстанции.

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

## Homework #3

Command in one line for connect to internal server over bastion:  
* Method №1  
ssh -i ~/.ssh/appuser -A -tt appuser@35.195.49.221 ssh -tt appuser@10.132.0.3  

* Method №2:  
ProxyCommand in my SSH config  
https://askubuntu.com/questions/311447/how-do-i-ssh-to-machine-a-via-b-in-one-command  

~/.ssh/config  
Host someinternalhost  
HostName 10.132.0.3  
User appuser  
ProxyCommand ssh -i ~/.ssh/appuser -A appuser@35.195.49.221  nc %h %p  

* Command: ssh someinternalhost  

* Summary info  
bastion_IP=35.195.49.221  
someinternalhost_IP=10.132.0.3  
