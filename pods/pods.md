- kubectl proxy
- Open another termnail and then play with the kubectl command:
- kubectl get pods
- kubectl describe pods
- To get the POD-Name:
  - ```export POD_NAME="$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')"
    echo Name of the Pod: $POD_NAME
    ```
- To curl for this k8
  - curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME:8080/proxy/
- View the container logs
  - kubectl logs "$POD_NAME"
