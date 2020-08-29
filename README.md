# vscode-tekton-container
This image allows the use of the Tekton Pipelines VS Code Extension in a CodeReady Workspaces or Eclipse Che workspace.

I've added a definition to my plugin registry [here](https://github.com/andykrohg/codeready-workspaces/tree/crw-2.4-rhel-8/dependencies/che-plugin-registry/v3/plugins/redhat-developer/vscode-tekton).

To gain access to this plugin in an operator-based install, override the `pluginRegistryImage` option in your `CheCluster` custom resource:

```
apiVersion: org.eclipse.che/v1
kind: CheCluster
metadata:
  name: codeready-workspaces
spec:
  server:
    pluginRegistryImage: quay.io/akrohg/che-plugin-registry:latest
```

Once the new `plugin-registry` starts, you should see **Tekton Pipelines** in the list of available workspace plugins. This assumes you have already installed the **OpenShift Pipelines** operator in your cluster.

## Adjusting permissions
Once you fire up your workspace and navigate to the **Tekton Pipelines** view, you'll notice a message that reads:
```
The current user doesn't have the privileges to interact with tekton resources.
```
This is due to the fact that CodeReady authenticates you as the namespace-scoped `che-workspace` service account. To fix this, you can take one of two approaches:
1. Grant `edit` permissions to the service account (as a project admin):
```
oc -n my-user-workspace adm policy add-role-to-user edit -z che-workspace
```

**OR**

2. Login as _your user_ in the Tekton Pipelines sidecar. 
* In CodeReady Workspaces, open a New Terminal in the `vscode-tektonxxx` container.
* Update your credentials using `oc`:
```
oc login -u my-user -p my-password
```
