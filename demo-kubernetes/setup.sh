# IMPORTANT: before running this script, set up your cloud and the InterSystems Kubernetes Operator (IKO).
# See "Using the InterSystems Kubernetes Operator" under Documentation:
# https://docs.intersystems.com/components/csp/docbook/DocBook.UI.Page.cls?KEY=AIKO

# NB: don't actually script passwords for security reasons
# kubectl create secret docker-registry dockerhub-secret --docker-server=containers.intersystems.com --docker-username=SETME --docker-password=SETME --docker-email=SETME

# For non-default passwords, modify CSP_merge.ini and add data (and possibly compute) CPF files to this line.
# See Documentation for more information regarding config maps for configuration files.
kubectl create cm iris-cpf --from-file CSP-merge.ini

# license key 
kubectl create secret generic iris-key-secret --from-file=iris.key

# SSL/TLS
kubectl create secret generic tls-secret --from-file=tls.crt --from-file=tls.key --from-file=ca.pem

# This launches the deployment.
kubectl apply -f iris-sample.yaml

# Observing the pods as they spin up...
watch kubectl get pods

# Prints the available services. In particular, note the IP addresses for the deployment.
kubectl get svc
