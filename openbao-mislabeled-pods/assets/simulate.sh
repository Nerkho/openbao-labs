#!/bin/sh

for i in {1..15} ; do
  name=$(echo $RANDOM | md5sum | head -c 15; echo;)
  bao namespace create $name
  bao secrets enable -namespace=$name kv
  bao kv put -mount=kv -namespace=$name secret foo=bar
done
