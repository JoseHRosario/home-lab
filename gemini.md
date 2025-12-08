# Home Lab Documentation

This document provides an overview of the services running in this home lab environment, organized by their configuration files.

## Networks

The setup primarily uses two external networks:
- **`coiso`**: The main/production network connecting most services.
- **`development-server`**: A network for development services (`api`, `postgres`, `sqlserver`).

## Services

### 1. API (`docker-compose.api.yml`)
- **Service**: `hello-world`
- **Description**: A custom application built from `Dockerfiles/hello-world`.
- **Port**: `8088:8080`
- **Network**: `development-server`

### 2. Authelia (`docker-compose.authelia.yml`)
- **Service**: `authelia`
- **Description**: Authentication and authorization server.
- **Volumes**: Configs stored in `/srv/docker/authelia`.
- **Network**: `coiso`

### 3. Bitcoin (`docker-compose.bitcoin.yml`)
- **Services**:
  - `bitcoind`: Bitcoin core node (Port `8333`).
  - `btc-rpc-explorer`: Explorer for the Bitcoin node.
- **Data**: Blockchain data stored in `/d/srv/docker/bitcoin`.
- **Network**: `coiso`

### 4. Homepage (`docker-compose.homepage.yml`)
- **Service**: `homepage`
- **Description**: A dashboard to link all services.
- **Mounts**: Docker socket and config directory.
- **Networks**: `coiso`, `development-server`

### 5. Immich (`docker-compose.immich.yml`)
- **Purpose**: Self-hosted photo and video management (Google Photos alternative).
- **Services**:
  - `immich-server`: Main app (Port `2283`).
  - `immich-machine-learning`: ML for object detection/recognition.
  - `redis` & `database` (PostgreSQL with vectors).
- **Storage**: Maps to `/d/samba/pictures`.
- **Network**: `coiso`

### 6. Nextcloud (`docker-compose.nextcloud.yml`)
- **Services**: `nextcloud-app`, `nextcloud-db` (MariaDB).
- **Description**: File hosting and productivity platform.
- **Network**: `coiso`

### 7. Nginx Proxy Manager (NPM) (`docker-compose.npm.yml`)
- **Services**: `app` (NPM), `db` (MariaDB).
- **Ports**: `80` (HTTP), `443` (HTTPS), `81` (Admin).
- **Description**: Reverse proxy to expose services securely.
- **Network**: `coiso`

### 8. Pi-hole (`docker-compose.pihole.yml`)
- **Service**: `pihole`
- **Ports**: `53` (TCP/UDP).
- **Description**: Network-wide ad blocking and DNS server.
- **Network**: `coiso`

### 9. Postgres Dev (`docker-compose.postgres.yml`)
- **Services**:
  - `postgres-dev`: PostgreSQL database (Port `5432`).
  - `pgadmin`: Web-based management tool (Port `5050`).
- **Network**: `development-server`

### 10. Server Monitor (`docker-compose.server-monitor.yml`)
- **Purpose**: Observability stack.
- **Services**:
  - `prometheus`: Metrics collection.
  - `grafana`: Visualization.
  - `loki`: Log aggregation.
  - `alloy`: Telemetry collector (Port `12345`).
  - `node-exporter`: Hardware/OS metrics.
  - `cadvisor`: Container metrics (Port `8080`).
- **Network**: `coiso`

### 11. SQL Server (`docker-compose.sqlserver.yml`)
- **Service**: `mssql-server-dev`
- **Port**: `1433`.
- **Description**: Microsoft SQL Server for development.
- **Network**: `development-server`

### 12. Uptime Kuma (`docker-compose.uptimekuma.yml`)
- **Service**: `uptime-kuma`
- **Description**: Uptime monitoring tool.
- **Networks**: `coiso`, `development-server`

## Directories

- **Dockerfiles/**: Contains custom builds for `bitcoind`, `btc-rpc-explorer`, and `hello-world`.
- **.env**: Environment variables configuration.
- **Configs**: Most services map configurations to `/srv/docker/`.

## Notes
- Portainer is mentioned in `README.md` but not present as a compose file (likely run manually or globally).
- Ensure the external networks `coiso` and `development-server` are created before starting stacks (`docker network create coiso development-server`).
