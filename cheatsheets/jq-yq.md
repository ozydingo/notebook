```
k get pdb app-pdb -o yaml | yq '{"annotations": .metadata.annotations, "labels": .metadata.labels}'
```

```
helm get manifest app | yq eval-all '[* . .] | map(select(.kind=="Deployment" and .metadata.name == "app"))'
```

```
kubectle get pods -n monitoring -o yaml | yq '.items.[] | [{"name": .metadata.name, "priority": .spec.priority }] '
```

```
kubectle get nodes -o json | jq '[.items[].metadata | {name, id: (.annotations."csi.volume.kubernetes.io/nodeid" | if type == "string" then fromjson."efs.csi.aws.com" else null end)}]' | yq -P
```

```
k get pods -o yaml | yq '.items[] | select(.metadata.name | test("app")) | [{"name": .metadata.name, "phase": .status.phase, "ip": .status.podIP}]'
```

```
helm list -a -A -o yaml  | yq 'map(select(.namespace=="pr-*")) | .[].namespace' | sort | uniq
```
