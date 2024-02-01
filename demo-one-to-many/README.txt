DEMO: DOCKER-COMPOSE ONE WEB GATEWAY TO MULTIPLE IRIS INSTANCES

--------------------------------------------------------------------
INTRODUCTION:

This is a simple docker-compose demo that spins up three containers: 

* iris1 and iris2 - the IRIS instances served by Web Gateway
* webgateway - the standalone Web Gateway container (Apache-based)

Using three short convenience scripts:

* setup.sh - spins up all containers via docker-compose and 
    invokes iris/configure.sh in the iris containers
* cleanup.sh - deletes all containers
* iris/configure.sh - configures the IRIS container's CSPConfigName

And a parameters.cfg file.

With this pod, the user can access each instance's Management Portal immediately without relying on the private web server. If running on your local machine, use these URLs:
http://localhost:8882/iris1/csp/sys/UtilHome.csp
http://localhost:8882/iris2/csp/sys/UtilHome.csp

The Web Gateway uses the prefixes (iris1, iris2) to distinguish between the two instances.

There are a couple of ways to make the instances support this. 
The default for this demo is to invoke %SYSTEM.CSP.SetConfigName() for each instance. 
Another option is to invoke "iris rename iris" in the container creation commands. 
(See the docker-compose.yml command lines. Swap which ones are commented out.)

This second option removes the need for configure.sh. However, any other scripts
would then need to use the IRIS instances' unique names. E.g., they'd need to call
"iris session $HOSTNAME" instead of "iris session iris".

In either case, this is a one-to-many WebGateway-to-IRIS deployment solution.
The advantage of one-to-many is the simplicity and fewer containers.
The disadvantage of one-to-many is the initial configuration requirements.
The Web Gateway container must map each instance prefix appropriately.
Any time an IRIS instance is added, CSP.ini and CSP.conf will need to be adjusted
and the web server and Gateway configurations reloaded.
The IRIS instances must also be configured at spin-up time.