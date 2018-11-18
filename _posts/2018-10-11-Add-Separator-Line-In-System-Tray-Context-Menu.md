---
layout: post
title: Add Separator Line In System Tray Context-Menu Programatically
comments: true
tags: NET dotNET c# WPF System-Tray-Icon
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

**Note:** *If you want a second separator or multiple separators, you need to create a new MenuItem object for each separator. The separator object cannot be reused. Reusing the object will result in only one Separator as the ContextMenu will filter out the duplicates.*

# Bonus tip: Adding Context Menu to Left Mouse Click

The context menu is activated by default only on right mouse click. Unfortunately the ***ShowContextMenu*** method is defined as private in the *.NET* framework (See [.NET Reference Source](https://referencesource.microsoft.com/#System.Windows.Forms/winforms/Managed/System/WinForms/NotifyIcon.cs,fc0e2a272ada0b8f,references)) so it cannot be called on the MouseDown action. One solution to resolve this issue: the private method must be invoked like this.

```csharp
var systemTrayIcon = new NotifyIcon();
systemTrayIcon.MouseDown += (sender, e) =>
    {
        if (e.Button == MouseButtons.Left)
        {
            MethodInfo mi = typeof(NotifyIcon).GetMethod("ShowContextMenu", BindingFlags.Instance | BindingFlags.NonPublic);
            if (mi != null)
            {
                mi.Invoke(systemTrayIcon, null);
            }
        }
    };
```
