source parameters.cfg

#; Prior to running the docker-compose, ensure the instances have
#; read-write permissions to the bindmounts.
chmod -R 755 iris
chmod -R 755 webgateway

docker-compose build
docker-compose up -d
