cat << EOF | iris session iris

do ##class(%SYSTEM.CSP).SetConfig("CSPConfigName","$HOSTNAME")
halt
EOF