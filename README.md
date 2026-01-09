# Kubernetes Python Platform Project

## Overview

Python API + PostgreSQL | Docker | Kubernetes | Helm

This project demonstrates the design and implementation of a production-grade Kubernetes platform using a containerized Python application backed by PostgreSQL.
It focuses on real-world Kubernetes patterns including stateful workloads, dependency orchestration, init containers, jobs, health probes, and Helm-based deployment.

The project is built incrementally to mirror how platforms evolve in real organizations.

## Architecture

Client
  |
  |  (port-forward / service)
  v
Platform API (Deployment)
  |
  |-- InitContainer → waits for PostgreSQL readiness
  |
  |-- /health       → liveness/startup probe
  |-- /db-check     → readiness probe
  |
PostgreSQL (StatefulSet)
  |
  |-- PersistentVolumeClaim
  |-- Headless Service
  |
Migration Job
  |
  |-- InitContainer → waits for PostgreSQL
  |-- Runs once → schema migration

## Tech Stack
- Python (FastAPI)
- Docker
- Kubernetes
- Helm
- PostgreSQL

## Project Structure

| Directory | Purpose |
| `app/` | Application source code |
| `docker/` | Dockerfiles |
| `k8s/raw-manifests/` | Plain Kubernetes YAMLs (learning phase) |
| `k8s/helm/` | Helm charts (production packaging) |
| `docs/` | Architecture and design decisions |

## Implementation Phases

### Phase 0 — Environment Setup

**Goal:** Prepare a realistic Kubernetes development environment.
Docker desktop to the rescue.
```bash
kubectl get nodes
kubectl create namespace platform
kubectl config set-context --current --namespace=platform

Phase 1 — Application & Dockerization

**Goal:** Build a real, containerized application.

Python FastAPI app

/, /health, /db-check endpoints

Environment-driven configuration

Dockerfile using python:3.11-slim

docker build -t platform-api:1.0 .
docker run -p 8000:8000 platform-api:1.0
```

### Phase 2 — Kubernetes Deployment & Service

**Goal:** Run the application in Kubernetes correctly.

Deployment for stateless API
Service (ClusterIP) for internal access
Port-forwarding for local testing

kubectl apply -f api-deployment.yaml
kubectl apply -f api-service.yaml
kubectl port-forward svc/platform-api 8080:80
```

### Phase 3 — Configuration & Secrets

**Goal:** Separate configuration from code.

ConfigMap for environment variables

Secret for database credentials

Injected via envFrom

kubectl apply -f api-configmap.yaml
kubectl apply -f postgres-secret.yaml
```

### Phase 4 — PostgreSQL Stateful Workload

**Goal:** Deploy PostgreSQL correctly in Kubernetes.

StatefulSet with persistent storage

Headless Service for stable DNS

PVC for durable data

kubectl apply -f postgres-service.yaml
kubectl apply -f postgres-statefulset.yaml
```

### Phase 5 — Database Migrations (Jobs & InitContainers)

**Goal:** Run database schema migrations safely.

Kubernetes Job for one-time migration

InitContainer using pg_isready

Python migration script inside the image

Idempotent SQL execution

Key challenge solved:

Race condition between Postgres startup and migration execution

**Result:**
```
postgres-migration   Completed
```

### Phase 6 — Helm (Major Milestone)

**Goal:** Convert static YAML into a reusable platform.

Helm chart with templated manifests

Centralized values.yaml

_helpers.tpl for naming & labels

Clean install / upgrade / uninstall lifecycle

helm install platform ./platform -n platform
helm upgrade platform ./platform -n platform
helm uninstall platform -n platform
```

## Final State

```
kubectl get pods

platform-api-*        Running
postgres-0            Running
postgres-migration    Completed
```

## Key Learnings

Pod Running ≠ application readiness

InitContainers are the correct way to manage dependencies

Jobs are ideal for migrations, not Deployments

StatefulSets are mandatory for databases

Helm brings lifecycle management and reuse

Real Kubernetes engineering is about ordering, failure handling, and determinism

Future Enhancements