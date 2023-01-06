kubectl delete iriscluster sample
kubectl get pvc --no-headers=true | awk '/sample/{print $1}'| xargs kubectl delete pvc
kubectl get configmap --no-headers=true | awk '/sample/{print $1}'| xargs kubectl delete configmap
kubectl get svc --no-headers=true | awk '/sample/{print $1}'| xargs kubectl delete svc
