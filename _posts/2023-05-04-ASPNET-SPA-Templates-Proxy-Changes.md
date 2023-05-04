---
layout: post
title: ASP.NET SPA Templates Proxy Changes From .NET 5 to .NET 6, .NET 7, and On
comments: true
tags: asp.net dotnet proxy spa template react angular
---

## Key Takeaways

- In .NET 6, the communication between front-end SPA and back-end .NET API was changed.
- From .NET 6, the template uses the front end’s proxy solutions to send the request to the back end, resulting in a more independent back end.
- A proxy for the development servers enables readable and debuggable code for both the front and back end.
- Using Microsoft’s reverse proxy solution Yarp with the SpaYarp package is still a viable alternative.
- The .NET 6 changes also apply to the following versions.

Read the full article on InfoQ:
https://www.infoq.com/articles/dotnet-spa-templates-proxy/