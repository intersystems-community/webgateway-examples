This demo launches a Kubernetes deployment with a single IRIS data server pod and a standalone Web Gateway pod. It demonstrates, in as simplified a manner as possible, how to serve Management Portal with the standalone Web Gateway in Kubernetes.

IMPORTANT: For demo only. In production deployments, please use non-default passwords. Please also note the following prerequisites:

This example configuration uses SSL, but users must provide their own InterSystems IRIS license key and SSL certificates. See Documentation (Configure TLS Security, under IKO Cluster Definitions) for details regarding SSL certificates:
https://docs.intersystems.com/components/csp/docbook/DocBook.UI.Page.cls?KEY=AIKO#AIKO_clusterdef_tls

The user is also responsible for setting up their own cloud and deploying the InterSystems Kubernetes Operator (IKO), which is required to run this demo. Please see Documentation for more information:
https://docs.intersystems.com/components/csp/docbook/DocBook.UI.Page.cls?KEY=AIKO

User should also create docker-secret to hold credentials for retrieving the iris and web gateway containers.

This demo includes the following:

* iris-sample.yaml - YAML file for deployment
* CSP.conf - Apache configuration file to serve all requests with Web Gateway
* CSP.ini - configuration file that points the apps to the IRIS data server
* setup.sh - kubectl commands for spinning up and monitoring the IRIS cluster
* cleanup.sh - kubectl commands to clean up the IRIS cluster and associated volumes

Update tags for iris and webgateway in iris-sample.yaml as needed.

Web Gateway Management will be accessible via:
http://<webgateway-external-IP>/csp/bin/Systems/Module.cxw
https://<webgateway-external-IP>/csp/bin/Systems/Module.cxw

The InterSystems IRIS Management Portal will be accessible via:
http://<webgateway-external-IP>/csp/sys/UtilHome.csp
https://<webgateway-external-IP>/csp/sys/UtilHome.csp

Not provided:

* commands to launch your Google or AWS Cloud and IKO; user must set these up themselves
* commands to create docker-secret (setup.sh includes a commented-out example)
* SSL certificates (tls.crt, tls.key, ca.pem; see Documentation)
* InterSystems IRIS license key (iris.key)