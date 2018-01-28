# Windows Customisation
*Note*: Currently incorporating all default profile and OS customisations into this script.

These scripts are called by Run-WindowsCustomisations.ps1 and implement configuration changes to an image such as the default profile, remove AppX apps etc.

## Windows Default Profile configuration
Configuring the Windows default profile for desktop deployments.

These scripts are for configuring settings in the default or current profile for use in Windows desktop (and RDSH) deployments. Setting the default profile is an important step in getting the default user experience right.

Most scripts will edit the default user profile directly so can be applied during any type of deployment.

If you want to include more detailed customisations in a reference image (that might include some manual configuration changes), ensure the script runs against the current profile and use the [CopyProfile](https://technet.microsoft.com/en-au/library/hh825135.aspx) method when running SysPrep.

For Windows 10 many settings and their corresponding registry locations can be found here: [https://www.tenforums.com/tutorials/](https://www.tenforums.com/tutorials/)
