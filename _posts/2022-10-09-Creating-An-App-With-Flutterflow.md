---
layout: post
title: (Draft) Creating an App with Flutterflow
comments: true
tags: flutterflow flutter app ios android cross
---

_Disclaimer: this post was not paid or sponsored in any way._

As a software developer an advice that multiple times is repeated is to _use the right tool for the job_. This becomes a hard choice when there are new tools appearing every day, tools that approach the same problem (job) from a different angle. Not to mention that with every tool a new way of thinking may also be (mostly) required.

## Backstory

Not long ago I was commissioned to create a small Mobile Application. After some initial talks, the main conceptual design and the requirements were clear. The application needed to serve pages with information on how people should collect selective waste. These pages should be broken up into categories (like glass, paper, household, plastic & metal and BIO/Compost). The categories should serve static information. The other feature of the application was to create a quiz on this knowledge. The quiz consisted of showing images and the user should guess in what category type does it belong to. At the end we should have a score and based on that score a message on the users knowledge. The application should be in one language (maybe have support for other languages in the future). Both Android and IOS variants should be published with same design and functionality. No other platforms should be considered. No user management or registration required. No data saved or transmitted to server.

## Searching for the right tool

With these requirements I started to look for options to develop this application. Creating it natively for two platforms was out of the question. It was just too much overhead to create it in two languages with their own frameworks. Next options were the build once publish to all devices options. Here came React.Native, Ionic, Flutter, Xamarin (.NET MAUI), Uno Platform etc. I am a versed .NET developer and played around with Xamarin and Uno before, but was also keen on trying out something new. Flutter seemed to be the right candidate, but after looking into it, it would have taken a lot of time to learn the quirks of the platform + language, time I didn't have.

<p align="center">
    <img src="{{ site.baseurl }}/images/flutterflow/react.png" height="100"/>
    <img src="{{ site.baseurl }}/images/flutterflow/ionic.png" height="100"/>
    <img src="{{ site.baseurl }}/images/flutterflow/maui.png" height="100"/>
    <img src="{{ site.baseurl }}/images/flutterflow/flutter.png" height="100"/>
    <img src="{{ site.baseurl }}/images/flutterflow/uno.png" height="100"/>
</p>


Then I saw a video from a Google I/O where Flutterflow was presented. It seem simple and very capable. After taking a look at some samples, I went and registered to their website to see it in action. They offer a simple drag-and-drop kind of building experience. Building an application with ready made components, design examples, page templates and many more. This seemed really good, my application was simple enough to try this service out.

As no-code products are on the rise, this one provides a service that can achieve mobile apps without writing code. I think of it as the Wix or SquareSpace for mobile applications. Now all the _real_ developers will rise and say that these do not create _real_ websites and yes I understand what you are talking about, but they are not designed to create complex custom websites. They offer a big help and tools for the majority of the use cases that ordinary people would need. They lower the bar for creating simple but eye catching website. Their market is there and that market is pretty big. It's the same discussion as with having a high-end PC to surf the web, edit documents when a really underpowered Chromebook can also suffice. It comes right down to the right tool for the right job. Creating and publishing an app without having to install any developer tools, dependencies and configuring everything sounds really great.

## Trying out FlutterFlow

The editor layout is pretty normal and straight forward for developers, but also not overcomplicated for newcomers. Users can easily change between different screen sizes that render the screens instantly to that format. Here multiple example devices are show, but custom size can also be selected. In the same row errors can also be visualised, but that only changes if custom code is applied. You can also view the application and there is an option to _publish_ it for a test view that can be shared with clients. Building these take up a few minutes, but were very helpful while building the app.

<p align="center">
    <img src="{{ site.baseurl }}/images/flutterflow/tobBar.png"/>
</p>

From the sidebar other options can be accessed like the widgets, pages, custom functions settings etc. The tree of a built page is shown really similar to Visual Studio WPF trees. Navigating between the components, adding, hiding, sizing, moving is a breeze with the options readily available in the editor. There are separate tabs for events and animations. These somehow feel like how you set the animations in Powerpoint, maybe more easy to set.

