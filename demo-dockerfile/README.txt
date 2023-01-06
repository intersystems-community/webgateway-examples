This demo is a Dockerfile for a custom IRIS image that includes the Web Gateway. In most cases, it is recommended that the Community edition be used for quick demos and that separate Web Gateway and IRIS containers be used for production environments. However, if a custom IRIS container with Web Gateway built into it is desired, this is one way to do it. 

This demo includes the following:
* Dockerfile - a custom Dockerfile that uses an IRIS image as a base
* CSP.conf - configuration file with directives to serve requests via Web Gateway; gets appended to the web server's conf file
* CSP.ini - Web Gateway configuration settings
* buildscript.sh - builds the image from the Dockerfile, runs it, and issues an exec command to re-start the web server. Can set the ARGS from the Dockerfile to non-default values here.
* A copy of a standalone Web Gateway tarball. To use a different version, fetch the tarball you want from WRC, and edit args to match.

Access http://localhost:5552/csp/bin/Systems/Module.cxw for Web Gateway Management and http://localhost:5552/csp/sys/UtilHome.csp for Management Portal through the standalone Web Gateway. Change the PORT variables in the buildscript to use different ports, if needed to avoid conflicts.

Note, the code here is as simplified as possible. It does not, for example, include symlinks to support persistent CSP.conf, CSP.ini, or CSP.log, and it always uses the configuration files supplied during build. Users can add their own customizations to support additional features if they require it.

User must supply their own license key. Name it "iris.key" and place it in the same directory as the Dockerfile.

User must edit the build script's BASEDIR to hold the appropriate path on their system.

To change the IRIS version used by this demo, edit the IMAGE argument in the build script. The IRIS version should never exceed the Web Gateway version, so if specifying a recent IRIS, you may need to fetch a more recent Web Gateway tarball as well.
