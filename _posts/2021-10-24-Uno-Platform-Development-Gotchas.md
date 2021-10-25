---
layout: post
title: Uno Platform development gotcha's
comments: true
tags: uno platform cross platform dotnet framework app android ios apple
---

In the past month, I played around with uno platform. If you don't know about the uno platform, it is a way to create cross-platform applications with .NET.
They make two bold claims that got my attention to try it out.
* Pixel-Perfect Multi-Platform Applications with C# and WinUI
* The first and only UI Platform for single-codebase applications for Windows, WebAssembly, iOS, macOS, Android and Linux

My plan was to transform one of my projects, [egyketto.ro](https://egyketto.ro), into a mobile app run on Android and iOS.

<p align="center">
    <img src="{{ site.baseurl }}/images/uno/egyketto-uno-transform.png" alt="egyketto.ro uno transform"/>
</p>

Having experience with WPF, it was relatively easy to get into writing XAML code for the UI. 
After a few days, I can say that the applications booted up on both platforms. 
Still, I have learned some things during this experience.

## Gotcha's

### It actually works :)
A UWP app can be transformed quickly into a Mobile App. In my experience, the project was created from scratch, and an MVP could be delivered in a week. 
There is still room for optimization, but it works way better than I expected on the first run.

### Builds can take a lot of time
Because you are actually creating Windows, WebAssembly, iOS, macOS, Android and Linux apps simultaneously, building may take up more time.
The same error can show up several times and working with emulators, well, is still like working with emulators and not real devices.

The good thing is that there are ways to get around this.

* Just delete the project you do not care to develop for.
* Create a development build config that would only build for one platform. Removing everything and working just for UWP until you have something to test on other devices could significantly speed up the development cycle.

<p align="center">
    <img src="{{ site.baseurl }}/images/uno/UWP-Only-Config.png" alt="UWP only config"/>
</p>

### References may seem strange

The base references are not always uno specific references. For example, file manipulation for all platforms is achieved by referencing **Windows.Storage** package.

For HttpHander the case is different. If you want to support WASM you will need a specific reference for it. This is due to the particular nature of WASM, but be aware of this quirk.

A possible solution is using directives like:

```csharp
#if __WASM__
    var innerHandler = new Uno.UI.Wasm.WasmHttpHandler();
#else
    var innerHandler = new HttpClientHandler();
#endif
    _client = new HttpClient(innerHandler);
```

### Information is there, but not in the traditional form

When receiving an error or searching for a solution, one should use other frameworks keywords as search parameters. 
With XAML issues, I found that using UWP or WPF keywords would bring me better results. 
For Mobile platform issues, using Xamarin as a keyword worked better. 
There are already uno platform-specific questions on Stackoverflow, but there are still just a few compared to the older technologies.

Besides this, there are new and new technical blog posts showing up, and they have a really active discord channel that you should check out if you run into a problem.

## Usefull links
* [Uno platform](https://platform.uno/)
* [Uno Youtube channel](https://www.youtube.com/channel/UC8GkqD6hsSkwYof6n2Wk1hg) with a lot of good tutorials and streams
* [Discord](https://discord.gg/eBHZSKG) under the **#uno-platform** channel