# A Table of Contents for All Gruntwork Code

This repo is a convenient way to find all of the repositories created and maintained by [Gruntwork](http://www.gruntwork.io/). It is intended primarily for Gruntwork's customers.

_Please note that most of the links are private. If you don't have access to them, you'll get a 404 page! To gain access, you must be a Gruntwork customer. See [gruntwork.io](http://www.gruntwork.io/) for more info and feel free to reach out to us at [info@gruntwork.io](mailto:info@gruntwork.io) if you have questions._

### Outline

1. [Terminology](#terminology)
1. [Infrastructure Packages](#infrastructure-packages)
1. [Reference Architecture](#reference-architecture)
1. [Gruntwork Open Source Tools](#gruntwork-open-source-tools)
1. [Gruntwork Training Reference Materials](#gruntwork-training-reference-materials)
1. [Operating System Compatibility](#operating-system-compatibility)
1. [How to use the code](#how-to-use-the-code)

### Terminology

- **Infrastructure Package:** A reusable, tested, documented, configurable, best-practices definition of a single
piece of Infrastructure (e.g., Docker cluster, VPC, Jenkins, Consul), written using a combination of Terraform, Go, and Bash. This code has been proven in production, providing the underlying infrastructure for [Gruntwork's customers](http://www.gruntwork.io/clients).

- **Module:** Each Infrastructure Package consists one or more orthogonal modules that handle some specific aspect of that Infrastructure Package's functionality. Breaking the code up into multiple modules makes it easier to reuse and compose to handle many different use cases.

- **Reference Architecture:** A best-practices way to combine all of Gruntwork's Infrastructure Packages into an end-to-end tech stack that contains just about all the infrastructure a company needs, including Docker clusters, databases, caches, load balancers, VPCs, CI servers, VPN servers, monitoring systems, log aggregation, alerting, secrets management, and so on. We build this all using infrastructure as code and immutable infrastructure principles, give you 100% of the code, and can get it deployed in minutes.

### Infrastructure Packages

These are the Infrastructure Packages Gruntwork currently has available:

##### AWS

Our IaC modules that support deploying and managing production grade infrastructure on Amazon Web Services (AWS).

1. **[Network Topology](https://github.com/gruntwork-io/module-vpc)**: Create best-practices Virtual Private Clouds (VPCs) on AWS. The main modules are:
    1. [vpc-app](https://github.com/gruntwork-io/module-vpc/tree/master/modules/vpc-app): Launch a VPC meant to house applications and production code. This module creates the VPC, 3 "tiers" of subnets (public, private app, private persistence) across all Availability Zones, route tables, routing rules, Internet gateways, and NAT gateways.
    1. [vpc-mgmt](https://github.com/gruntwork-io/module-vpc/tree/master/modules/vpc-mgmt): Launch a VPC meant to house internal tools (e.g. Jenkins, VPN server). This module creates the VPC, 2 "tiers" of subnets (public, private), route tables, routing rules, Internet gateways, and NAT gateways.
    1. [vpc-app-network-acls](https://github.com/gruntwork-io/module-vpc/tree/master/modules/vpc-app-network-acls): Add a default set of Network ACLs to a VPC created using the vpc-app module that strictly control what inbound and outbound network traffic is allowed in each subnet of that VPC.
    1. [vpc-mgmt-network-acls](https://github.com/gruntwork-io/module-vpc/tree/master/modules/vpc-mgmt-network-acls): Add a default set of Network ACLs to a VPC created using the vpc-mgmt module that strictly control what inbound and outbound network traffic is allowed in each subnet of that VPC.
    1. [vpc-peering](https://github.com/gruntwork-io/module-vpc/tree/master/modules/vpc-peering): Create peering connections between your VPCs to allow them to communicate with each other.
    1. [vpc-peering-external](https://github.com/gruntwork-io/module-vpc/tree/master/modules/vpc-peering-external): Create peering connections between your VPCs and VPCs managed in other (external) AWS accounts.

1. **[Monitoring and Alerting](https://github.com/gruntwork-io/module-aws-monitoring)**: Configure monitoring, log aggregation, and alerting using CloudWatch, SNS, and S3. The main modules are:
    1. [alarms](https://github.com/gruntwork-io/module-aws-monitoring/tree/master/modules/alarms): A collection of more than 20 modules that set up CloudWatch Alarms for a variety of AWS services, such as CPU, memory, and disk space usage for EC2 Instances, Route 53 health checks for public endpoints, 4xx/5xx/connection errors for load balancers, and a way to send alarm notifications to a Slack channel.
    1. [logs](https://github.com/gruntwork-io/module-aws-monitoring/tree/master/modules/logs): A collection of modules to set up log aggregation, including one to send logs from all of your EC2 instances to CloudWatch Logs, one to rotate and rate-limit logging so you don't run out of disk space, and one to store all load balancer logs in S3.
    1. [metrics](https://github.com/gruntwork-io/module-aws-monitoring/tree/master/modules/metrics): Modules that add custom metrics to CloudWatch, including critical metrics not visible to the EC2 hypervisor, such as memory usage and disk space usage.

1. **[Docker Cluster](https://github.com/gruntwork-io/module-ecs)**: Code to deploy and manage Docker containers on top of Amazon's EC2 Container Service (ECS). The main modules are:
    1. [ecs-cluster](https://github.com/gruntwork-io/module-ecs/tree/master/modules/ecs-cluster): Deploy an Auto Scaling Group (ASG) that ECS can use for running Docker containers. The size of the ASG can be scaled up or down in response to load.
    1. [ecs-service](https://github.com/gruntwork-io/module-ecs/tree/master/modules/ecs-service): Deploy a Docker container as a long-running ECS Service. Includes support for automated, zero-downtime deployment, auto-restart of crashed containers, and automatic integration with the Elastic Load Balancer (ELB).
    1. [ecs-fargate](https://github.com/gruntwork-io/module-ecs/tree/master/modules/ecs-fargate): Deploy a Docker container as a long-running Fargate Service. A Fargate service automatically manages and scales your cluster as needed without you needing to manage the underlying EC2 instances or clusters, it also includes integration with an Application Load Balancer (ALB) or a Network Load Balancer (NLB).
    1. [ecs-service-with-alb](https://github.com/gruntwork-io/module-ecs/tree/master/modules/ecs-service-with-alb): Deploy a Docker container as a long-running ECS Service. Includes support for automated, zero-downtime deployment, auto-restart of crashed containers, and automatic integration with the Application Load Balancer (ALB).
    1. [ecs-deploy](https://github.com/gruntwork-io/module-ecs/tree/master/modules/ecs-deploy): Deploy a Docker container as a short-running ECS Task, wait for it to exit, and exit with the same exit code as the ECS Task.

1. **[AMI Cluster](https://github.com/gruntwork-io/module-asg)**: Deploy a best-practices Auto Scaling Group (ASG) that can run a cluster of servers, automatically restart failed nodes, and scale up and down in response to load. The main modules are:
    1. [asg-rolling-deploy](https://github.com/gruntwork-io/module-asg/tree/master/modules/asg-rolling-deploy): Create an ASG that can do a zero-downtime rolling deployment.
    1. [server-group](https://github.com/gruntwork-io/module-asg/tree/master/modules/server-group): Run a fixed-size cluster of servers, backed by ASGs, that can automatically attach EBS Volumes and ENIs, while still supporting zero-downtime deployment.

1. **[Load Balancer](https://github.com/gruntwork-io/module-load-balancer)**: Run a highly-available and scalable load balancer in AWS. The main modules are:
    1. [alb](https://github.com/gruntwork-io/module-load-balancer/tree/master/modules/alb): Deploy an Application Load Balancer (ALB) in AWS. It supports HTTP, HTTPS, HTTP/2, WebSockets, path-based routing, host-based routing, and health checks.
    1. [nlb](https://github.com/gruntwork-io/module-load-balancer/tree/master/modules/nlb): Deploy a Network Load Balancer (NLB) in AWS. It supports TCP, WebSockets, static IPs, high throughputs, and health checks.

1. **[Lambda](https://github.com/gruntwork-io/package-lambda)**: Deploy and manage AWS Lambda functions. The main modules are:
    1. [lambda](https://github.com/gruntwork-io/package-lambda/tree/master/modules/lambda): Deploy and manage AWS Lambda functions. Includes support for automatically uploading your code to AWS, configuring an IAM role for your Lambda function, and giving your Lambda function access to your VPCs.
    1. [scheduled-lambda-job](https://github.com/gruntwork-io/package-lambda/tree/master/modules/scheduled-lambda-job): Configure your Lambda function to run on a scheduled basis, like a cron job.
    1. [keep-warm](https://github.com/gruntwork-io/package-lambda/tree/master/modules/keep-warm): This is a Lambda function you can use to invoke your other Lambda functions on a scheduled basis to keep those functions "warm," avoiding the cold start issue.
    1. [lambda-edge](https://github.com/gruntwork-io/package-lambda/tree/master/modules/lambda-edge): This module makes it easy to deploy and manage an AWS Lambda@Edge function. Lambda@Edge gives you a way to run code on-demand in AWS Edge locations without having to manage servers.

1. **[API Gateway and SAM](https://github.com/gruntwork-io/package-sam)**: Modules for deploying and managing Serverless Application Model applications with Lambda, API Gateway, and Terraform.
    1. [gruntsam](https://github.com/gruntwork-io/package-sam/tree/master/modules/gruntsam): CLI tool that allows you to define your APIs using Swagger, run and test your code locally using SAM, and deploy your code to production using API Gateway and Lambda.
    1. [api-gateway-account-settings](https://github.com/gruntwork-io/package-sam/tree/master/modules/api-gateway-account-settings): set the global (regional) settings required to allow API Gateway to write to CloudWatch logs.

1. **[Security](https://github.com/gruntwork-io/module-security)**: Best practices for managing secrets, credentials, servers, and users. The main modules are:
    1. [auto-update](https://github.com/gruntwork-io/module-security/tree/master/modules/auto-update): Configure your servers to automatically install critical security patches.
    1. [aws-auth](https://github.com/gruntwork-io/module-security/tree/master/modules/aws-auth): A script that makes it much easier to use the AWS CLI with MFA and/or multiple AWS accounts.
    1. [cloudtrail](https://github.com/gruntwork-io/module-security/tree/master/modules/cloudtrail): Configure CloudTrail in an AWS account to audit all API calls.
    1. [kms-master-key](https://github.com/gruntwork-io/module-security/tree/master/modules/kms-master-key): Create a master key in Amazon's Key Management Service and configure permissions for that key.
    1. [ssh-grunt](https://github.com/gruntwork-io/module-security/tree/master/modules/ssh-grunt): Manage SSH access to your servers using an identity provider, such as AWS IAM groups or Gruntwork Houston. Every developer in a managed group you specify will be able to SSH to your servers using their own username and SSH key.
    1. [ssh-grunt-selinux-policy](https://github.com/gruntwork-io/module-security/tree/master/modules/ssh-grunt-selinux-policy): Install a SELinux Local Policy Module that is necessary to make ssh-grunt work on systems with SELinux, such as CentOS.
    1. [iam-groups](https://github.com/gruntwork-io/module-security/tree/master/modules/iam-groups): Create a best-practices set of IAM groups for managing access to your AWS account.
    1. [iam-user-password-policy](https://github.com/gruntwork-io/module-security/tree/master/modules/iam-user-password-policy): Set the AWS Account Password Policy that will govern password requirements for IAM Users.
    1. [cross-account-iam-roles](https://github.com/gruntwork-io/module-security/tree/master/modules/cross-account-iam-roles): Create IAM roles that allow IAM users to easily switch between AWS accounts.
    1. [fail2ban](https://github.com/gruntwork-io/module-security/tree/master/modules/fail2ban): Install fail2ban on your servers to automatically ban malicious users.
    1. [os-hardening](https://github.com/gruntwork-io/module-security/tree/master/modules/os-hardening): Build a hardened Linux-AMI that implements certian CIS benchmarks.
    1. [ntp](https://github.com/gruntwork-io/module-security/tree/master/modules/ntp): Install and configures NTP on a Linux server.
    1. [ip-lockdown](https://github.com/gruntwork-io/module-security/tree/master/modules/ip-lockdown): Install ip-lockdown on your servers to automatically lock down access to specific IPs, such as locking down the EC2 metadata endpoint so only the root user can access it.

1. **[GruntKMS](https://github.com/gruntwork-io/gruntkms)**: A command-line tool that makes it very easy to manage application secrets using Amazon's Key Management Service (KMS). GruntKMS is written in Go and compiles into a standalone binary for every major OS.

1. **[Continuous Delivery](https://github.com/gruntwork-io/module-ci)**: Automate common Continuous Integration (CI) and Continuous Delivery (CD) tasks, such as installing dependencies, running tests, packaging code, and publishing releases. The main modules are:
    1. [aws-helpers](https://github.com/gruntwork-io/module-ci/tree/master/modules/aws-helpers): Automate common AWS tasks, such as publishing AMIs to multiple regions.
    1. [build-helpers](https://github.com/gruntwork-io/module-ci/tree/master/modules/build-helpers): Automate the process of building versioned, immutable, deployable artifacts, including Docker images and AMIs built with Packer.
    1. [circleci-helpers](https://github.com/gruntwork-io/module-ci/tree/master/modules/circleci-helpers): Configure the CircleCI environment, including installing Go and configuring GOPATH.
    1. [iam-policies](https://github.com/gruntwork-io/module-ci/tree/master/modules/iam-policies): Configure common IAM policies for CI servers, including policies for automatically pushing Docker containers to ECR, deploying Docker images to ECS, and using S3 for Terraform remote state.
    1. [terraform-helpers](https://github.com/gruntwork-io/module-ci/tree/master/modules/terraform-helpers): Automate common CI tasks that involve Terraform, such as automatically updating variables in a `.tfvars` file.
    1. [ec2-backup](https://github.com/gruntwork-io/module-ci/tree/master/modules/ec2-backup): Run a Lambda function to make scheduled backups of EC2 Instances.
    1. [install-jenkins](https://github.com/gruntwork-io/module-ci/tree/master/modules/install-jenkins): Install Jenkins on a Linux server.
    1. [jenkins-server](https://github.com/gruntwork-io/module-ci/tree/master/modules/jenkins-server): Deploy a Jenkins server with an ASG, EBS Volume, ALB, and Route 53 settings.

1. **[Relational Database](https://github.com/gruntwork-io/module-data-storage)**: Deploy and manage relational databases such as MySQL and PostgreSQL using Amazon's Relational Database Service (RDS). The main modules are:
    1. [rds](https://github.com/gruntwork-io/module-data-storage/tree/master/modules/rds): Deploy a relational database on top of RDS. Includes support for MySQL, PostgreSQL, Oracle, and SQL Server, as well as automatic failover, read replicas, backups, patching, and encryption.
    1. [aurora](https://github.com/gruntwork-io/module-data-storage/tree/master/modules/aurora): Deploy Amazon Aurora on top of RDS. This is a MySQL-compatible database that supports automatic failover, read replicas, backups, patching, and encryption.
    1. [lambda-create-snapshot](https://github.com/gruntwork-io/module-data-storage/tree/master/modules/lambda-create-snapshot): Create an AWS Lambda function that runs on a scheduled basis and takes snapshots of an RDS database for backup purposes. Includes an AWS alarm that goes off if backup fails.
    1. [lambda-share-snapshot](https://github.com/gruntwork-io/module-data-storage/tree/master/modules/lambda-share-snapshot): An AWS Lambda function that can automatically share an RDS snapshot with another AWS account. Useful for storing your RDS backups in a separate backup account.
    1. [lambda-copy-shared-snapshot](https://github.com/gruntwork-io/module-data-storage/tree/master/modules/lambda-copy-shared-snapshot): An AWS Lambda function that can make a local copy of an RDS snapshot shared from another AWS account. Useful for storing yoru RDS backups in a separate backup account.
    1. [lambda-cleanup-snapshots](https://github.com/gruntwork-io/module-data-storage/tree/master/modules/lambda-cleanup-snapshots): An AWS Lambda function that runs on a scheduled basis to clean up old RDS database snapshots. Useful to ensure you aren't spending lots of money storing old snapshots you no longer need.

1. **[Distributed Cache](https://github.com/gruntwork-io/module-cache)**: Deploy and manage Redis or Memcached on Amazon's ElastiCache service. The main modules are:
    1. [redis](https://github.com/gruntwork-io/module-cache/tree/master/modules/redis): Deploy a Redis cluster on top of ElastiCache. Includes support for automatic failover, backup, patches, and cluster scaling.
    1. [memcached](https://github.com/gruntwork-io/module-cache/tree/master/modules/memcached): Deploy a Memcached cluster on top of ElastiCache.

1. **[Stateful Server](https://github.com/gruntwork-io/module-server)**: Deploy and manage a single server server on AWS. This is mainly useful for "stateful" servers that store data on their local hard disk, such as WordPress or Jenkins. The main modules are:
    1. [single-server](https://github.com/gruntwork-io/module-server/tree/master/modules/single-server): Run a server in AWS and configure its IAM role, security group, optional Elastic IP Address (EIP), and optional DNS A record in Route 53.
    1. [attach-eni](https://github.com/gruntwork-io/module-server/tree/master/modules/attach-eni): Attach an Elastic Network Interface (ENI) to a server during boot. This is useful when you need to maintain a pool of IP addresses that remain static even as the underlying servers are replaced.
    1. [persistent-ebs-volume](https://github.com/gruntwork-io/module-server/tree/master/modules/persistent-ebs-volume): Attach and mount an EBS Volume in a server during boot. This is useful when you want to maintain data on a hard disk even as the underlying server is replaced.
    1. [route53-helpers](https://github.com/gruntwork-io/module-server/tree/master/modules/route53-helpers): Attach a DNS A record in Route 53 to a server during boot. This is useful when you want a pool of domain names that remain static even as the underlying servers are replaced.

1. **[Static Assets](https://github.com/gruntwork-io/package-static-assets)**: Store and serve your static content (i.e., CSS, JS, images) using S3 and CloudFront. The main modules are:
    1. [s3-static-website](https://github.com/gruntwork-io/package-static-assets/tree/master/modules/s3-static-website): Create an S3 bucket to host a static website. Includes support for custom routing rules and custom domain names.
    1. [s3-cloudfront](https://github.com/gruntwork-io/package-static-assets/tree/master/modules/s3-cloudfront): Deploy a CloudFront distribution as a CDN in front of an S3 bucket. Includes support for custom caching rules, custom domain names, and SSL.

1. **[MongoDB Cluster](https://github.com/gruntwork-io/package-mongodb)**: Run a production-ready MongoDB cluster in AWS. The main modules are:
    1. [install-mongodb](https://github.com/gruntwork-io/package-mongodb/tree/master/modules/install-mongodb): Install MongoDB and all of its dependencies on a Linux server.
    1. [run-mongodb](https://github.com/gruntwork-io/package-mongodb/tree/master/modules/run-mongodb): Boot up a mongod, mongos, or mongo config server. Meant to be used in the User Data of the servers in your MongoDB cluster.
    1. [mongodb-cluster](https://github.com/gruntwork-io/package-mongodb/tree/master/modules/mongodb-cluster): Run a MongoDB cluster using an Auto Scaling Group (ASG) and configure its IAM role, security group, EBS Volume, ENI, and private domain name.
    1. [backup-mongodb](https://github.com/gruntwork-io/package-mongodb/tree/master/modules/backup-mongodb): Back up the data in your MongoDB cluster to S3.
    1. [init-mongodb](https://github.com/gruntwork-io/package-mongodb/tree/master/modules/init-mongodb): Configure a MongoDB replica set.

1. **[OpenVPN Server](https://github.com/gruntwork-io/package-openvpn)**: Deploy an OpenVPN server and control access to it using IAM. The main modules are:
    1. [install-openvpn](https://github.com/gruntwork-io/package-openvpn/tree/master/modules/install-openvpn): Install OpenVPN and its dependencies on a Linux server.
    1. [init-openvpn](https://github.com/gruntwork-io/package-openvpn/tree/master/modules/install-openvpn): Initialize an OpenVPN server, including its Public Key Infrastructure (PKI), Certificate Authority (CA) and configuration.
    1. [openvpn-admin](https://github.com/gruntwork-io/package-openvpn/tree/master/modules/openvpn-admin): A command-line utility that allows users to request new certificates, administrators to revoke certificates and the OpenVPN server to process those requests. All access and permissions are controlled via IAM.
    1. [openvpn-server](https://github.com/gruntwork-io/package-openvpn/tree/master/modules/openvpn-server): Deploy an OpenVPN server and configure its IAM role, security group, Elastic IP Address (EIP), S3 bucket for storage, and SQS queues.

1. **[Messaging](https://github.com/gruntwork-io/package-messaging)**: Manage AWS Simple Queue Service (SQS) queues, AWS Simple Notification Service (SNS) topics, and AWS Kinesis streams. The main modules are:
    1. [sqs](https://github.com/gruntwork-io/package-messaging/tree/master/modules/sqs): Create an SQS queue. Includes support for FIFO, dead letter queues, and IP-limiting.
    1. [sns](https://github.com/gruntwork-io/package-messaging/tree/master/modules/sns): Create an SNS topic as well as the publisher and subscriber policies for that topic.
    1. [kinesis](https://github.com/gruntwork-io/package-messaging/tree/master/modules/kinesis): Create a Kinesis stream and configure its sharding settings.

1. **[Consul](https://github.com/hashicorp/terraform-aws-consul)**: Deploy and manage a Consul cluster on AWS. The main modules are:
    1. [install-consul](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-consul): Install Consul and its dependencies on a Linux server.
    1. [install-dnsmasq](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/install-dnsmasq): Install dnsmasq on a Linux server and configure it to work with Consul as a DNS server. This allows you to use domain names such as my-app.service.consul.
    1. [run-consul](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/run-consul): Run Consul and automatically bootstrap the cluster.
    1. [consul-cluster](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-cluster): Deploy a Consul cluster on AWS using an Auto Scaling Group.

1. **[Nomad](https://github.com/hashicorp/terraform-aws-nomad)**: Deploy and manage a Nomad cluster on AWS. The main modules are:
    1. [install-nomad](https://github.com/hashicorp/terraform-aws-nomad/tree/master/modules/install-nomad): Install Nomad and its dependencies on a Linux server.
    1. [run-nomad](https://github.com/hashicorp/terraform-aws-nomad/run-nomad): Run Nomad and automatically connect to a Consul cluster.
    1. [nomad-cluster](https://github.com/hashicorp/terraform-aws-nomad/tree/master/modules/nomad-cluster): Deploy a Nomad cluster on AWS using an Auto Scaling Group.

1. **[Vault](https://github.com/hashicorp/terraform-aws-vault)**: Deploy and manage a Vault cluster on AWS. The main modules are:
    1. [install-vault](https://github.com/hashicorp/terraform-aws-vault/tree/master/modules/install-vault): Install Vault and its dependencies on a Linux server.
    1. [run-vault](https://github.com/hashicorp/terraform-aws-vault/tree/master/modules/run-vault): Run Vault and automatically connect to a Consul cluster.
    1. [private-tls-cert](https://github.com/hashicorp/terraform-aws-vault/tree/master/modules/private-tls-cert): Generate self-signed TLS certificates for use with Vault.
    1. [vault-cluster](https://github.com/hashicorp/terraform-aws-vault/tree/master/modules/vault-cluster): Deploy a Vault cluster on AWS using an Auto Scaling Group.

1. **[Couchbase](https://github.com/gruntwork-io/terraform-aws-couchbase/)**: Deploy and manage a Couchbase cluster on AWS. The main modules are:
    1. [install-couchbase-server](https://github.com/gruntwork-io/terraform-aws-couchbase/tree/master/modules/install-couchbase-server): Install Couchbase and its dependencies on a Linux server.
    1. [install-sync-gateway](https://github.com/gruntwork-io/terraform-aws-couchbase/tree/master/modules/install-sync-gateway): Install Sync Gateway and its dependencies on a Linux server.
    1. [run-couchbase-server](https://github.com/gruntwork-io/terraform-aws-couchbase/tree/master/modules/run-couchbase-server): Configure and run Couchbase.
    1. [run-sync-gateway](https://github.com/gruntwork-io/terraform-aws-couchbase/tree/master/modules/run-sync-gateway): Configure and start Sync Gateway.
    1. [couchbase-cluster](https://github.com/gruntwork-io/terraform-aws-couchbase/tree/master/modules/couchbase-cluster): Deploy a Couchbase cluster on AWS using an Auto Scaling Group.

1. **[InfluxDB](https://github.com/gruntwork-io/terraform-aws-influx/)**: Deploy and manage an InfluxDB cluster on AWS. The main modules are:
    1. [install-influxdb](https://github.com/gruntwork-io/terraform-aws-influx/tree/master/modules/install-influxdb): Install InfluxDB Enterprise and its dependencies on a Linux server.
    1. [run-influxdb](https://github.com/gruntwork-io/terraform-aws-influx/tree/master/modules/run-influxdb): Configure and run InfluxDB.
    1. [influxdb-cluster](https://github.com/gruntwork-io/terraform-aws-influx/tree/master/modules/influxdb-cluster): Deploy an InfluxDB cluster on AWS using an Auto Scaling Group.

1. **[ZooKeeper](https://github.com/gruntwork-io/package-zookeeper)**: Deploy and manage a ZooKeeper cluster, along with Exhibitor, on AWS. The main modules are:
    1. [install-zookeeper](https://github.com/gruntwork-io/package-zookeeper/tree/master/modules/install-zookeeper): Install ZooKeeper and its dependencies on a Linux server.
    1. [install-exhibitor](https://github.com/gruntwork-io/package-zookeeper/tree/master/modules/install-exhibitor): Install Exhibitor and its dependencies on a Linux server.
    1. [zookeeper-cluster](https://github.com/gruntwork-io/package-zookeeper/tree/master/modules/zookeeper-cluster): Deploy a ZooKeeper cluster using the server-group module from the AMI Cluster Infrastructure Package. Includes support for EBS Volumes for the transaction log as well as a set of ENIs to provide static IP addresses to ZooKeeper clients.

1. **[Kafka](https://github.com/gruntwork-io/package-kafka)**: Deploy and manage a cluster of Kafka brokers on AWS, plus Confluent tools (REST Proxy, Schema Registry, Kafka Connect). The main modules are:
    1. [install-kafka](https://github.com/gruntwork-io/package-kafka/tree/master/modules/install-kafka): Install Kafka and its dependencies on a Linux server.
    1. [kafka-cluster](https://github.com/gruntwork-io/package-kafka/tree/master/modules/kafka-cluster): Deploy a Kafka cluster using the server-group module from the AMI Cluster Infrastructure Package. Includes support for EBS Volumes for the Kafka log.
    1. [confluent-tools-cluster](https://github.com/gruntwork-io/package-kafka/tree/master/modules/confluent-tools-cluster): Run a cluster of Confluent tools (REST Proxy, Schema Registry, Kafka Connect).
    1. [install-confluent-tools](https://github.com/gruntwork-io/package-kafka/tree/master/modules/install-confluent-tools): Install Confluent tools (REST Proxy and Schema Registry) on Linux.
    1. [run-kafka-connect](https://github.com/gruntwork-io/package-kafka/tree/master/modules/run-kafka-connect): Configure and run Kafka Connect.
    1. [run-kafka-rest](https://github.com/gruntwork-io/package-kafka/tree/master/modules/run-kafka-rest): Configure and run Kafka REST Proxy.
    1. [run-schema-registry](https://github.com/gruntwork-io/package-kafka/tree/master/modules/run-schema-registry): Configure and run Schema Registry.

1. **[ELK Stack](https://github.com/gruntwork-io/package-elk)**: Deploy and manage a best practice ELK stack cluster. The main modules are:
    1. [elasticsearch-cluster](https://github.com/gruntwork-io/package-elk/tree/master/modules/elasticsearch-cluster): Deploy a cluster of Elasticsearch nodes with zero-downtime deployment and auto-recovery of failed nodes.
    1. [kibana-cluster](https://github.com/gruntwork-io/package-elk/tree/master/modules/kibana-cluster): Deploy a cluster of Kibana nodes with zero-downtime deployment and auto-recovery of failed nodes.
    1. [logstash-cluster](https://github.com/gruntwork-io/package-elk/tree/master/modules/logstash-cluster): Deploy a cluster of Logstash nodes with zero-downtime deployment and auto-recovery of failed nodes.
    1. [elastalert](https://github.com/gruntwork-io/package-elk/tree/master/modules/elastalert): Runs [ElastAlert](https://github.com/Yelp/elastalert) in an instance, which makes API calls to the Elasticsearch cluster and sends alerts based on pre-defined data pattern rules.
    1. [run-filebeat](https://github.com/gruntwork-io/package-elk/tree/master/modules/run-filebeat): Runs Filebeat on an application server to ship application logs off to Logstash cluster.
    1. [run-collectd](https://github.com/gruntwork-io/package-elk/tree/master/modules/run-collectd): Runs CollectD on an application server and ships off machine metrics to th Logstash cluster.

1. **Kubernetes**: _(The packages in this category are in private beta)_ Deploy and manage a best practice Kubernetes cluster and Kubernetes services.
    1. **[EKS](https://github.com/gruntwork-io/terraform-aws-eks)**: Deploy and manage a best practice EKS cluster. The main modules are:
        1. [eks-cluster-control-plane](https://github.com/gruntwork-io/terraform-aws-eks/tree/master/modules/eks-cluster-control-plane): Deploy an EKS control plane managed by AWS with support to configure your local `kubectl` to authenticate with EKS.
        1. [eks-cluster-workers](https://github.com/gruntwork-io/terraform-aws-eks/tree/master/modules/eks-cluster-workers): Deploy a cluster of EC2 instances registered as Kubernetes workers with auto-recovery of failed nodes.
        1. [eks-k8s-role-mapping](https://github.com/gruntwork-io/terraform-aws-eks/tree/master/modules/eks-k8s-role-mapping): Manage mappings between IAM roles and RBAC groups as code for provisioning accounts that can access the Kubernetes API.
        1. [eks-vpc-tags](https://github.com/gruntwork-io/terraform-aws-eks/tree/master/modules/eks-vpc-tags): Provides tags for your VPC to ensure Kubernetes uses it for allocating IP addresses to Pods and Services.
        1. [eks-cloudwatch-container-logs](https://github.com/gruntwork-io/terraform-aws-eks/tree/master/modules/eks-cloudwatch-container-logs): Deploys Helm chart that installs fluentd into your cluster to aggregate Kubernetes logs for shipping to CloudWatch.
        1. [eks-alb-ingress-controller](https://github.com/gruntwork-io/terraform-aws-eks/tree/master/modules/eks-alb-ingress-controller): Deploys Helm chart that installs the AWS ALB Ingress Controller into your cluster to map Ingress resources to ALBs.
        1. [eks-k8s-external-dns](https://github.com/gruntwork-io/terraform-aws-eks/tree/master/modules/eks-k8s-external-dns): Deploys Helm chart that installs the external-dns application into your cluster to map Ingress hostnames to Route 53 Domain records.
    1. **[Helm Server](https://github.com/gruntwork-io/terraform-kubernetes-helm)**: Deploy and manage best practice Tiller Pods (Helm Server) on your Kubernetes cluster. The main modules are:
        1. [k8s-namespace](https://github.com/gruntwork-io/terraform-kubernetes-helm/tree/master/modules/k8s-namespace): Create a namespace in Kubernetes with a set of predefined RBAC roles.
        1. [k8s-namespace-roles](https://github.com/gruntwork-io/terraform-kubernetes-helm/tree/master/modules/k8s-namespace-roles): Create a set of predefined RBAC roles for use with an existing namespace.
        1. [k8s-service-account](https://github.com/gruntwork-io/terraform-kubernetes-helm/tree/master/modules/k8s-service-account): Create a Kubernetes service account with options to bind the account to a set of RBAC roles.
    1. **[Application Service Helm Charts](https://github.com/gruntwork-io/helm-kubernetes-services/)**: Package your application services into a best practice Kubernetes deployment. The main charts are:
        1. [k8s-service](https://github.com/gruntwork-io/helm-kubernetes-services/blob/master/charts/k8s-service): Package your application service as a docker container and deploy to Kubernetes as a Deployment. Supports replication, rolling deployment, logging, configuration values, and secrets management.
    1. **[kubergrunt](https://github.com/gruntwork-io/kubergrunt)**: A command line tool that fills in the gaps between Terraform, Helm, and Kubectl for managing a Kubernetes Cluster. Includes support for configuring clients to access EKS via kubectl and deploying Tiller with automated TLS certificate management.


1. **[package-terraform-utilities](https://github.com/gruntwork-io/package-terraform-utilities)**: Useful Terraform utilities. The main modules are:
    1. [intermediate-variable](https://github.com/gruntwork-io/package-terraform-utilities/tree/master/modules/intermediate-variable): A way to define intermediate variables in Terraform.
    1. [join-path](https://github.com/gruntwork-io/package-terraform-utilities/tree/master/modules/join-path): Join a list of given path parts (that is, file and folder names) into a single path with the appropriate path separator (backslash or forward slash) for the current operating system.
    1. [operating-system](https://github.com/gruntwork-io/package-terraform-utilities/tree/master/modules/operating-system): Figure out what operating system is being used to run Terraform from inside your Terraform code.
    1. [require-executable](https://github.com/gruntwork-io/package-terraform-utilities/tree/master/modules/require-executable): Verify an executable exists on the host system, and emit a friendly error message if it does not.
    1. [run-pex-as-data-source](https://github.com/gruntwork-io/package-terraform-utilities/tree/master/modules/run-pex-as-data-source): Run a python script with dependencies packaged together as an external data source in a portable way.
    1. [run-pex-as-resource](https://github.com/gruntwork-io/package-terraform-utilities/tree/master/modules/run-pex-as-resource): Run a python script with dependencies packaged together as a local-exec provisioner on a null resource in a portable way.

1. **[gruntwork](https://github.com/gruntwork-io/gruntwork)**: A CLI tool to perform Gruntwork tasks, such as bootstrapping your GitHub and AWS accounts for the Reference Architecture.

##### Open Source GCP

Our open source modules that support deploying and managing production grade infrastructure on the Google Cloud Platform (GCP).

1. **[Network Topology](https://github.com/gruntwork-io/terraform-google-network/)**: Create best-practices Virtual
   Private Clouds (VPC) on GCP.
    1. [vpc-network](https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network): Launch a
       secure VPC network on GCP. Supports "access tiers", a pair of subnetwork and network tags. By defining an
       appropriate subnetwork and tag for an instance, you'll ensure that traffic to and from the instance is properly
       restricted.
    1. [network-peering](https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/network-peering):
       Configure peering connections between your networks, allowing you to limit access between environments and reduce
       the risk of production workloads being compromised.
    1. [network-firewall](https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/network-firewall):
       Configures the firewall rules expected by the `vpc-network` module.

1. **[Relational Databases](https://github.com/gruntwork-io/terraform-google-sql)**: Deploy and manage production grade
   relational databasessuch as MySQL and PostgreSQL on GCP using Cloud SQL.
    1. [cloud-sql](https://github.com/gruntwork-io/terraform-google-sql/tree/master/modules/cloud-sql): Deploy a Cloud
       SQL MySQL or PostgreSQL database. Supports automated backups, private and public access, autoresizing of disks,
       TLS, HA, and read replicas.

1. **[Kubernetes Docker Cluster](https://github.com/gruntwork-io/terraform-google-gke)**: Deploy and manage a production
   grade Kubernetes cluster on GCP using Google Kubernetes Engine (GKE).
    1. [gke-cluster](https://github.com/gruntwork-io/terraform-google-gke/tree/master/modules/gke-cluster): Deploy a
       GKE cluster to run a managed Kubernetes Control Plane. Supports autoscaling, StackDriver monitoring, private and
       public access.
    1. [gke-service-account](https://github.com/gruntwork-io/terraform-google-gke/tree/master/modules/gke-service-account):
       Configure a GCP Service Account that can be used with a GKE cluster. This can be used to allow applications
       `Pods` running on your GKE workers to access other GCP services.

1. **[Load Balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/)**: Run a highly-available and
   scalable network load balancer on GCP using Google Cloud Load Balancing.
    1. [http-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/http-load-balancer):
       Deploy an HTTP(S) Cloud Load Balancer using global forwarding rules. Supports balancing HTTP and HTTPS traffic
       across multiple backend instances, across multiple regions.

1. **[Static Assets](https://github.com/gruntwork-io/terraform-google-static-assets/)**: Deploy and serve static assets
   (CSS, JS, images) on GCP using Google Cloud Storage.
    1. [cloud-storage-static-website](https://github.com/gruntwork-io/terraform-google-static-assets/tree/master/modules/cloud-storage-static-website):
       Deploy a GCS bucket to host static content as a website. Supports assigning a custom domain to host the content
       under.
    1. [http-load-balancer-website](https://github.com/gruntwork-io/terraform-google-static-assets/tree/master/modules/http-load-balancer-website):
       Deploy a GCS bucket to host static content and serve using Google Cloud Load Balancing. Supports configuring
       SSL/TLS with a custom domain name.

1. **[Consul](https://github.com/hashicorp/terraform-google-consul)**: Deploy and manage a Consul cluster on GCP. The main modules are:
    1. [install-consul](https://github.com/hashicorp/terraform-google-consul/tree/master/modules/install-consul): Install Consul and its dependencies on a Linux server.
    1. [install-dnsmasq](https://github.com/hashicorp/terraform-google-consul/tree/master/modules/install-dnsmasq): Install dnsmasq on a Linux server and configure it to work with Consul as a DNS server. This allows you to use domain names such as my-app.service.consul.
    1. [run-consul](https://github.com/hashicorp/terraform-google-consul/tree/master/modules/run-consul): Run Consul and automatically bootstrap the cluster.
    1. [consul-cluster](https://github.com/hashicorp/terraform-google-consul/tree/master/modules/consul-cluster): Deploy a Consul cluster on GCP using a Managed Instance Group.

1. **[Nomad](https://github.com/hashicorp/terraform-google-nomad)**: Deploy and manage a Nomad cluster on GCP. The main modules are:
    1. [install-nomad](https://github.com/hashicorp/terraform-google-nomad/tree/master/modules/install-nomad): Install Nomad and its dependencies on a Linux server.
    1. [run-nomad](https://github.com/hashicorp/terraform-google-nomad/run-nomad): Run Nomad and automatically connect to a Consul cluster.
    1. [nomad-cluster](https://github.com/hashicorp/terraform-google-nomad/tree/master/modules/nomad-cluster): Deploy a Nomad cluster on GCP using a Managed Instance Group.

1. **[Vault](https://github.com/hashicorp/terraform-google-vault)**: Deploy and manage a Vault cluster on GCP. The main modules are:
    1. [install-vault](https://github.com/hashicorp/terraform-google-vault/tree/master/modules/install-vault): Install Vault and its dependencies on a Linux server.
    1. [run-vault](https://github.com/hashicorp/terraform-google-vault/tree/master/modules/run-vault): Run Vault and automatically connect to a Consul cluster.
    1. [private-tls-cert](https://github.com/hashicorp/terraform-google-vault/tree/master/modules/private-tls-cert): Generate self-signed TLS certificates for use with Vault.
    1. [vault-cluster](https://github.com/hashicorp/terraform-google-vault/tree/master/modules/vault-cluster): Deploy a Vault cluster on GCP using a Managed Instance Group.



### Reference Architecture

The Gruntwork Reference Architecture is a best-practices way to combine all of Gruntwork's Infrastructure Packages into an end-to-end tech stack that contains just about all the infrastructure a company needs, including Docker clusters, databases, caches, load balancers, VPCs, CI servers, VPN servers, monitoring systems, log aggregation, alerting, secrets management, and so on. We build this all using infrastructure as code and immutable infrastructure principles, give you 100% of the code, and can get it deployed in minutes.

You can view the Reference Architecture for a fictional company, Acme, in one of two flavors:

1. [Single-account reference architecture](#single-account-reference-architecture)
1. [Multi-account reference architecture](#multi-account-reference-architecture)

#### Single-account reference architecture

In a single account setup, all environments (e.g., stage, prod, etc) are deployed in a single AWS account, albeit, in separate VPCs. This gives you ease-of-use and convenience, but not as much isolation/security.

1. [infrastratructure-modules](https://github.com/gruntwork-io/infrastructure-modules-acme): The reusable modules that define the infrastructure for the entire company.
1. [infrastratructure-live](https://github.com/gruntwork-io/infrastructure-live-acme): Use the modules in infrastructure-modules to deploy all of the live environments for the company.
1. [sample-app-frontend](https://github.com/gruntwork-io/sample-app-frontend-acme): A sample app that demonstrates best practices for an individual Docker-based frontend app or microservice that talks to backend apps (showing how to do service discovery) and returns HTML. This app is written in NodeJS but these practices are broadly applicable (and in the case of Docker, reusable!) across any technology platform.
1. [sample-app-backend](https://github.com/gruntwork-io/sample-app-backend-acme): A sample app that demonstrates best practices for an individual Docker-based backend app or microservice that talks to a database. This app is written in NodeJS but these practices are broadly applicable (and in the case of Docker, reusable!) across any technology platform.

#### Multi-account reference architecture

In a multi-account setup, each environment (e.g., stage, prod, etc) is deployed into a separate AWS account, and in its own VPC within that account. All IAM users are defined in yet another AWS account called security, and you can assume IAM roles to switch between accounts. This gives you much more fine-grained control over security, and complete isolation between accounts, but there it's less convenient to use, as you have to keep switching between accounts.

1. [infrastratructure-modules](https://github.com/gruntwork-io/infrastructure-modules-multi-account-acme): The reusable modules that define the infrastructure for the entire company.
1. [infrastratructure-live](https://github.com/gruntwork-io/infrastructure-live-multi-account-acme): Use the modules in infrastructure-modules to deploy all of the live environments for the company.
1. [sample-app-frontend](https://github.com/gruntwork-io/sample-app-frontend-multi-account-acme): A sample app that demonstrates best practices for an individual Docker-based frontend app or microservice that talks to backend apps (showing how to do service discovery) and returns HTML. This app is written in NodeJS but these practices are broadly applicable (and in the case of Docker, reusable!) across any technology platform.
1. [sample-app-backend](https://github.com/gruntwork-io/sample-app-backend-multi-account-acme): A sample app that demonstrates best practices for an individual Docker-based backend app or microservice that talks to a database. This app is written in NodeJS but these practices are broadly applicable (and in the case of Docker, reusable!) across any technology platform.


### Gruntwork Open Source Tools

1. [terragrunt](https://github.com/gruntwork-io/terragrunt): A thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules.

1. [terratest](https://github.com/gruntwork-io/terratest): The swiss army knife of testing Terraform modules. This is a library written in Go that we use to test all of the code above. It contains a collection of useful utilities: e.g., apply and destroy Terraform code, SSH to servers and run commands, test HTTP endpoints, fetch data from AWS, build AMIs using Packer, run Docker builds, and so on.

1. [fetch](https://github.com/gruntwork-io/fetch): A tool that makes it easy to download files, folders, and release assets from a specific git commit, branch, or tag of public and private GitHub repos.

1. [gruntwork-installer](https://github.com/gruntwork-io/gruntwork-installer): A script to make it easy to install Gruntwork Modules.

1. [bash-commons](https://github.com/gruntwork-io/bash-commons): A collection of reusable Bash functions for handling common tasks such as logging, assertions, string manipulation, and more.

1. [pre-commit hooks](https://github.com/gruntwork-io/pre-commit): A collection of pre-commit hooks for Terraform, bash, Go, and more.

1. [cloud-nuke](https://github.com/gruntwork-io/cloud-nuke): A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it.

### Gruntwork Training Reference Materials

1. [Gruntwork DevOps Training Library](https://gruntwork.io/training/): A collection of training video courses that teach you DevOps.

1. [A Comprehensive Guide to Terraform](https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca): Our blog post series on how to use Terraform that covers how Terraform compares to Chef, Puppet, Ansible, and CloudFormation, introduces Terraform syntax, discuss how to manage Terraform state, shows how to build reusable infrastructure with Terraform modules, and introduces a workflow for how to use Terraform as a team.

1. [A Comprehensive Guide to Building a Scalable Web App on Amazon Web Services](https://www.airpair.com/aws/posts/building-a-scalable-web-app-on-amazon-web-services-p1): A definitive guide on how to think about building apps on AWS, including how to think about scalability and high availability, an overview of how to use the most important AWS services, and an introduction to cloud-native architecture.

1. [A Comprehensive Guide to Authenticating to AWS on the Command Line](https://blog.gruntwork.io/a-comprehensive-guide-to-authenticating-to-aws-on-the-command-line-63656a686799): Our blog post series on how to authenticate to AWS on the command-line, including how to use Access Keys, IAM Roles, MFA, the Credentials File, Environment Variables, Instance Metadata, and Gruntwork Houston.

1. [Lessons Learned From Writing Over 300,000 Lines of Infrastructure Code](https://blog.gruntwork.io/5-lessons-learned-from-writing-over-300-000-lines-of-infrastructure-code-36ba7fadeac1): A concise masterclass on how to write infrastructure code.

1. [Reusable, composable, battle-tested Terraform modules](https://blog.gruntwork.io/reusable-composable-battle-tested-terraform-modules-9c2fb53bc034): A talk that will change how you deploy and manage infrastructure.

1. [Gruntwork Production Readiness Checklist](https://gruntwork.io/devops-checklist/): Are you ready to go to prod on AWS? Use this checklist to find out.

1. [Terraform: Up & Running](https://www.terraformupandrunning.com/): This book is the fastest way to get up and running with Terraform, an open source tool that allows you to define your infrastructure as code and to deploy and manage that infrastructure across a variety of public cloud providers (e.g., AWS, Azure, Google Cloud, DigitalOcean) and private cloud and virtualization platforms (e.g. OpenStack, VMWare).

1. [infrastructure-as-code-training](https://github.com/gruntwork-io/infrastructure-as-code-training): A sample repo we share with customers when we do training on Terraform, Docker, Packer, AWS, etc.


### Operating system compatibility

Here's a summary of the operating systems supported by Gruntwork as of January, 2019:

* **Modules vs dev tools**: Just about all of our _modules_ for running various types of infrastructure—e.g., Kafka, ZooKeeper, ELK, MongoDB, OpenVPN, Jenkins, etc—assume they are being deployed on Linux servers. In practice, this means that all the `install-xxx` and `run-xxx` scripts (e.g., install-kafka, run-kafka) are written in Bash and don't work on Windows. However, our _dev tools_—the tools that we expect developers to run on their own computer to interact with the infrastructure—are often portable and work on most major operating systems. 

* **The basic dev tools**: The basic dev tools we use are Terraform, Packer, and Docker, all of which should work on all major operating systems.

* **Terraform modules**: Just about all the modules we write in Terraform work on all major operating systems. However, there are a few places where we were forced to call out to scripts from our Terraform code. Most of these scripts are Python and work on all major operating systems, but there are a couple places where we lazily call Bash code (mostly `sleep 30` to work around Terraform bugs). If you run into a portability issue, please report it as a bug, and we'll get it fixed!

* **Go**: We've written a number of dev tools in Go, which we compile into standalone binaries that should work on every major operating system. This applies to: 
    - Terragrunt
    - Terratest
    - OpenVPN: `openvpn-admin`
    - Houston: `houston` CLI
    - Security: `gruntkms`, `ssh-grunt`
    - cloud-nuke
    - API Gateway and SAM: `gruntsam`
    - Kubernetes / EKS: `kubergrunt`

* **Python**: We have some dev tools that we wrote in Python. Most of these work on all major operating systems, but there are occasional gotchas with Windows path length limits, and some Python 2 vs 3 issues. This applies to:
    - AMI cluster: The `asg-rolling-deploy` and `server-group` Terraform modules call out to Python scripts.
    - Docker cluster: `roll-out-ecs-cluster-update.py`

* **Bash**: We have a small number of dev tools that we wrote in Bash. These will work on Linux and Mac, but not on Windows (unless you use Cygwin or the new Windows 10 Bash Shell, but even then, portability isn't guaranteed). This applies to:
    - Gruntwork Installer
    - CI / CD: `aws-helpers`, `build-helpers`, `check-url`, `circleci-helpers`, `git-helpers`, `terraform-helpers`
    - Stateful server: `attach-eni`, `mount-ebs-volume`, `add-dns-a-record`
    - Security: `aws-auth`
    - Docker cluster: `ecs-deploy`

* **Tests**: It's worth noting all of our tests currently run on Linux, which means Windows-specific bugs do slip through periodically. 

* **Need Windows support?** The vast majority of our customers use Linux or Mac, so we haven't prioritized improving our Windows support. If you would like us to improve our Windows support, we would be happy to discuss a project to do so as part of our [Custom Module Development](https://gruntwork.io/custom-module-development/) process.


### How to use the code

There's a lot of great code here, but how do you use it in your own infracture and apps? There are two options:

1. [Reference it from the Gruntwork repos](#reference-it-from-the-gruntwork-repos) (recommended)
1. [Fork the code to your own repos](#fork-the-code-to-your-own-repos)

Note, you must be a [Gruntwork Subscriber](https://www.gruntwork.io/pricing/) to use either of these options!

#### Reference it from the Gruntwork repos

The approach we recommend is to reference the code directly from the Gruntwork repos.

**For Terraform code**, you can use a Gruntwork module by referencing the Git URL in the `source` parameter. For example, to use our [VPC module](https://github.com/gruntwork-io/module-vpc) in your code:

```hcl
# Create a VPC using the Gruntwork VPC module
module "vpc_app" {
  source = "git::git@github.com:gruntwork-io/module-vpc.git//modules/vpc-app?ref=v0.5.5"

  vpc_name         = "prod"
  aws_region       = "us-east-1"
  cidr_block       = "10.0.0.0/18"
  num_nat_gateways = 3
}
```

A few things to note about the `source` URL above:

1. **Versioned URL** (note the `ref=v0.5.5`): This gives you a known, fixed version of each module, with consistent and reproducible behavior. We use [semantic versioning](https://semver.org/)  for our code and publish release notes for each release so you know how to upgrade and if there were any backward incompatible changes. If you want to upgrade to new infrastructure, just bump the version number and run `terraform apply`!

1. **SSH for authentication**: If you [associate an SSH key with your GitHub account](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account) and use [ssh-agent](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent), you will not be prompted for any passwords. You can use a similar approach with your machine users in CI / CD environments.

**For binaries and scripts**, you can use the [gruntwork-installer](https://github.com/gruntwork-io/gruntwork-installer) with the `--repo` parameter pointing to Gruntwork repos. For example, to install the [ssh-grunt binary](https://github.com/gruntwork-io/module-security/tree/master/modules/ssh-grunt) (which lets you manage SSH access using an Identity Provider such as IAM, Google, ADFS, etc) on your EC2 Instances:

```bash
gruntwork-install --binary-name 'gruntkms' --repo https://github.com/gruntwork-io/gruntkms --tag 'v0.0.8'
```

A few notes about the `gruntwork-install` call above:

1. **Versioned URL** (note the `--tag 'v0.0.8'`): This gives you a known, fixed version of each script and binary, with consistent and reproducible behavior. If you want to upgrade to a new binary or script, just bump the version number and re-run!
1. **GitHub  authentication**: We use a [GitHub personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) to authenticate. You set your token as the environment variable `GITHUB_OAUTH_TOKEN`.
1. **Pre-compiled binaries**: The example above installs a pre-compiled binary for your operating system. `gruntkms` is one of the many tools we write in Go and compile as standalone binaries for different operating systems.
1. **Windows users**: `gruntwork-install` is a Bash script, which should work fine on Linux and OS X, but might be tricky to use with Windows. In those cases, you'll want to download the binaries you depend on manually.


#### Fork the code to your own repos

Some companies do not allow dependencies on external repos and require that everything is pulled from an internal source (e.g., GitHub Enterprise, BitBucket, etc). In that case, the [Gruntwork License](https://gruntwork.io/terms/) gives you permissions to fork our code into your own repos.

Here's what you would need to do:

1. Copy each Gruntwork repo into your private repositories.
1. You'll also want to copy all the versioned releases (see the `/releases` page for each repo).
1. For repos that contain pre-built binaries (such as `ssh-grunt` mentioned earlier), you'll want to copy those binaries into the releases as well.
1. Within each repo, search for any cross-references to other Gruntwork repos. Most of our repos are standalone, but some of the Terraform and Go code is shared across repos (e.g., our `package-kafka` and `package-zookeeper` repos use `module-asg` under the hood to run an Auto Scaling Group). You'll need to update Terraform `source` URLs and Go `import` statements from `github.com/gruntwork-io` to your private Git repo URLs.
1. You'll want to automate the entire process and run it on a regular schedule (e.g., daily). Our repos are updated continuously, both by the Gruntwork team and contributions from our community fo customers (see [our monthly newsletter](https://blog.gruntwork.io/tagged/gruntwork-newsletter) for details), so you'll want to pull in these updates as quickly as you can.

Once you've done all the above, you can now use the modules, scripts, and binaries in your code using the same techniques as mentioned earlier (Terraform `module` with `source` URL and `gruntwork-install` with the `--repo` param).

While this approach works, it obviously has some downsides:

1. You have to do a lot of work up-front to copy the  repos, releases, and pre-compiled binaries and update internal links.
1. You have to do more work to run this process on a regular basis and deal with merging conflicts.
1. If your team isn't directly using the Gruntwork GitHub repos on a regular basis, then you're less likely to participate in issues and pull requests, and you won't be benefitting as much from the Gruntwork community.

So, whenever possible, use option #1, referencing Gruntwork repos directly. If your team relies on NPM, Docker Hub, Maven Central, or the Terraform Registry, this is no different! However, if your company completely bans all outside sources, then follow the instructions above to fork our code.
