---
layout: post
title: Update Asp.NET Core 3.1 create-react-app project to .NET 5
comments: true
tags: asp dotnet 3.1 5 framework update react app create nuget docker memory npm images buster runtime sdk core alpine linux
---

Updating a Asp.NET Core application to a new version of .NET is a relatively straightforward experience. 
From .NET 5, the two frameworks, .NET and .NET-core are merging. 
In the future, .NET will be able to build for any target system. 
With this version of .NET the app gets faster and also uses less memory.  
To Upgrade the ASP.NET Core Web 3.1 app to ASP.NET Core 5, follow these steps.

## Prequisites

.NET 5 installed, can be downloaded [here](https://dotnet.microsoft.com/download/dotnet).  
Visual Studio 2019 updated to the latest version.

## Update Target framework to .NET 5

Open the project in Visual Studio.  
Go to Properties -> Application -> Target framework -> from the dropdown list select NET 5.0

<p align="center">
    <img src="{{ site.baseurl }}/images/dotnetUpdate/Upgrade-ASP.NET-Core-Web-3.1-to-ASP.Net-5.jpg" alt="Upgrade ASP.NET Core Web 3.1 app to ASP.Net 5.0"/>
</p>

or open the project .csproj file and change the TargetFramework to *net5.0*

```diff
...
  <PropertyGroup>
-    <TargetFramework>netcoreapp3.1</TargetFramework>
+    <TargetFramework>net5.0</TargetFramework>
  </PropertyGroup>
...
```

## Update NuGet packages

<p align="center">
    <img src="{{ site.baseurl }}/images/dotnetUpdate/managepackages.png" alt="Manage NuGet Packages"/>
</p>

In the NuGet package manager, several packages should be updated to the new versions.  
For me this included the updates for packages:
* Microsoft.AspNetCore.SpaServices.Extensions
* Microsoft.Extensions.Logging.AzureAppServices
* Microsoft.VisualStudio.Web.CodeGeneration.Design

## Update npm packages (optionally)

This is not a requirement as it is separate from the .NET Framework, none the less it is essential to keep the libraries up to date, so the vulnerabilities are mitigated.


In the client app folder, open up a PowerShell or command line and run:

```shell
npm update
npm audit fix
```

## Update docker images

My project is in a docker container, so the images need to be also updated.

**Note:** *There is a breaking change (more [here](https://github.com/dotnet/dotnet-docker/issues/1814)) in the new images that they have dropped git/curl/wget from the images so this is a change that needs to be addressed in the docker file.*

In the dockerfile, I separate the build from the final version. 
This results in a smaller image size at the end. 
The project is built with the full SDK docker image. 
The published version is on an ASP.NET slim image. 
This usually saved a couple of hundred MBs depending on the project size.

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
RUN apt-get update && apt-get install -y --no-install-recommends \
		curl \
	&& rm -rf /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs
COPY ["DotNetProject/DotNetProject.csproj", "DotNetProject/"]
RUN dotnet restore "DotNetProject/DotNetProject.csproj"
COPY . .
WORKDIR "/src/DotNetProject"
RUN dotnet build "DotNetProject.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetProject.csproj" -c Release -o /app/publish -r linux-x64 -p:PublishTrimmed=True

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetProject.dll"]
```

For an even smaller image, one can use the alpine linux docker image. 
It produces a considerable smaller docker image. 
I have added this configuration file also below. 
There is a difference on how you add the necessary npm/nodejs package.

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
RUN apk add --update npm

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build
WORKDIR /src
RUN apk add --update npm
COPY ["DotNetProject/DotNetProject.csproj", "DotNetProject/"]
RUN dotnet restore "DotNetProject/DotNetProject.csproj"
COPY . .
WORKDIR "/src/DotNetProject"
RUN dotnet build "DotNetProject.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetProject.csproj" -c Release -o /app/publish -r linux-musl-x64 -p:PublishTrimmed=True

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetProject.dll"]
```

## The result

For the docker images sizes, the buster image version did not change much. 
One could say that it remained the same. 
The alpine image, however, with everything needed for the asp.net create-react-app is 100+ MB smaller. 
It is worth taking into consideration if the size is an issue.

<p align="center">
    <img src="{{ site.baseurl }}/images/dotnetUpdate/docker.png" alt="Docker Image sizes"/>
</p>

Performance-wise the two new images were faster than the .NET 3.1 image. 
The startup has greatly improved. 
After publishing it to Azure, comparing the average memory working set also showed a significant drop in memory usage. 
From 300MB, it dropped now to 200MB.  

<p align="center">
    <img src="{{ site.baseurl }}/images/dotnetUpdate/memory.png" alt="Average memory working set"/>
</p>

Kudos to the .NET guys!
