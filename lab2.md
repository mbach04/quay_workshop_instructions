# Repo Mirroring
In this lab, we'll create a repository that automatically mirrors images located somewhere else. Quay can mirror images from any container registry it can reach and has appropriate credentials to. This is useful in a number of scenarios:
* caching local copies of baselayer images to reduce network traffic on your WAN link
* making a subset of images available to your developer team to choose from (discouraging grabbing random images from the internet)
* As part of an image building or scanning pipeline
* Establishing read only image namespaces

For our example, we'll make a mirror of an older Centos7 image that we can find CVE's in when using the Clair image scanner in later labs.

When a repository is set to be a mirror, you cannot `push` an image directly to this repo. Instead, Quay will reach out and `pull` from the location you've designated, and grab all tags specified in the repo mirror settings.

## Create a repo to mirror from
![Quay Dashboard](/images/lab1-3.png)

* Click `Create New Repository` in the top right of the UI.

* Ensure `userXorg` is selected in the drop down list of Organizations.

* Name the organization `centos-mirror`.

* Change the `Repository Visibility` to `Public`.

* Optionally, set a repository description by clicking in and changing the default text that states `Click to set repository description`

* Click `Create Public Repository`

![Settings](/images/settings-icon.png)
* Click the `Settings` icon as shown above
* Under the `Repository State` section, change the repo state in the dropdown to `Mirror`. 

![Mirroring](/images/lab2-1.png)
* Click the `Mirroring` icon as shown above
* You should now see the `Repository Mirroring` configuration page.
* Beside the `Robot User` field, select the down arrow and click `Create robot accounts`. We'll need this to enable mirroring even if the remote registry does not require auth (ie docker.io).
* Fill out the corresponding sections with the values provided below:
| Field  | Value  |
|---|---|
| Provide a name for your new robot account  | `userXrobot`  |
| Provide an optional description for your new robot account:  | `centos mirror bot`  |
* Click `Create robot account`
![Mirroring](/images/create-robot-account.png)

* Fill out the corresponding sections with the values provided below:

| Field  | Value  |
|---|---|
| Registry Location  | docker.io/library/centos  |
| Tags  | 7.7.1908  |
| Start Date  | (set to today / now)  |
| Sync Interval  | 1 minutes  |
| Verify TLS  | (checked)  |





* Navigate back to the dashboard by clicking the `RED HAT QUAY` icon in the top left of the page.
* Notice you now have two organizations, `userX` and `userXorg`. Your `userXorg` organization contains one repository named `test`.



## Next Lab:
[Previous](https://github.com/mbach04/quay_workshop_instructions/blob/master/lab1.md) | [Next](https://github.com/mbach04/quay_workshop_instructions/blob/master/lab3.md)

