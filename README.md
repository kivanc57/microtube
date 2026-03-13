this is my videostreaming app **microtube** where I:

- tweeking a REST API for streaming video to the browser with npm, node, Nodejs

- practice best practices of DevOps tools such as `git`, `Docker`, `Kubernetes`, `Microsoft Azure` and deployed it in my local machine

- specialized in **microservices** architecture to stimulate real-world business case

---

# notes

- **microservices** -> isolated, distributed, scalable, complex, flexible, great for evolving apps cloud, DevOps

- **monolith** -> great way for prototyping and only static apps

- `k8s` allow us to be independent from cloud vendors

- *containers*: unlike VMs, are lightweight & virtualize hardware

- *development* -> `docker compose` & production -> `k8s`

- *direct communication* -> they are at either end of communication, tight coupling

- *undirect communication* -> mid-man method, loose coupling

---

# design principles
- *Don't overengineer*, start with simple, apply continuous refactoring

- single responsabilty principle

- spearation of concerns

- loose coupling

- high cohesion

---

# docker notes

- docker **solves** -> building, shipping, removing, upgrading, distributing, trusting, running apps, *universal pckg mgr*

- every **run** == another **container** from **Docker image**

- **image** -> bootable snapshot of a system: disk, Docker image, os-install, vm, cd

- VM provide HW abstraction, whereas Docker uses containerization feat on kernel

- Docker mostly == namespaces + cgroups

- `docker compose` -> dev, `k8s` -> prod

---

## cmd

every cmd is also valid for `docker compose`

### manage images
docker build [options] . -t <app:version>

### general
docker images
docker ps -a
docker start
docker run
docker stop $ID
docker kill $ID

### delete
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -q)
docker system prune -a

### debug
docker logs $ID
docker exec -it $ID /bin/sh

### docker-compose
docker compose up --build
docker compose restart
docker compose down
docker compose logs

---

## kubernetes

- production backbone

- `pod` -> basic computing unit

- `node` -> PC/VM

- `deployment` -> keeps app running with N x replicas

- `service` -> log balances + dns to access

- instead of directly deploying app as a pod, use k8s deployment

- `NodePort` instead of `ClusterIP` -> expose service to outside

- port range: `30000` - `32767`

## cmd

- kind create cluster --name [name]

- kubectl get pods/nodes/deployments/services

- kubectl config use-context kind-[name]

- kubectl config get-contexts


## IMPORTANT NOTICE

*i had to stop working on this project because Microsoft Azure policies restricted me to increase the quota which is a must to work with a Kubernetes cluster on Azure*

---

# resource

- Nickoloff, J., & Kuenzli, S. (2019). Docker in action (2nd ed.). Manning Publications.

- Davis, A. (2024). Bootstrapping microservices: With Docker, Kubernetes, GitHub Actions, and Terraform (2nd ed.). Manning Publications.

