The error seems to indicate that some requests are somehow landing on the wrong pod.

* `kubectl get pods -n dev-yannisr -l openbao-active=true`

This command return two pods. This is wrong, we should only see one.

Let's check which node is the currend leader:

* `bao operator raft list-peers`

`openbao-0` is the current leader. That should be the only pod with the `openbao-active=true` label.

* `kubectl label pod -n openbao openbao-1 openbao-active=false`

Let's check that it's applied: 

* `kubectl get pods -n dev-yannisr -l openbao-active=true`

Looking good! If we run the script now, we shouldn't see any errors anymore :

* `./home/root/assets/simulate.sh`
