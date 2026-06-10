kubectl label pod -n openbao openbao-1 openbao-active=true --overwrite

echo done > /tmp/ready