Setting up the app colors is also done really well, in the configuration page, you have a theme tab, where the color for the whole application can be set. I really like here the Coolors integration. I am not great with selecting colors. Coolors offer a great way to create a color palette. After having found all the colors it can be exported and imported in a way that Flutterflow understands and integrates in the themes.

When creating a new page, I found it really helpful to start out with a template and just move on to create what I want from there. The templates are thematic, so if you are doing a login page there are already made examples, if you want a product catalog, there are samples for that too. For the static part of the application this worked really well and pages were created really fast, even adding animations went quick.

The quiz part of the application seemed to pose a little more challenging. Here I think the way of thinking represented a big issue for me. As a developer, you are taught that reuse code, code duplication is bad, etc. With this in mind I had to make decisions that if I would have written code I would have made differently. Even for static pages most screens could have been reused with different text, but with Flutterflow creating separate pages is more easier and faster. This is where I found out that no-code tools are mostly created for non-developers who do not care for clean efficient code. Flutterflow lets you download the generated source code, but the generated code several times is not that optimal.

The first problem I encountered, that without creating a custom widget (which is possible) I cannot set an image a variable, so that I can update the shown image as the quiz progresses. Resulting in adding all the images to the page and then setting their visibility from a variable which is possible. Optimal? no! Does it work? Yes! How well? Pretty good actually, but I think flutter is to thank for that.

For the custom logic, there are two options _Custom Functions_ and _Custom Actions_. These are used in different situations and they do not inherit the same global properties that can be use, for example the functions cannot see FFAppState() variables. For the quiz I used both of them. Another thing I could not figure out is how to announce/push an update for variable from a Custom Function. This functionality just seems to be missing right now. What resulted in long Action Flows, meaning an action triggered my custom action, this custom action changed variables, then a Flutteflow action needed to be used for each variable to set the same value again to trigger the update in the UI. A bit nerving, hope they add this functionality in the future. The other issue was that you cannot debug your custom functions or actions. If something doesn't go as you expected it to go, you need to go to great lengths to debug it. I created a special text field and used it like a `console.log()`. Now this is time consuming if you want bigger complex custom logic in your app.

<p align="center">
    <img src="{{ site.baseurl }}/images/flutterflow/actionFlow.png"/>
</p>

### Deployment

Unfortunately deployment is not available in the free tier. For this feature the highest plan needs to be activated that is currently 70$ / month or 50$ / month if you pay for a year. Although a premium feature, it is done via a 3rd party service Codemagic. If you are really strapped for cash, maybe you can opt for the 30$ plan, which offer to download the code and then set-up the Codemagic workflow yourself, as they have a limited but free plan. But there is no documentation on how can you deploy, publish an application yourself.

I opted to use the Flutterflow version and to do one-click deployments right from their interface. You need to configure it, which I found to be ok as they offer step-by-step videos on how to get the credentials and configs needed for the deployment. After setting it up it worked really good and it was really just one click :)

### Conclusion

Flutterflow is a good piece of software, it isn't perfect and it certainly can get nerving for developers sometimes, but it always offers solutions, workarounds. It is actively developed and new features, widgets are popping up every week. Seeing their weekly emails, they put a lot of effort in creating an easily usable mobile app builder. For my use case the app was fast and didn't have hiccups running it, however sever warnings showed up after submitting them to the application stores. Both on IOS and Android have shown warnings and some minor errors. This didn't cause any problems and the Swapp app is published on android (pending on ios).

### The final app

<p align="center">
    <img src="{{ site.baseurl }}/images/flutterflow/1.png" width="100"/>
    <img src="{{ site.baseurl }}/images/flutterflow/2.png" width="100"/>
    <img src="{{ site.baseurl }}/images/flutterflow/3.png" width="100"/>
    <img src="{{ site.baseurl }}/images/flutterflow/4.png" width="100"/>
</p>
