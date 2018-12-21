---
layout: post
title: Jekyll Tag Generator for Github Pages
comments: true
tags: powershell windows tag-generator
---

Long Qian has a great [blog post](http://longqian.me/2017/02/09/github-jekyll-tag/) about how to put tags on Github pages.
While following the steps suggested by him, I saw, that the tag_generator script was written in python.
Since I did not have a python compiler installed on my windows machine, I thought it should be easy to convert to a Powershell script.

The advantage is that _Windows PowerShell comes installed by default in every Windows, starting with Windows 7 SP1 and Windows Server 2008 R2 SP1_ (According to the [Microsoft documentation](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell?view=powershell-6)).

<script src="https://gist.github.com/furoTmark/079d1da7201713a8e0c1f25afb90daae.js"></script>

In order to use it, follow the steps described in Long Qian's post and in step 5.3 use this tag generator instead.
