---
layout: post
title: Add Https to Azure Web App with Let's Encrypt
comments: true
tags: windows https azure web app lets let encrypt secure certbot certificate cert
---

You have deployed a web app docker container to Azure Web App service. Now you want to enable Https for the web application. 
This article will show you, how you can manage that from a Windows operating system. 
The creation and addition in this case will be manual. 
The certificate will be created with the help of Let's Encrypt. 
To transform the certificate into the right format for Azure, OpenSSL will be used.

**Note:** *If you do not have a custom domain name, you should consider the Certificate service from Azure. This is a free service, it creates a Digicert certificate and it also renews it automatically. It comes with limitations though.*


To create a Let's Encrypt certificate, first, you should download the Certbot program from their site. The windows version is still in beta, but it works nonetheless. You can get it from [here](https://dl.eff.org/certbot-beta-installer-win32.exe) or check out their site for instructions on how to install it [here](https://certbot.eff.org/lets-encrypt/windows-other).

After installing the Cerbot you should be able to call certbot commands from cmd or powershell.

### Issuing a certificate

The following command needs to be executed to create a certificate:

```shell
certbot certonly -d testDomain.com -d www.testDomain.com --manual --preferred-challenges dns
```

* **certonly** - only creates a certificate, does not install it on the machine
* **-d** - domain name specifier, you can add multiple domains, subdomains for a certificate
* **--preferred-challenges dns** - defines how you prove that the domain is under your administration. In this case with a DNS challenge. A DNS challenge requires you to add a DNS TXT record on your domain.

If you use the DNS Zones service from Azure, you should add a new Record like this.

<p align="center">
    <img src="{{ site.baseurl }}/images/posts/dnsChallenge.png" alt="Azure DNS Record"/>
</p>

After the DNS challenge is successfully made, you should have a message, that is successfully created the certificate. For the default installation the path where the certificate was exported is _C:\Certbot\archive_.

The following files should be there:
* cert.pem
* chain.pem
* fullchain.pem
* privkey.pem

### Converting the certificate for Azure

Azure requires a private certificate in the PKCS#12 file format. Certbot does not generate it out of the box, but we can convert it to the right format with OpenSSL.

For a pfx certificate this command needs to be run: with the files from the previous step.

```shell
openssl pkcs12 -export -out certificate.pfx -inkey privkey.pem -in cert.pem -certfile chain.pem
```

**Note:** *You will have to give a password in this process, this password will be used later when we upload the certificate.*

### Uploading certificate to Azure Web App service

Open App Service from the Azure Web portal. From the left navigation of your app, select **TLS/SSL settings** > **Private Key Certificates (.pfx)** > **Upload Certificate**. Then add binding to the Custom Domain under the **Custom Domain** section.

More on this, in the official documentation:
https://docs.microsoft.com/en-us/azure/app-service/configure-ssl-certificate#upload-certificate-to-app-service