# kubectl

A lightweight Docker image bundling both **kubectl** and **helm** CLIs for Kubernetes cluster management, CI/CD automation, and scripting.

## Dockerhub Link
- <https://hub.docker.com/r/oneidels/kubectl>
---

## 🧰 Features

- 🛠️ Includes:
  - [kubectl](https://kubernetes.io/docs/reference/kubectl/)
  - [Helm](https://helm.sh/)
- 📦 Minimal and portable CLI environment
- 🚀 Ideal for:
  - CI/CD pipelines (GitHub Actions, GitLab CI, Jenkins, etc.)
  - Infrastructure automation
  - Local development without installing `kubectl` or `helm`

---

## 📝 Usage

### 🔍 `kubectl` example:
```bash
docker run --rm \
  -v ~/.kube:/root/.kube:ro \
  oneidels/kubectl \
  kubectl get pods --all-namespaces
```

### 📦 `helm` example:
```bash
docker run --rm \
  -v ~/.kube:/root/.kube:ro \
  -v $(pwd)/charts:/charts \
  oneidels/kubectl \
  helm install my-release /charts/my-app
```

---

## ⏰ Kubernetes CronJob example

Here’s a simple example of a CronJob that runs the `oneidels/kubectl` image to execute a Kubernetes command on a schedule:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: example-kubectl-cronjob
spec:
  schedule: "0 3 * * *"  # Runs daily at 3 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: kubectl
            image: oneidels/kubectl
            command:
              - /bin/sh
              - -c
              - kubectl get pods --all-namespaces
            volumeMounts:
            - name: kubeconfig
              mountPath: /root/.kube
              readOnly: true
          restartPolicy: OnFailure
          volumes:
          - name: kubeconfig
            secret:
              secretName: my-kubeconfig-secret
```

> **Note:**  
> The example assumes you have a Kubernetes Secret named `my-kubeconfig-secret` containing your kubeconfig file. Adjust as needed for your environment.

---

## 📂 Volumes

- Mount your local `~/.kube` config to `/root/.kube` inside the container for access to clusters.
- Mount Helm charts or other resources as needed for your use case.

---

## 📌 Notes

- Built for quick, secure use in automation.
- Tags follow common Kubernetes/Helm versioning.

---

## 📣 Contributing

Feel free to open issues or submit PRs to help improve this image. Feature requests welcome!

---

## 🔗 Resources

- [Kubernetes CLI docs](https://kubernetes.io/docs/reference/kubectl/)
- [Helm docs](https://helm.sh/docs/)
  
---

## 🏗️ Continuous Integration

GitHub Actions CI builds and publishes on these events:

- **Push to `main`**: builds immediately and tags the image as `oneidels/kubectl:latest`.
- **Nightly cron** (00:00 UTC): fetches the stable Kubernetes release, tags the image as `oneidels/kubectl:<k8s-version>` and `latest`.
- **Manual dispatch**: run the workflow interactively from the GitHub Actions tab.

The workflow is in `.github/workflows/docker-publish.yml`. To enable Docker Hub pushes, set these repository secrets:

- `DOCKERHUB_USERNAME` – your Docker Hub username
- `DOCKERHUB_TOKEN` – Docker Hub access token or password
