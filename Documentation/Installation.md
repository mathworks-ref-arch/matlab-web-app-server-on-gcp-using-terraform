## Installation

### Cloning this repository

Clone this repository as follows:
```
>> git clone https://github.com/mathworks-ref-arch/matlab-web-app-server-on-gcp-using-terraform.git
```

### Setting up a License manager on Google :

 Make sure you have an existing Network License Manager setup on Google Cloud as well. See instructions on setting up a Network License Manager on Google Cloud [here](https://github.com/mathworks-ref-arch/license-manager-for-matlab-on-gcp-using-terraform.git).


### Installing Google Cloud SDK:

Install [Google Cloud SDK](https://cloud.google.com/sdk/docs/install). This step will ensure you are able to run `gcloud` and `gsutil` commands from the system provisioning Google Cloud resources. Perform gcloud authentication using command `gcloud auth login`. This will authorize the gcloud API to access the Cloud Platform with your Google user credentials.

### Installing Terraform:

[Install Terraform](https://www.terraform.io/upgrade-guides/1-0.html) v1.0 for Linux.

### Create SSH keys for managing Google Compute resources:

Terraform configuration uses some startup scripts for initialization of VMs. To authenticate Terraform requires `metadata-based SSH key configurations`. **Create a set of SSH keys** if one does not exist. See this [link](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys#createsshkeys) for steps. Provide the location of this key within `variables.tf` for both Build and Deploy stage as follows.
```
# Path to ssh key for gcloud login and authorization
variable "gce_ssh_key_file_path" {
  type = string
  description = "/home/local-gce-user/.ssh/google_compute_engine.pub"
  default = "/home/matlabuser/.ssh/google_compute_engine.pub"
}
```

### Selecting MATLAB runtime versions:

Select MATLAB Runtime versions you would like to support. A MATLAB Web App Server version can support up to R2020a. [See more details here for version support](https://www.mathworks.com/help/mps/qs/download-and-install-the-matlab-compiler-runtime-mcr.html). 

Add the MATLAB Runtime versions you would like to support within [variables.tf](../Software/variables.tf) as follows:
  
  ```
  variable "MCR_url" {
  type    = map
  default = {
v98  = "https://ssd.mathworks.com/supportfiles/downloads/R2020a/Release/7/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2020a_Update_7_glnxa64.zip"
 v99  = "https://ssd.mathworks.com/supportfiles/downloads/R2020b/Release/7/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2020b_Update_7_glnxa64.zip"
v910 = "https://ssd.mathworks.com/supportfiles/downloads/R2021a/Release/6/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2021a_Update_6_glnxa64.zip"
v911 = "https://ssd.mathworks.com/supportfiles/downloads/R2021b/Release/3/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2021b_Update_3_glnxa64.zip"
v912 = "https://ssd.mathworks.com/supportfiles/downloads/R2022a/Release/1/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2022a_Update_1_glnxa64.zip"
    } 
  }
   ```

### Downloading MATLAB runtime before running config:

In order to save time, one can optionally download the required MATLAB runtime versions for Linux under the directory [Software/runtimes](../Software/runtimes/).

This is an example runtime folder listing runtime installers downloaded from the [web](https://www.mathworks.com/products/compiler/matlab-runtime.html).:

```
>> ls ../Software/runtimes

drwxr-xr-x+ 2 matlab users 7 Aug  9 19:47 .
drwxr-xr-x+ 7 matlab users 20 Aug 12 14:57 ..

-rw-r--r--+ 1 matlab users 3983156089 Jul  8 14:53 MATLAB_Runtime_v910_glnxa64.zip

-rw-r--r--+ 1 matlab users 2809289440 Dec  1  2020 MATLAB_Runtime_v911_glnxa64.zip

-rw-r--r--+ 1 matlab users 3132892992 Feb  9  2021 MATLAB_Runtime_v912_glnxa64.zip

```

### Downloading the MATLAB ISO of required version:

In order to access the ISO image, follow the steps below:

* Go to https://www.mathworks.com/downloads/
* On this page, in the **I WANT TO:** drop-down select **Get ISOs and DMGs**.
* On the left side of the screen, select the release you want to download. You may need to click on show more to find the release you are looking for. Releases supported include `R2022a`, `R2021b`,`R2021a`.
* Select `Linux` as the operating system you wish to download the ISO for, click on the download button.

Configure [variables.tf](../Software/variables.tf) with the path to the ISO as shown below:

```
variable "ISO_Location" {
    type = string
    default = "/opt/Downloads"
    description = "Folder path where MATLAB ISO is located. ISO file should be renamed as VERSION.iso e.g. R2019b.iso or R2022a.iso"
}
```

[//]: #  (Copyright 2022 The MathWorks, Inc.)
