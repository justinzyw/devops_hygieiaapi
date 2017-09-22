FROM capitalone/hygieia-api:latest

ENV jasypt.encryptor.password hygieiasecret

ENV SPRING_DATA_MONGODB_DATABASE dashboard

ENV SPRING_DATA_MONGODB_HOST devops-hygieiadb

ENV SPRING_DATA_MONGODB_PORT 27017

ENV SPRING_DATA_MONGODB_USERNAME db

ENV SPRING_DATA_MONGODB_PASSWORD dashboard
