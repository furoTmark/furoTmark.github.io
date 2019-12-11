---
layout: post
title: Creating a Wix Installer Patch from MSI
comments: true
tags: windows wix installer msi patch melt wxs msp
---

Creating patches for minor upgrades can be a real pain. The documentation for MsiMps.exe/PatchWiz.dll or WiX patching is missing a lot of detail and the error messages the tools give back are not enough. The responses and fixes are scattered on the internet or on the WiX mailing lists.

In this blog post I will try to explain, how to create a patch with the help of WiX, using the .msi package, the .wixpdb (both created by the WiX installer) and the Wix tools, provided when installing Wix. (found under the path _C:\Program Files (x86)\WiX Toolset < version >\bin_)

## Creating a Patch.wxs

To create a patch file, we need to make a new WiX file (patch.wxs) that will define the patch's characteristics. This file should be defined outside of the installer project or the solution.

```xml
<?xml version='1.0' encoding='UTF-8'?>
<Wix xmlns='http://schemas.microsoft.com/wix/2006/wi'>
  <Patch AllowRemoval="no"                                Manufacturer="Company"
         DisplayName="Title" Description="Update Patch" Classification="Update">

    <Media Id='5000' Cabinet='patch.cab'>
      <PatchBaseline Id='patch'/>
    </Media>

    <PatchFamily Id='PatchFamily' Version='1.0' Supersede='yes' />
  </Patch>
</Wix>
```

#### Important Properties

* **AllowRemoval** - if the patch can be removed without uninstalling the application
* **Classification** - the category of the patch. Ex. Critical Update, Hotfix, Security Rollup, Security Update, Service Pack, Update, Update Rollup.
* **Media** - it is important to set the Id higher then the id from the MSI.
* **Cabinet** - can have any name as you like
* **PatchBaseline** - used to define a name that we can reference later as we're building the patch file, can be the same as the CAB file.
* **PatchFamily** - contains the updates of your patch
* **Version** - this version attribute no relation to the target product's ProductVersion. It is the version of the Patch.
* **Supersede** - patch should or shouldn't override other earlier patches

**Note:** The PatchFamily element can have children elements (ex. ComponentRef), it is helpful to set these if, the patch should look for changes in a set of files.

In your installer .wxs file, it is important that it has some properties properly set.

```xml
<Product
  Id="DE64C7F1-3B6F-426E-AC83-83BAC7F71AC2"
  Name="Software Name"
  Language="1033"
  Version="1.0.0.0"
  Manufacturer="Company Name"
  UpgradeCode="553CBD3D-3B0B-479C-888E-9E9F72A093B9">
```

* **Product Id** - This id can be set also to *, small upgrades can have the same Id, major upgrades should have different Id
* **Version** - Should be set and should be updated when creating a newer version. Patch checks the version to decide if patch should be applied.
* **UpgradeCode** - based on this property is decided that the Software is in the same family. This property should be the same for each installer msi.

#### The Problem with the .wixpdb

When you create an MSI installer file with the help of WiX, it creates also a .wixpdb file.  This file contains the paths to the source files. The problem is that you always need the original source files in order to create a patch and the source files paths should remain the same as in the .wixpdb file. If this file is moved, the paths become invalid. This can occour in many cases, when the releases are created on a server or by a process and the output is only the .msi and the .wixpdb files.

#### WiX Melt Tool

The WiX Melt tool is not very well documented and its purpose is not to create patches. The WiX documentation says _'Converts an .msm into a component group in a WiX source file'._

A lesser known functionality of Melt is to input the WiX created .msi file and the .wixpdb file and get as the output a directory where the .msi contents are extracted and a new .wixpdb is created that is updated to point to the newly extracted files. Fixing the issue of the references to the original source files and extracting the source files from the .msi to help the patch creation process.

#### Steps to create a patch

#### 0. Prerequisites  

OldInstaller.msi  
OldInstaller.wixpdb  
NewInstaller.msi  
NewInstaller.wixpdb

#### 1. Correct the .wixpdb with the help of Melt

```cmd
Melt.exe OldInstaller.msi -out old\OldInstallerCorrected.wixpdb -pdb OldInstaller.wixpdb -x old\OldInstallerContent
```

```cmd
Melt.exe NewInstaller.msi -out new\NewInstallerCorrected.wixpdb -pdb NewInstaller.wixpdb -x new\NewInstallerContent
```

#### 2. Create the transform between your products with the help of Torch

```cmd
torch.exe -p -xi old\OldInstallerCorrected.wixpdb new\NewInstallerCorrected.wixpdb -out diff.wixmst
```

#### 3. Build the patch

```cmd
candle.exe patch.wxs
light.exe patch.wixobj -out patch.wixmsp
pyro.exe patch.wixmsp -out patch.msp -t patch diff.wixmst
```

_-t patch_ - 'patch' here refers to the PatchBaseline that we set in the patch.wxs file.

As a final output you should have a file called _path.msp_ that should have a smaller size then the .msi file. If you open it, to see its content it should only have the files that differ from the old installer.

Sources:

[Easy pure-WiX patching with Melt](http://www.joyofsetup.com/2013/07/16/easy-pure-wix-patching-with-melt/)  
[WiX mailing list](http://windows-installer-xml-wix-toolset.687559.n2.nabble.com/Creating-patches-using-wixout-bf-flag-deprecated-td7598765.html)  
[WiX Documentation](https://wixtoolset.org/documentation/manual/v3/overview/alltools.html)  
[Using Purely Wix](https://wixtoolset.org/documentation/manual/v3/patching/wix_patching.html)  
Nick Ramirez - WiX 3.6 A Developer's Guide to Windows Installer XML (2012)