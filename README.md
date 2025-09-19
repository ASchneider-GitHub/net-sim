# Network Simulation Environment

Deploy a Docker-based fleet of containers for simulating network devices. One container exports **Syslog** messages, one generates and exports **NetFlow (v5 or v9)** traffic (*no internet access required*), and two allow for **SNMP (v2 and v3)** polling. Made for use with Ktranslate to test it's various functions.

## Requirements

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
  - This is easiest to do on Linux since the plugin version can be deployed from the package manager instead of via Docker Desktop: [Linux Install](https://docs.docker.com/compose/install/linux/#install-using-the-repository)


## Network Topology

All containers run inside the `sim-net` bridge network:

| Container            | Service           | IP Address    |
|----------------------|-------------------|---------------|
| `syslog-sim-device`  | Syslog Exporter   | 172.30.0.2    |
| `snmpv2-sim-device`  | SNMP v2 Agent     | 172.30.0.3    | 
| `snmpv3-sim-device`  | SNMP v3 Agent     | 172.30.0.4    |
| `netflow-sim-device` | NetFlow Exporter  | 172.30.0.5    |

*The gateway for the net-sim network is 172.30.0.1*

## Usage
### Building the image
*You only need to do this part once unless you modify `net-sim.dockerfile`*
```bash
docker compose build --no-cache
```
### Start up containers
```bash
docker compose up -d
```

### Stop/remove the containers
```bash
docker compose down
```

## Customization
- `./configs/` holds the base v2 and v3 SNMP configuration files. The user credentials can be adjusted, as well as the authentication/encryption settings and access-level.
- `./scripts/netflow_generator.sh` creates flow packets by setting up the `softflowd` exporter and then using `hping3` to hit the Docker bridge gateway with a mix of UDP and TCP packets on an array of ports.
  - `VERSION` can be used to change the Netflow version
  - `EXPORTPORT` changes which port netflow packets are exported over
  - `INTERVAL` adjusts the frequency of the `hping` loop (ping/sec)
- `./scripts/syslog_exporter.sh` continuously exports randomized packets that are compliant with RFC 5425. It's not recommended to change the script's formatting.
  - `EXPORTPORT` changes which port syslog packets are exported over

Any time you make changes, you will need to run `docker compose down` and then `docker compose up -d` to apply them.

## Instrumentation via Ktranslate
Included in the repo is the `./ktranslate/` directory. Inside are the following:
- A pre-filled `snmp-base.yaml` configuration file
- A backup of the configuration file (`snmp-base.yaml.bak`) in case a clean copy is needed
- Scripts that can launch each of the three Ktranslate container types. Run with `./launch_ktranslate_[netflow|snmp|syslog].sh`. You ***must*** `cd` into the `./ktranslate/` directory before proceeding, otherwise the configuration file will not be picked up correctly.
  - The simulation containers all run on a Docker bridge network. Launch your ktranslate containers using the provided scripts to avoid connection issues.

***Prior to running the launch scripts, you will need to set an environment variable with your New Relic account ID and ingest license key***
```bash
export NET_SIM_LICENSE=<license_key>
export NET_SIM_ACCOUNT=<account_id>
```

## SNMP Credentials
Unless changed via the files in `./configs`, these are the default credentials for the SNMP containers
- `snmpv2-sim-device`
    - Community string: `newrelic-net-sim`
- `snmpv3-sim-device`
    - Username: `newrelic-user`
    - Authentication protocol: `SHA`
    - Authentication passphrase: `newrelic-net-sim`
    - Privacy protocol: `AES`
    - Privacy passphrase: `newrelic-net-sim`
    - Authentication level: `authPriv`
