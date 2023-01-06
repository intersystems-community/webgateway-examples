/// Utility class for automatically configuring InterSystems IRIS after spinning up
/// the container. Currently its only function is to configure and enable SSL for the 
/// SuperServer. Users are responsible for providing their own SSL certificates and placing
/// them in the mounted directory (iris/ mounted as /iris-shared/ in this example).
Class DemoSetup.Utilities Extends %RegisteredObject
{

/// Directory where all SSL files for the %SuperServer configuration should be located
Property SSLDirectory  [InitialExpression = "/iris-shared/"];

/// Filename for SSL Certificate Authority (CA)
Property SSLCertAuth [InitialExpression = "sslauth.pem"];

/// Filename for SSL Server Certificate
Property SSLCertificate [InitialExpression = "sslcert.pem"];

/// Filename for SSL Private Key
Property SSLKey [InitialExpression = "sslkey.pem"];


/// Creates a %SuperServer configuration using the above-defined properties.
/// Takes a private key password as optional input. Default is to not use one.
Method EnableSSLSuperServer(password="")
{
    New $NAMESPACE
    zn "%SYS"

    set certdir=..SSLDirectory
    set CAfile = ..SSLCertAuth
    set certfile = ..SSLCertificate
    set keyfile = ..SSLKey

    set sslconfig = ##class(Security.SSLConfigs).%New()
    do sslconfig.CAFileSet(certdir_CAfile)
    do sslconfig.CertificateFileSet(certdir_certfile)
    do sslconfig.PrivateKeyFileSet(certdir_keyfile)
    if password'="" do sslconfig.PrivateKeyPasswordSet(password)
    do sslconfig.DescriptionSet("SuperServer configuration")
    do sslconfig.EnabledSet(1)
    do sslconfig.TypeSet(1)
    do sslconfig.NameSet("%SuperServer")
    set sc=sslconfig.%Save()
    If (sc'=1) {
        Write !, "WARNING: Creating and saving the %SuperServer SSL configuration failed!"
        Write !, $system.Status.GetErrorText(sc)
    }
    set sc=##class(Security.System).Get("SYSTEM",.props)
    If (sc'=1) {
        Write !, "WARNING: Getting the system security settings failed!"
        Write !, $system.Status.GetErrorText(sc)
    }
    set props("SSLSuperServer")=1
    set sc=##class(Security.System).Modify("SYSTEM",.props)
    If (sc'=1) {
        Write !, "WARNING: Modifying the system's SSLSuperServer property failed!"
        Write !, $system.Status.GetErrorText(sc)
    }
    Write !, "Done enabling SSL for the SuperServer"
}

}