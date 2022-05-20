## Sample Build and Deploy using Reference Architecture

The [example script](../Software/example.sh) is a sample scenario for deploying a MATLAB Web App Server instance on Google Cloud Platform.

The example has the following pre-requisites:
* User has access to an existing License Manager on Google Cloud Platform. If not, one can use [reference architecture for setting up License manager on Google Cloud](https://github.com/mathworks-ref-arch/license-manager-for-matlab-on-gcp-using-terraform) to set one up and get access to:
  * `License Manager hostname` or instance hostname.
  * `License Manager IP` (private should be sufficient if the plan is to use the same VPC.)
  * `VPC name` or ID for the License Manager.
  * `Subnet name` and  `CIDR range` for the License Manager.
    * You can either `use the same subnet` for MATLAB Web App Server, or
    * You can `use the information to select a different valid CIDR range` for deploying MATLAB production Server within the same VPC.
  * `License Manager port` open on the VPC firewall for accepting license checkout requests.
* Select a MATLAB Production Server version for deployment. Supported versions include R2022a, R2021b and R2021a.
* Select MATLAB Runtime versions you would like to support. [See more details here for version support](https://www.mathworks.com/help/mps/qs/download-and-install-the-matlab-compiler-runtime-mcr.html). 
* Add the MATLAB Runtime versions you would like to support within [variables.tf](../Software/variables.tf) as follows:
  
  ```
  variable "MCR_url" {
  type    = map
  default = {
  v912 = "https://ssd.mathworks.com/supportfiles/downloads/R2022a/Release/1/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2022a_Update_1_glnxa64.zip"
    } 
  }
   ```

* User has access to all `Prerequisites` and has followed the `Getting Started` steps listed within [README.md](../README.md).


The sample scenario in this example is as follows:

* OS: `Ubuntu20`
* Compute: `n2-standard-4`
* Existing Network License Manager on GCP : `true`
* Use existing VPC & Subnet : `true`
* MATLAB Web App Server Version : `R2022a`


### Variables :

```
# Path to service account credentials
credentials_file_path="/home/matlabuser/gcp/credentials.json"

# MATLAB Web App Server Version
Version="R2022a"
Agree_To_License="yes"

# File Installation Key for the licensed product
FIK="3xxx6-3xxx1-5xxx6-6xxx4"

# VM Operating system
BootDiskOS="ubuntu20"

# Existing License Manager and Network Details

LicenseManagerHost="10.128.0.2"
VPC_Network_Name="mlm-22a-ubuntu20-1627426546-licensemanager-network"

Subnet_Name="mlm-22a-ubuntu20-1627426546-licensemanager-subnetwork"

# Unique tag for naming resources
TS=$(date +%s) && \
WAPS_BUILD_TAG="waps-${Version:(-3)}-build-${BootDiskOS}-${TS}"
```

### Applying Terraform plan:

The above variables are just a subset of a much longer list that needs to be configured within `Software/variables.tf`. The above values will override the defaults set within variables.tf .

The next section applies the terraform plan for the Build Stage. If you encounter an error related to `unrecognized modules or plan`, initialize the Terraform modules by running the following command:
```
>> terraform init
>> terraform validate
```

At the completion of the build a `google compute instance` with a functional `MATLAB Web App Server`will be created.

```

# Apply Terraform configuration for building a google compute instance hosting MATLAB Web App Server & MATLAB Runtime.

terraform apply -auto-approve -var "credentials_file_path=${credentials_file_path}" \
-var "gce_ssh_key_file_path=${gce_ssh_key_file_path}" \
-var "app_project=${ProjectId}" \
-var "username=${Username}" \
-var "bootDiskOS=${BootDiskOS}" \
-var "LicenseManagerHost=${LicenseManagerHost}" \
-var "vpc_network_name=${VPC_Network_Name}" \
-var "subnet_name=${Subnet_Name}" \
-var "subnet_create=${build_subnet_create}" \
-var "subnet_ip_cidr_range=${build_subnet_ip_cidr_range}" \
-var "tag=${WAPS_BUILD_TAG}" \
-var "Version=${Version}" \
-var "Agree_To_License=${Agree_To_License}" \
-var "FIK=${FIK}" \
-var "ISO_Bucket_exists=${ISO_Bucket_exists}" \
-var "ISO_Object_URI=${ISO_Object_URI}"
```

### Verify build status before proceeding:

```
build_status=$?
printf "\n\n"
```
Proceed only if terraform apply has passed for the above with exit code 0. 

Terraform provides useful commands to manage the terraform state and manage resources created by Terraform config. The script uses some of the following commands:
```
* terraform state rm [Options]
* terraform import [Options]
* terraform destroy


```

### Destroy all resources in the terraform state

terraform destroy -auto-approve 


[//]: #  (Copyright 2022 The MathWorks, Inc.)
