---
layout: post
title: Add Git Bash To Visual Studio Top Bar
comments: true
tags: vs visual studio menu git bash menu-bar bar shortcut visual-studio
---

<p align="center">
    <img src="{{ site.baseurl }}/images/git-vs/step0.png" alt="Add Git Bash To Visual Studio Top Bar"/>
</p>

There are numerous times when the Visual Studio built-in Git operations are not enough to handle the task you need to solve. 
Often the best way to use git is from the Git Bash. 
That is why you should add it to the Visual Studio top menu bar.
This way the git bash will open in the correct place ready to execute your commands.

#### The following steps will guide you to achieve this:

From the menu bar select **Tools** -> **External Tools...**
<p align="center">
    <img src="{{ site.baseurl }}/images/git-vs/step1.png" alt="Add Git Bash To Visual Studio Top Bar - Step 1"/>
</p>

Add a new External Tool. 
Give the path to your local Git bash installation and select **$(SolutionDir)** as the _Initial directory_. 
This way it will always open up in the currently opened solution directory.
<p align="center">
    <img src="{{ site.baseurl }}/images/git-vs/step2.png" alt="Add Git Bash To Visual Studio Top Bar - Step 2"/>
</p>

Then go to **View** -> **Toolbars** -> **Customize...**
<p align="center">
    <img src="{{ site.baseurl }}/images/git-vs/step3.png" alt="Add Git Bash To Visual Studio Top Bar - Step 3"/>
</p>

Once the window opened select the **Commands** tab and click **Add Command...**
<p align="center">
    <img src="{{ site.baseurl }}/images/git-vs/step4.png" alt="Add Git Bash To Visual Studio Top Bar - Step 4"/>
</p>

Choose from the Tool the new **External Command**, the number may depend on the defined external commands.
<p align="center">
    <img src="{{ site.baseurl }}/images/git-vs/step5.png" alt="Add Git Bash To Visual Studio Top Bar - Step 5"/>
</p>

After adding it to the _Preview_. Select it and move it down to the end.
<p align="center">
    <img src="{{ site.baseurl }}/images/git-vs/step6.png" alt="Add Git Bash To Visual Studio Top Bar - Step 6"/>
</p>

That's it! You should now have the option to open git bash directly from Visual Studio.