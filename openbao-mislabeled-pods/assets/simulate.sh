#!/bin/sh

for i in {1..15} ; do
  name=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 64)
  bao namespace create $name
  bao secrets enable -namespace=$name kv
  bao kv put -mount=kv -namespace=$name secret foo=bar
done
