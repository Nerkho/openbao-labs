> **Wait for the environment setup to complete. Once you see the "Ready to start!" message in the shell, you can get going.**

## Context 

A 3-node OpenBao cluster is already deployed on Kubernetes in the `openbao` namespace. 

* `kubectl get pods -n openbao`

```
NAME        READY   STATUS    RESTARTS   AGE
openbao-0   1/1     Running   0          2m2s
openbao-1   1/1     Running   0          93s
openbao-2   1/1     Running   0          80s
```

A [userpass](https://openbao.org/docs/auth/userpass/) authentication method is already pre-configured. The `BAO_ADDR` environment variable has already been set for you.

You can log in with the following credentials:
> * username: admin
> * password: admin123

* `bao login -method userpass username=admin`

* `bao operator raft list-peers`

```
Node         Address                            State       Voter
----         -------                            -----       -----
openbao-0    openbao-0.openbao-internal:8201    leader      true
openbao-1    openbao-1.openbao-internal:8201    follower    true
openbao-2    openbao-2.openbao-internal:8201    follower    true
```

When running in HA mode, each node can have two states: `leader` or `follower`. At any time only one node can be a leader (active) and process requests. By default followers (standby) will redirect all write requests to the leader node (since 2.5.0 standby nodes can handle read requests). Standby nodes will replicate data from the current leader. If the active node fails, a new leader is elected from the nodes that are left.

## Kubernetes

When deploying OpenBao on Kubernetes, the [service registration](https://openbao.org/docs/next/configuration/service-registration/kubernetes/) will tags OpenBao pods with their current status to be used with selectors. 

For example the label `openbao-active: true` will get added to the leader pod. When deploying OpenBao with the Helm chart, a service `openbao-active` will get provisionned and use that label to target the leader.

We can use the commands below to compare in our environment and see that the pod labelled with `openbao-active: true` is also the current leader node from OpenBao perspective.

* `kubectl get pods -n openbao -l openbao-active=true`

```
NAME        READY   STATUS    RESTARTS   AGE
openbao-0   1/1     Running   0          4m22s
``` 

* `bao operator raft list-peers`

```
Node         Address                            State       Voter
----         -------                            -----       -----
openbao-0    openbao-0.openbao-internal:8201    leader      true
openbao-1    openbao-1.openbao-internal:8201    follower    true
openbao-2    openbao-2.openbao-internal:8201    follower    true
``` 

In this scenario we will use the `openbao-node-port` svc with a similar configuration to only target the leader pod.

* `kubectl describe svc -n openbao openbao-node-port`

```
...
Selector:                 openbao-active=true
...
```

## Simluate activity

In this lab, we are going to use a script to simulate interactions with OpenBao. Make sure you are logged in:

* `bao login -method=userpass username=admin`

Then run the script stored at `/root/assets/simulate.sh`:

* `bash /root/assets/simulate.sh`

This will create a bunch of namespaces with KV secrets engines inside OpenBao.
