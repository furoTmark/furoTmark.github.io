---
layout: post
title: Add Separator Line In System Tray Context-Menu Programatically
comments: true
---

When creating a ***ContextMenu*** programatically, this class only accepts ***MenuItem*** items. Adding a ***Separator*** ( ***< Separator />*** ) as one would do in *XAML* does not work. To add a separator line is actually quite easy, but you have to know to create a ***MenuItem*** with the parameter ***"-*"** as string.

```csharp
 var test1 = new MenuItem("Test Item 1");
 menuItems.Add(test1);
 var separator = new MenuItem("-");
 menuItems.Add(separator);
 var test2 = new MenuItem("Test Item 2");
 menuItems.Add(test2);
```

<p align="center">
    <img src="{{ site.baseurl }}/images/posts/menuItemSeparator.png" alt="Menu Item Separator Example"/>
</p>

**Note:** *If you want a second separator or multiple separators, you need to create new MenuItem object for each separator. The separator object cannot be reused. Reusing the object will result in only one Separator as the ContextMenu will filter out the duplicates.*
