DEMO: DOCKER-COMPOSE IRIS AND WEB GATEWAY WITH NO PRIVATE WEB SERVER
--------------------------------------------------------------------

This is a simple docker-compose demo that spins up two containers: 

* iris - the IRIS instance the Web Gateway will connect to
* webgateway - the standalone Web Gateway container (Apache-based)

With this pod, the user can access Management Portal immediately without relying on the private web server. If running on your local machine, use this URL:
http://localhost:8882/csp/sys/UtilHome.csp
(Replace localhost with the name or IP address of the host machine if needed.)
Or this URL for https (maps to port 443):
https://localhost:8883/csp/sys/UtilHome.csp

This demo also provides three short convenience scripts:
* setup.sh - spins up all containers via docker-compose and invokes iris/configure.sh in the iris container
* cleanup.sh - deletes all containers and removes their durable directories
* iris/configure.sh - configures the IRIS container's SuperServer to support SSL, using iris/DemoSetup.Utilities.cls

NOTE: Users must supply their own valid SSL certificates and keys. Name and place these files as follows.

For %SuperServer, under iris/:
* sslauth.pem (CA certificate)
* sslcert.pem (server certificate)
* sslkey.pem (private key)

For Web Gateway to IRIS connections, under webgateway/:
* sslcliauth.pem (CA certificate)
* sslclicert.pem (client certificate)
* sslclikey.pem (private key)

For browser to Web Gateway connections, under webgateway/:
* sslwebcert.pem (web server certificate)
* sslwebkey.pem (web server key)

If SSL is not desired, remove the SSL-related sections from these files:
* setup.sh (everything after the docker-compose commands)
* webgateway/CSP.ini (under the LOCAL section, Connection_Security_Level and all the SSLCC_* fields)
* webgateway/CSP.conf (everything under the SSL section)


The first time you access Management Portal with a user (e.g., SuperUser), it will prompt you to manually set the user's password in IRIS to login to Management Portal with SuperUser,etc. Web Gateway uses CSPSystem/SYS by default to connect to IRIS. This works out of the box, but if you change CSPSystem's password to anything else on IRIS, don't forget to adjust the server configuration in Web Gateway.

See the docker-compose.yml for the external port mappings. Change those if needed to avoid conflicts with other containers or instances on your machine.

Ensure that you use a good IRIS kit version (replace latest with a version tag in the parameters.cfg if needed), that your Docker is up to date, and that Docker can read-write to the iris/ and webgateway/ subdirectories for durable sys.

NOTE: Users must also provide their own license keys. Place your license key under the "iris" subdirectory and name it "iris.key".

--------------------------------------------------------------------

NOTES FOR PODMAN:

If using podman in lieu of docker, the demo works similarly, but requires the following special considerations for setup:

- Podman must either use netavark as its backend or have the dnsname plugin installed for the cni backend.
- Run "podman unshare chown 51773:51773" on the iris/ subdirectory to support durable sys. Alternatively, omit durable sys.
- If SELinux is enforcing security on RHEL, add (uncomment) the "privileged: true" flag for each service in the docker-compose file.

You will also need podman-compose/podman commands instead of docker-compose/docker in the setup and cleanup scripts, unless you use docker-to-podman aliasing.

