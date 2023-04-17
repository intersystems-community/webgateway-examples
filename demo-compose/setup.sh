source parameters.cfg

#; Prior to running the docker-compose, ensure the instances have
#; read-write permissions to the bindmounts.
chmod -R 755 iris
chmod -R 755 webgateway

docker-compose build
docker-compose up -d


# SSL SETUP - omit if opting out of SSL
# It takes several seconds for iris to spin up, so wait for it
# before configuring it for SSL. Adjust sleep time if need be.
sleep 30
docker exec iris /bin/sh -c "/iris-shared/configure.sh"
