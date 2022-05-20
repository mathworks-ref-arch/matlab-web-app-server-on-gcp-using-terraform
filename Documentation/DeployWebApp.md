## Deploying a MATLAB App on MATLAB Web App Server

This document briefly explains the required resources for deploying MATLAB appdesigner based apps into webapps using the MATLAB Web App Server instance deployed using this reference architecture.

To learn how to package a MATLAB app into a webapp and deploy using Web App Server, please refer to this [link](https://www.mathworks.com/help/compiler/web-apps.html).
### Required reference architecture output resources: 

Once the reference architecture has completed deploying `MATLAB Web App Server`, the following example `Terraform output` is made available:

```
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

waps-http-endpoint = "http://35.222.0.242:9988"
waps-node-hostname = "waps-22a-build-ubuntu20-1653056658-compute-for-waps"

```

The **waps-node-name** is the hostname of Google Cloud compute instances used for deployment and the **waps-http-endpoint** is the url for the webapp server dashboard.

![Web App Server Dashboard](Documentation/images/WebAppServerDashboard.PNG)


[//]: #  (Copyright 2022 The MathWorks, Inc.)
