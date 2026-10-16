---
layout: post
title: Did I Mention You Have No Excuse for Skipping Regression Tests Anymore
date: 2026-03-31
tags: [testing, regression, ui, playwright, rambling]
atUri: "at://did:plc:be2rwmqqn7ek4o4mdnvb7hnb/site.standard.document/3mxyooi55jh2s"
---

I get you. I really do. 
Creating regression test are always *not* a priority. 
Maintaining the tests is a hassle. 
Creating new ones can be cumbersome.

Well, not in the AI (is anybody saying SI ?!) era!
This is a change where every project can upgrade its quality.
It can guard from unwanted changes.
It will help to make you sure that you didn't break anything.

Yes, regression testing can take on multiple forms. 
I still urge you to start with unit test as a foundation for all.
But with AI + Playwright you can now easily record a new test, then ask the AI to improve it and full-proof it for next run. 
Guess what, it actually works really great!*
\*this does not mean it will actually be green or successful

Oh, you have tests written in a system that you are not familiar with (for my case TestSigma).
This system doesn't really let you export the tests you already created.
Ok, just open it in the browser and let the agent take each test page and rewrite it in playwright one by one. It will take up more time than if you would have it in an exported file, but actually it doesn't cost much tokens with a decent newer cheap model (Haiku or Luna).

Ok, now just setup an action that will run after you deployed or daily or when you need it.
Set it up to test with multiple browsers, multiple devices, multiple screen sizes.
Check if it's green. (It is never green)
If so, then celebrate because you can have more confidence in your work.
If not, then get the multitude of reports, traces, screenshots and videos to debug and see what changed. (Or to give to AI to see what gives)

Now this step is important.
Take that 1h or so to review the tests if they are working as they should and do what they supposed to do.
This will create a good base for the next tests.

????? - Profit
Kidding, get ready for always RED Reports, because something's always wrong...

Bonus: [How to Generate Tests in Playwright with the VS Code Extension](https://www.youtube.com/watch?v=5XIZPqKkdBA)
