DEMO: DOCKER-COMPOSE ONE WEB GATEWAY TO MULTIPLE IRIS INSTANCES

See the README in the parent directory webgateway-examples/ for general guidance.

This is a docker-compose demo that spins up five containers: 

* iris1 and iris2 - 
    the IRIS instances served by Web Gateway
* webgateway-iris1 and webgateway-iris2 - 
    Web Gateways dedicated to iris1 and iris2, respectively.
    (We'll call these "sidecars.")
* webgateway-app - 
    Web Gateway that load balances between iris1 and iris2

Using two short convenience scripts:

* setup.sh - spins up all containers via docker-compose
* cleanup.sh - deletes all containers

And a parameters.cfg file.

The user can access each instance's Management Portal immediately after setup. 
If running on your local machine, use these URLs:
http://localhost:8881/csp/sys/UtilHome.csp
http://localhost:8882/csp/sys/UtilHome.csp

Or use this URL for the load-balancing Web Gateway, and observe how it alternates
between instances:
http://localhost:8081/csp/sys/UtilHome.csp

Replace localhost with a machine alias or IP address if need be.

Each IRIS instance's Management Portal can be reliably accessed via
a dedicated exposed port: 8881 for iris1, 8882 for iris2.
Any requests to the load-balancing port (8081) will alternate between
IRIS instances for '/' and '/csp', which is not desirable for Management Portal
but may be useful for your custom apps.

One advantage of this many-to-many approach is the separation of responsibilities
and the customization of permissions and security for different use cases.
The sidecars could be configured to only accept requests from a system admin's IP address,
while the load-balancing web server could accept outside requests but only serve 
the ones for, say, /production/app/ through Web Gateway and have Web Gateway Management
disabled. We also don't need to set the IRIS instances' CSPConfigName.

The disadvantage is that the many-to-many approach is more complex and requires
spinning up more containers, consuming more resources and ports.

A middle ground would be a two-to-many approach: one Web Gateway to serve 
Management Portal requests as in the one-to-many demo, and another Web Gateway
to serve requests to the production applications.

Sidenote: IKO offers a many-to-many approach and automates much of the configuration.
It includes and configures Web Gateway sidecars for each IRIS instance by default.