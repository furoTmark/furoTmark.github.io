---
layout: post
title: Configuring Caddy v2 Server with Plex and Transmission
comments: true
tags: caddy server reverse proxy plex transmission config
image: /images/caddy/caddy-plex-transmission.png
---

<p align="center">
    <img src="{{ site.baseurl }}/images/caddy/caddy-plex-transmission.png"/>
</p>

## Caddy Server
The web server called Caddy is made to be simple to set up and operate. Using Caddy has a number of benefits, such as: 

It is quick and straightforward to set up and deploy thanks to the configuration syntax's simplicity and readability. 
It makes it simple to secure your website and safeguard the information of your users thanks to built-in support for HTTPS and automatic TLS certificate management. 
With its built-in support for popular online apps and frameworks like PHP and Wordpress, it is simple to launch your website rapidly. 
It also provides a number of other helpful features that can help your website operate better and scale more easily, like support for reverse proxies, load balancing, and HTTP/2.
Overall, Caddy is a powerful and versatile web server that can be a great choice for a wide range of applications.

For this little home project I used the reverse proxy functionality (and took advantage of the HTTPS/TSL Certificate).

## Plex Media Server

You can organize and access your personal media library from any device using Plex, a media server and streaming program. Using Plex benefits are the following: 

Your media library, which includes movies, TV series, music, and images, can be conveniently organized and accessed from any device. 
It supports a broad variety of media types, including well-known audio and video formats, and features an intuitive user interface that makes browsing and playing your media simple. 
It makes it simple to access your material while on the road because it includes built-in support for streaming to a variety of devices, including smart TVs, streaming boxes, smartphones, and tablets.
It includes many helpful capabilities, including the capacity to automatically download information for your media, such as cover art and synopses, as well as automatically transcode your media to play on devices that don't natively support the original format. 
Overall, Plex is a strong and adaptable program that may be an excellent resource for managing and accessing your own media library.

## Transmittion

Transmission is a well-known BitTorrent client that enables BitTorrent protocol-based file sharing and downloading over the internet. Using Transmission has a several, including: 

Because it is open source, anyone can modify and distribute it, and it is freely available. 
It is a wonderful option for users who are new to BitTorrent because it is lightweight and has a straightforward, simple interface. 
It is a good option for consumers that require a cross-platform solution because it supports a wide range of systems, including Windows, Mac, Linux, and Unix.
It offers several helpful features that can make using and managing your downloads simpler, like support for magnet links, bandwidth scheduling, and web-based remote management. 
With features like encrypted connections and support for proxy servers, which can help safeguard your identity and keep your downloads private, it has a solid reputation for security and privacy. 
In conclusion, Transmission is a trustworthy and well-liked option for a BitTorrent client that provides a wealth of functionality and solid performance.

## Configuring all together

In my case, I wanted to configure them to be accessible by a web path instead of the ports and would disable access to the ports after. Because it was a small home project running from a raspberry pi, a free domain was used that only provided me with one subdomain. This brought new challenges as **Plex** works great if you want to configure a new subdomain for it ex. _plex.domain.com_ but doesn't play nice if you want to for it to another custom path like _example.domain.com/plex_. After a lot of trial and error, I found that `/web` path works even in a subdomain. The workaround was to use the _uri replace_ directive to redirect `/plex` calls to `/web`. Also, Caddy usually needs a slash at the end of the url, so I used the _redir_ directive to get around this, it is similar to the _uri replace_ directive.

The final configuration:  

```yml
example.domain.com {
  encode gzip
  uri replace /plex /web/
  uri replace /plex/ /web/
  reverse_proxy /web/* :32400

  redir /transmission /transmission/web/
  reverse_proxy /transmission/* :9091
}
```

Hope it helps!