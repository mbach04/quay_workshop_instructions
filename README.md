# quay_workshop_instructions
Getting started with Quay Workshop

This workshop will guide students through the various features of Quay version 3.x. It's applicable to anyone who wishes to get hands on managing container images with Quay.

Your instructor should assign you a user number. Several of the lab exercises in this workshop will require you to insert your user number to perform an operation. For example, the lab guide may ask you to enter your username and state `userX` as the example. If you are user number `1`, you would change this value to `user1` instead of `userX`.

## Student labs outline
[Lab 1 - Organizations and Repositories](https://github.com/mbach04/quay_workshop_instructions/blob/master/lab1.md)

[Lab 2 - Repo mirroring](https://github.com/mbach04/quay_workshop_instructions/blob/master/lab3.md)

[Lab 3 - Inspecting image layers and CVE's](https://github.com/mbach04/quay_workshop_instructions/blob/master/lab4.md)

[Lab 4 - Notifications](https://github.com/mbach04/quay_workshop_instructions/blob/master/lab5.md)

[Lab 5 - Getting images into Quay](https://github.com/mbach04/quay_workshop_instructions/blob/master/lab6.md)

TODO: enc password stuff
___

## Instructor Notes
This workshop can be run on any OpenShift 4.x cluster with Quay 3.x deployed. It can also be done on a Quay instance deployed in HA on virtual machines, although the preferred architecture is Quay on OCP 4.x. You can deploy on top of a vanilla OCP 4.x cluster in RHPDS using the DevSecOps Workshop Deployer found here: [openshift-devsecops](https://github.com/jharmison-redhat/openshift-devsecops).

In order to complete all labs of this workshop, ensure your Quay instance has repo-mirroring enabled. If deploying using the [openshift-devsecops](https://github.com/jharmison-redhat/openshift-devsecops) repo, you'll need to set `enable_quay_repo_mirroring: yes` in the `devsecops.yml` variable file. Repo-mirroring requires a `rwx` storage provider as well.

Optionally, students will need a means to push / pull container images in order to complete the lab "Getting images into Quay". This can be done by hosting a RHEL8 instance and allowing students to SSH in. Or, if using the openshift-devsecops workshop deployer, you can use the butterfly project to give students a browser based SSH terminal, thus reducing student workstation requirements to Chrome or Firefox.