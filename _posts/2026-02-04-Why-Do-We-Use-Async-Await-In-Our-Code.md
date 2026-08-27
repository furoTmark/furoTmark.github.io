---
layout: post
title: Why do we use async-await in our Code
date: 2026-02-04
tags: code async await asynchronous concurrency parallelism 
image: /images/async-sync/sync-async.png
at-image: /images/async-sync/sync-async.png
atUri: "at://did:plc:be2rwmqqn7ek4o4mdnvb7hnb/site.standard.document/3mu2e6uxqqi2r"
---


In the project I am currently working on, we inherited a codebase written in an older version of .NET Framework. The [ASP.NET](http://ASP.NET) part of it was still using synchronous controller methods. This wasn’t changed for a long time because, why bother if it works? Then, some newer methods became `async Task` type methods with async code. Then we continued to have both, with some wiring when we went from sync to async. Then a performance problem came up. The issue was weird, and we didn’t know whether the wiring was at fault or not. So we just went in and updated all the old methods into async methods without changing the logic or anything.  
To our surprise, the same code, on the same .NET Framework, on the same machine, started responding 29% better. Then we did some minor fixes, and that percent became even higher to ~44%

| Iteration | From (ms) | To (ms) | Absolute Improvement (ms) | Improvement (%) |
| --- | --- | --- | --- | --- |
| Sync → Async controllers | 276 | 197 | 79 | 28.6% |
| Sync → Async controllers + code optimizations | 276 | 155 | 121 | 43.8% |


These results caught me off guard, so I wanted to find out what was happening behind the scenes, how `async-await` actually works, and why it led to such a big performance boost.

## What is asynchronous programming?

First, let’s look at a few definitions of asynchronous programming:

> [!NOTE] JavaScript  
Asynchronous programming is a technique that enables your program to start a potentially long-running task and still be responsive to other events while that task runs, rather than having to wait until that task has finished. Once that task has finished, your program is presented with the result.[^1](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Async_JS/Introducing)

> [!NOTE] Rust  
*Asynchronous programming* is an abstraction that lets us express our code in terms of potential pausing points and eventual results that take care of the details of coordination for us. [^2](https://doc.rust-lang.org/book/ch17-00-async-await.html)

> [!NOTE] Dotnet  
Async methods are intended to be non-blocking operations. An `await` expression in an async method doesn’t block the current thread while the awaited task is running. Instead, the expression signs up the rest of the method as a continuation and returns control to the caller of the async method.[^3](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/task-asynchronous-programming-model#threads)

What we want to achieve with async code is not to block other operations from executing while a longer-running task is being processed. This provides a pleasant user experience. Think of a button that plays a song: once pressed, nothing else can happen; you cannot pause it, stop it, change the volume, or manage the playlist until the song finishes. This is what async enables.

<p align="center">
    <img src="{{ site.baseurl }}/images/async-sync/sync-async.png"/>
</p>

Similar solutions include using *events* or *callbacks*. Events enable operations to be performed at command when the event is triggered. Callbacks are another way to pass an operation to another operation, with the expectation that the second will call the first when needed. Both are used in different scenarios, but without oversight, they can be hard to follow and lead to event spaghetti, callback hell, or other popular code disasters.

`The async-await` combo became popular because of this. It enables writing code that looks like normal synchronous code while adding asynchronous capabilities in a simple way.

It’s important to clear up two related concepts that people often mix up: concurrency and parallelism. Knowing the difference helps you get the most out of async programming.

## Concurrency ≠ Parallelism: understanding the difference

Both seem to do multiple things at once, and they do; the difference is in **how** they do it.  
To better understand it, we need to realize that these notions apply to the CPU. Meaning that the operating system has other system components that also do work, and when we are talking about concurrency, we mainly are thinking about what the CPU can do while the other components respond. We can group these system components and name them I/O-bound tasks, such as waiting for the disk to read a file's contents, waiting for a network response, or waiting for results from a database. Even with a single-core CPU, we can better utilize it while we wait for I/O (Input/Output) responses and handle the next task.

The example would be having one chef making a pasta dish. First, a pot is put on the stove filled with water. Then some salt is added to the pot, and the heat is turned on. While we wait for the pasta water to boil, we can do the next task, like grate some cheese. When the water reaches a boil, we return and put the pasta in, then do another task while it cooks, and so on.

For parallelism, we need multicore processors, which have been a feature since 2005. Meaning that if you run something on a modern PC, it will most likely be on a multicore processor (CPU). Usually, a thread pool manages tasks and the available threads to perform the work.

If we were to go on the previous example. This would mean that multiple chefs are making a pasta dish. Chef-1 could take care of the pasta task, and Chef-2 could do the sauce for it.

If you observe closely, you can see that in this example, the chefs work in parallel but not concurrently. Each chef handles the entire task, start to finish, by themselves, making each task “synchronous”.

Mixing the two concepts, concurrency and parallelism, would mean having Chef-1 put the water to boil while, in parallel, Chef-2 cuts onions for the sauce. If Chef-1 finishes faster, it could continue chopping tomatoes for the sauce. Then, when Chef-2 finishes, it can continue the pasta task or finish it if Chef-1 is still busy.

This is what async-await actually does behind the scenes. It helps with doing tasks so that blocked parts can be resumed later. If the context allows another thread to pick up the task, it can happen, but it is not guaranteed. This is why concurrency does not always guarantee parallelism. All other threads can be busy with other things, so the same thread will be used when the I/O operation finishes.

---

In summary, embracing asynchronous programming with async-await in .NET is more than a modern trend. It's a practical way to achieve real-world performance improvements, often with minimal code changes. By clarifying the concepts of concurrency and parallelism and understanding their impact, we can write applications that are not only faster but also more responsive and maintainable. Revisiting and updating legacy codebases can yield surprising benefits and remind us that sometimes, questioning “what just works” leads to breakthroughs that benefit both developers and users alike.

