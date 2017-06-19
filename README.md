# A Table of Contents for All Gruntwork Code

### Terminology

**Infrastructure Package:** A reusable, tested, documented, configurable, best-practices definition of a single 
piece of Infrastructure written using a combination of Terraform, Go, and Bash.

**Module:** A well-defined, narrowly scoped implementation of a specific feature that is a component of executing the
overall vision of a particular Infrastructure Package. Modules may be Terraform code, Packer templates, Go, bash, or some
combination. Note that a Gruntwork Infrastructure Package contains one or more modules.

### Infrastructure Packages

Gruntwork Infrastructure Packages are spread across multiple GitHub repos. This repo lists all of them:

1. [Network Topology](https://github.com/gruntwork-io/module-vpc)
1. [Monitoring and Alerting](https://github.com/gruntwork-io/module-aws-monitoring)
1. [Docker Cluster](https://github.com/gruntwork-io/module-ecs)
1. [AMI Cluster](https://github.com/gruntwork-io/module-asg)
1. [Lambda](https://github.com/gruntwork-io/package-lambda)
1. [Security](https://github.com/gruntwork-io/module-security)
   - The Security Package also includes access to [GruntKMS](https://github.com/gruntwork-io/gruntkms)
1. [Continuous Delivery](https://github.com/gruntwork-io/module-ci)
1. [Relational Database](https://github.com/gruntwork-io/module-data-storage)
1. [Distributed Cache](https://github.com/gruntwork-io/module-cache)
1. [Stateful Server](https://github.com/gruntwork-io/module-server)
1. [Static Assets](https://github.com/gruntwork-io/package-static-assets)
1. [MongoDB Cluster](https://github.com/gruntwork-io/package-mongodb)
1. [OpenVPN Server](https://github.com/gruntwork-io/package-openvpn)

### Open Source Infrastructure Packages

In the near future, we will be releasing open source Infrastructure Packages that configure best-practices implementations
of [HashiCorp Consul](https://www.consul.io/), [Nomad](https://www.nomadproject.io/), and [Vault](https://www.vaultproject.io/).

### Gruntwork Open Source Tools

1. [terragrunt](https://github.com/gruntwork-io/terragrunt)
1. [fetch](https://github.com/gruntwork-io/fetch)
1. [gruntwork-installer](https://github.com/gruntwork-io/gruntwork-installer)

### Gruntwork Training Reference Materials

1. [infrastructure-as-code-training](https://github.com/gruntwork-io/infrastructure-as-code-training)

### Reference Implementation of Gruntwork Packages

We setup all customers' infrastructure according to a standardized set of best practices that has been proven out over
multiple customer implementations and that is designed to minimize the amount of pain required to maintain the code.

You can view reference implementations of our approach for a fictional customer, Acme, at the following repos, but please
note that, as of June 19, 2017, we have not yet committed to actively keeping these up to date:

1. [infrastratructure-live](https://github.com/gruntwork-io/infrastructure-live-acme): A representation in code of your 
   entire AWS configuration
1. [infrastratructure-modules](https://github.com/gruntwork-io/infrastructure-modules-acme): A collection of mostly 
   Terraform modules opinionated to the needs of Acme corporation.
1. [sample-app](https://github.com/gruntwork-io/sample-app-acme): A sample app that demonstrates best practices for an
   individual Docker-based app or microservice. This app is written in NodeJS but these practices are broadly applicable
   (and in the case of Docker, reusable!) across any technology platform.