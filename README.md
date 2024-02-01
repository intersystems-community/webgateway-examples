# webgateway-examples
Examples of how to configure and use the WebGateway with InterSystems IRIS.
Currently, this includes the following:

* demo-compose
    - simple docker-compose example with a Web Gateway container serving an IRIS container
* demo-dockerfile 
    - a custom dockerfile that builds a new IRIS-based container including a web server and Web Gateway
* demo-kubernetes
    - a Kubernetes deployment using IKO, deploying a standalone web server and an IRIS data node
* demo-one-to-many
    - docker-compose deployment with one Web Gateway serving two IRIS instances' Management Portals
* demo-many-to-many
    - docker-compose with a dedicated Web Gateway for each IRIS instance's Management Portal and a separate Web Gateway to load balance app requests between them

## GENERAL REQUIREMENTS

For most of the demos (with the exception of demo-kubernetes), Docker must be installed on your machine unless you are using Podman (see Podman section). Ensure that your Docker version is up-to-date.

Several of the demos also require docker-compose or the Podman equivalent.

The Kubernetes demo requires Kubernetes, IKO, cloud access, and preconfigured secrets. See demo-kubernetes/README.txt for details.

For demos using durable storage, ensure that Docker has read-write permissions on the (demo-name)/webgateway/ and (demo-name)/iris/ subdirectories.

All scripts are designed for Unix and will not run as-is on Windows. For Windows, run docker-compose and other analogous commands manually or create comparable .bat scripts. Be sure to either load the variables from the demo's parameters.cfg or fill in the literal values in docker-compose.yml.

Users must provide their own license keys. 
Place your license key under the relevant demo's "iris" subdirectory and name it "iris.key".

Users must provide their own TLS certificates for any demos that include TLS (demo-compose and demo-kubernetes).

Change external port mappings if needed to avoid conflicts with other containers or instances on your machine.

## PODMAN REQUIREMENTS

If using podman in lieu of docker and docker-compose, the demos work similarly but require the following special considerations for setup:

- Podman must either use netavark as its backend or have the dnsname plugin installed for the cni backend.

- Run "podman unshare chown 51773:51773" on the iris/ subdirectory to support durable sys. Alternatively, do not use durable sys.

- If SELinux is enforcing security on RHEL, add (uncomment) the "privileged: true" flag 
    for each service in the docker-compose file.

You will also need podman-compose/podman commands instead of docker-compose/docker in the setup and cleanup scripts, unless you use docker-to-podman aliasing.


## SECURITY ADVISORY

These examples are simplified and for demonstration purposes only. 
They do not have production-level security as-is. 

For a more secure setup, users should make, at minimum, the following changes:

- Do not use all-wildcard values for System_Manager in CSP.ini. This grants all IP addresses access to Web Gateway Management.

- Set a password other than "SYS" for all IRIS users, including CSPSystem.

- Set up TLS configurations, as in demo-compose or demo-kubernetes.

See Documentation (docs.intersystems.com) for further security guidance. In particular, search for Web Gateway security and IRIS container passwords, or follow these links:

IRIS containers and password authentication: 
https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=ADOCK#ADOCK_iris_images_password_auth
 
Web Gateway security:
https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=ADOCK#ADOCK_iris_webgateway_security

Additionally, to ensure data persists, use durable SYS as demonstrated in demo-compose or demo-dockerfile. IKO (demo-kubernetes) automatically handles this for you. See Documentation for more information on IKO and persistent volumes:
https://docs.intersystems.com/components/csp/docbook/DocBook.UI.Page.cls?KEY=AIKO#AIKO_persistentvolumes


## ADDITIONAL NOTES

See the Web Gateway configuration guide in official Documentation for general guidance:
https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCGI_intro
