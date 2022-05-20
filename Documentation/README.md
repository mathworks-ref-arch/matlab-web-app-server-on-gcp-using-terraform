## Setting up *MATLAB Web App Server&reg; on Google Cloud Platform&trade; using Terraform&reg;*

### About MATLAB Web App Server:

MATLAB Web App Server™ lets you host MATLAB® apps and Simulink® simulations as interactive web apps. You can create apps using App Designer, package them using MATLAB Compiler™, and host them using MATLAB Web App Server. Your end-users can access and run the web apps using a browser without installing additional software. You can host and share multiple apps developed using different releases of MATLAB and Simulink.
To learn more about MATLAB Web App Server, please visit the [documentation](https://www.mathworks.com/products/matlab-web-app-server.html).

This reference architecture helps in automating the process of **setting up MATLAB Web App on Google cloud Platform using sample Terraform configuration.**

### About Terraform and Google Platform Provider:

[Terraform](https://www.terraform.io/intro/index.html) is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. This includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc. Terraform can manage both existing service providers and custom in-house solutions.

Terraform [Google Cloud Platform Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) is used to configure your Google Cloud Platform infrastructure with Terraform config files. See the [provider reference](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference) for more details on authentication or otherwise configuring the provider. 

The Google provider is jointly maintained by:

* The [Terraform Team](https://cloud.google.com/docs/terraform) at Google
* The Terraform team at [HashiCorp](https://www.hashicorp.com/?_ga=2.206188627.1519458328.1628777034-999678800.1614365084)

For more details on Releases, Feature and Bug Requests, please visit this [page](https://registry.terraform.io/providers/hashicorp/google/latest/docs).

These documents are an introductory guide to using the **reference architecture**:

### Contents:

* [Installation](Installation.md)
* [Authentication](Authentication.md)
* [Getting Started Example](Example.md)
* [Deploying a MATLAB webapp using MATLAB Web App Server](DeployWebApp.md)
* [References](References.md)

[//]: #  (Copyright 2022 The MathWorks, Inc.)
