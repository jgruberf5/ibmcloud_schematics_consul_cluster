# Build a Secured Consul Cluster on IBM Gen2 VPC

Based on Ubuntu 20.04 LTS

You will need:

- CA certificate
- 3 Server Certificates and Keys (mTLS between servers and clients to server)
- 1 Client Certificate and Keys (mTLS from clients to servers)
- 1 Cluster Encryption Key (only authorized joining of the cluster)

## Variables

| Variable | Definition |
| --- | ---------- |
| `region` | The VPC region that you want your Consul cluster to be provisioned. |
| `resource_group` | The resource group you want used to create your Consul cluster. |
| `instance_profile` | The VPC instance profile name for your cluster members. |
| `ssh_key_name` | The SSH keyname to inject in your cluster members. |
| `internal_subnet_id` | Internal VPC subnet ID to attach your cluster members. |
| `cluster_encrypt_key` | Encryption key to secure cluster join. |
| `ca_cert_chain` | Trusted CA chain which signed your server and client certificates. |
| `server_01_cert` | Cluster member 1 certificate signed by your CA. |
| `server_01_key` | Cluster member 1 key. |
| `server_02_cert` | Cluster member 2 certificate signed by your CA. |
| `server_02_key` | Cluster member 2 key. |
| `server_03_cert` | Cluster member 3 certificate signed by your CA. |
| `server_03_key` | Cluster member 3 key. |
| `client_cert` | Client certificate signed by your CA used to communicate with your cluster. |
| `client_key` | Client key used to encrypt communications with your cluster. |

## Generating CA, Server, and Client TLS assets with consul

The consul binary executable for your platform has all you need to create the assets needed to populate the terraform variables.

### CA Key and Certificate

```bash
consul tls ca create
```

### Server Keys and Certificates

Create the CA Key and Certificate first and run these commands in the same directory.

```bash
consul tls cert create -server
consul tls cert create -server
consul tls cert create -server
```

This will create 3 server key and certificates signed by the CA key.

### Client Key and Certificate

```bash
consul tls cert create -client
```

Take the content of these files and place the exact text in the terraform variables.

As an example, setting the server_01_certificate:

```hcl
server_01_cert = <<EOS1CERT
-----BEGIN CERTIFICATE-----
MIIDGzCCAsGgAwIBAgIRAID03EYIE1SUOgTBOZsDEGswCgYIKoZIzj0EAwIwgbcx
CzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNU2FuIEZyYW5jaXNj
bzEaMBgGA1UECRMRMTAxIFNlY29uZCBTdHJlZXQxDjAMBgNVBBETBTk0MTA1MRcw
FQYDVQQKEw5IYXNoaUNvcnAgSW5jLjE+MDwGA1UEAxM1Q29uc3VsIEFnZW50IENB
IDc0NTE1NTI1NjExNjE3OTA2NDgwNTYzNTAzNDU1MDkzNTU3MzYwHhcNMjEwMzE3
MjAxNTMyWhcNMjIwMzE3MjAxNTMyWjAcMRowGAYDVQQDExFzZXJ2ZXIuZGMxLmNv
bnN1bDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABHqYbK1nRWkin2YaeDeyJ2QI
qmIpKQFOUMsMfL6GY70GzfCApXFKrOxMafhxUn69EGJR1fQd15mIol0nH9KFCIaj
ggFGMIIBQjAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsG
AQUFBwMCMAwGA1UdEwEB/wQCMAAwaAYDVR0OBGEEXzE5Ojg1Ojk2OjQwOjkyOjAw
OjYxOmI0OjllOmZmOjBjOjZkOjNiOjc2Ojc0OmIzOmNhOmU4OjVhOmQ4OjVhOjE3
OmIxOmE4OjE4OjgzOjA5OjVlOmMxOjAzOjgyOjM3MGoGA1UdIwRjMGGAXzUwOjkx
OjcwOmUzOmI0OmFjOjVlOmUwOjUzOjc2OmMzOmNjOjhiOjA2OmQyOjJhOmQ3Ojc0
OmZkOmM5OjM4OmI2OmM0OmRmOjc0OjIxOmI3OjZjOmZhOmZkOjQ4OjA2MC0GA1Ud
EQQmMCSCEXNlcnZlci5kYzEuY29uc3Vsgglsb2NhbGhvc3SHBH8AAAEwCgYIKoZI
zj0EAwIDSAAwRQIhAPfXiZI/792QIvv3oeKU6slqjxWU6/6c0nVDdvgTjLp/AiA3
yhnD1IzMiJw+NV+uX8cIIzsSUbeyPO+0kbdX0qciyA==
-----END CERTIFICATE-----
EOS1CERT
```

## Accessing your Cluster

The first server will have a Floating IP assigned to it. You can access the cluster by connecting to your cluster on this Floating IP.

```bash
ssh -i [SSH key] ubuntu@[Floating IP]
```

Once connected you can tell the local consul agent to act as a client and connect to your client. You will need to use environment variables to tell the consul client where its certificate and key are found for mTLS authentication with the local cluster. The template has done this for you and placed it in an `env` file at `/etc/consul/client.env`. Source this file.

```bash
source /etc/consul/client.env
```

The content of the `client.env` file:

```bash
export CONSUL_CLIENT_CERT=/etc/consul/ssl/dc1-client-consul-0.pem
export CONSUL_CLIENT_KEY=/etc/consul/ssl/dc1-client-consul-0-key.pem
export CONSUL_CACERT=/etc/consul/ssl/consul-agent-ca.pem
export CONSUL_HTTP_SSL=true
export CONSUL_HTTP_ADDR=https://127.0.0.1:8501
```

Once you have this you can issue consul commands directly to your cluster.

```bash
$ consul members
Node                                                      Address             Status  Type    Build  Protocol  DC   Segment
f5-consul-server-01-67161b76-b498-7d3b-9bea-b8252bf1a59e  10.240.131.39:8301  alive   server  1.5.2  2         dc1  <all>
f5-consul-server-02-67161b76-b498-7d3b-9bea-b8252bf1a59e  10.240.131.40:8301  alive   server  1.5.2  2         dc1  <all>
f5-consul-server-03-67161b76-b498-7d3b-9bea-b8252bf1a59e  10.240.131.41:8301  alive   server  1.5.2  2         dc1  <all>

```

## Access the HTTP API for your Cluster

Access to your cluster's HTTP API requires the use of mTLS authentication. You simply use the client certificate and key you generated to access your cluster on the standard HTTP API REST endpoints using only HTTPS (port 8501 for consul). The HTTP (unencrypted) listeners (port 8500) have been disabled.

[Consul API Documentation](https://www.consul.io/api-docs)
