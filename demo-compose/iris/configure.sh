cat << EOF | iris session iris
zn "USER"
set sc=##class(%SYSTEM.OBJ).Load("/iris-shared/DemoSetup.Utilities.cls","ck")
write !, "Import utility class: "_sc
set helper=##class(DemoSetup.Utilities).%New() do helper.EnableSSLSuperServer()
halt
EOF