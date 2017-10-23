#!/bin/bash

# Fetch the variables
. parm.txt

# function to get the current time formatted
currentTime()
{
  date +"%Y-%m-%d %H:%M:%S";
}

sudo docker service scale devops-hygieia-jenkins-build-collector=0
sudo docker service scale devops-hygieia-sonar-code-collector=0
sudo docker service scale devops-hygieia-gitlab-feature-collector=0
sudo docker service scale devops-hygieia-gitlab-scm-collector=0
sudo docker service scale devops-hygieiaui=0
sudo docker service scale devops-hygieiaapi=0
sudo docker service scale devops-hygieiadb=0

echo ---$(currentTime)---populate the volumes---
#to zip, use: sudo tar zcvf devops_hygieia_volume.tar.gz /var/nfs/volumes/devops_hygieia*
sudo tar zxvf devops_hygieia_volume.tar.gz -C /


echo ---$(currentTime)---create hygieiadb service---
sudo docker service create -d \
--name devops-hygieiadb \
--network $NETWORK_NAME \
--mount type=volume,source=devops_hygieiadb_volume,destination=/data/db,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_hygieiadb_volume \
--replicas 1 \
--constraint 'node.role == manager' \
$HYGIEIADB_IMAGE

echo ---$(currentTime)---create hygieiaapi service---
sudo docker service create -d \
--name devops-hygieiaapi \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$HYGIEIAAPI_IMAGE

echo ---$(currentTime)---create hygieiaui service---
sudo docker service create -d \
--name devops-hygieiaui \
--publish $HYGIEIAUI_PORT:80 \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$HYGIEIAUI_IMAGE

echo ---$(currentTime)---create hygieia collector jenkins build service---
sudo docker service create -d \
--name devops-hygieia-jenkins-build-collector \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$HYGIEIACLCTR_JENKINS_BUILD_IMAGE

echo ---$(currentTime)---create hygieia collector sonar codequality service---
sudo docker service create -d \
--name devops-hygieia-sonar-code-collector \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$HYGIEIACLCTR_SONAR_CODE_IMAGE

echo ---$(currentTime)---create hygieia collector gitlab feature service---
sudo docker service create -d \
--name devops-hygieia-gitlab-feature-collector \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$HYGIEIACLCTR_GITLAB_FEATURE_IMAGE

echo ---$(currentTime)---create hygieia collector gitlab scm service---
sudo docker service create -d \
--name devops-hygieia-gitlab-scm-collector \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$HYGIEIACLCTR_GITLAB_SCM_IMAGE

sudo docker service scale devops-hygieiadb=1
sudo docker service scale devops-hygieiaapi=1
sudo docker service scale devops-hygieiaui=1
sudo docker service scale devops-hygieia-jenkins-build-collector=1
sudo docker service scale devops-hygieia-sonar-code-collector=1
sudo docker service scale devops-hygieia-gitlab-feature-collector=1
sudo docker service scale devops-hygieia-gitlab-scm-collector=1



