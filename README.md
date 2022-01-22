# `keyboard_hider`

> This tiny Flutter package help you hide the keyboard. With convenient helper methods and the `KeyboardHider` widget.

Have you ever heard that in Flutter, everything is a widget? I have, so I decided to create a simple widget that helps you hide your users' keyboard easily on your forms. 

[![Continuous Integration](https://github.com/dartsidedev/keyboard_hider/workflows/Continuous%20Integration/badge.svg?branch=main)](https://github.com/dartsidedev/keyboard_hider/actions) [![codecov](https://codecov.io/gh/dartsidedev/keyboard_hider/branch/main/graph/badge.svg)](https://codecov.io/gh/dartsidedev/keyboard_hider) [![keyboard_hider](https://img.shields.io/pub/v/keyboard_hider?label=keyboard_hider&logo=dart)](https://pub.dev/packages/keyboard_hider 'See keyboard_hider package info on pub.dev') [![Published by dartside.dev](https://img.shields.io/static/v1?label=Published%20by&message=dartside.dev&logo=dart&logoWidth=30&color=40C4FF&labelColor=1d599b&labelWidth=100)](https://pub.dev/publishers/dartside.dev/packages) [![GitHub Stars Count](https://img.shields.io/github/stars/dartsidedev/keyboard_hider?logo=github)](https://github.com/dartsidedev/keyboard_hider 'Star me on GitHub!')

## Important links

* [Read the source code and **star the repo** on GitHub](https://github.com/dartsidedev/keyboard_hider)
* [Open an issue on GitHub](https://github.com/dartsidedev/keyboard_hider/issues)
* [See package on **pub.dev**](https://pub.dev/packages/keyboard_hider)
* [Read the docs on **pub.dev**](https://pub.dev/documentation/keyboard_hider/latest/)
* [Stack Overflow - How can I dismiss the on screen keyboard?](https://stackoverflow.com/questions/44991968/how-can-i-dismiss-the-on-screen-keyboard)
* Flutter Docs - [`GestureDetector`](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html), [`SystemChannels`](https://api.flutter.dev/flutter/services/SystemChannels-class.html), [`SystemChannels.textInput`](https://api.flutter.dev/flutter/services/SystemChannels/textInput-constant.html), [`FocusScopeNode`](https://api.flutter.dev/flutter/widgets/FocusScopeNode-class.html), [`FocusNode.unfocus`](https://api.flutter.dev/flutter/widgets/FocusNode/unfocus.html)

If you enjoy using this package, **a thumbs up on [pub.dev](https://pub.dev/packages/keyboard_hider) would be highly appreciated!** 👍💙🚀

<img src="https://github.com/dartsidedev/keyboard_hider/blob/main/doc_assets/example_app.gif?raw=true" alt="Flutter package keyboard_hider example app in action" height="750"/>

## Motivation

While interacting our users, we realized that not every user knows their keyboard very well and that they expect the keyboard to be hidden when the click outside a text field.
We decided to give our users to give the option to hide their keyboard for forms when the user clicked outside a text field.

I searched how to do that, and I found [this question](https://stackoverflow.com/questions/44991968/how-can-i-dismiss-the-on-screen-keyboard) on Stack Overflow.
I wasn't really satisfied with adding repeated code everywhere, as remembering how to configure the `GestureDetector`, and what is the correct way to `unfocus` (hide the keyboard) is a little annoying.
You can see [my answer on Stack Overflow](https://stackoverflow.com/a/55727378/4541492) from 2019: I decided to wrap this functionality in a convenient Flutter widget that simplifies hiding the keyboard whenever the user taps on the screen outside a text field (similar to how keyboard hiding works on the web).

Since then, I worked on a couple of projects, and I've seen that this pattern is discussed again and again, so now I decided to publish this package so that I (and everyone else) can quickly and simply add this functionality to our Flutter apps.

## Usage

Wrap the widget that should detect touches and upon touch, it should hide the keyboard if visible.
The widget doesn't interfere with text fields, so your users can seamlessly switch and jump between text fields, even if the text fields are wrapped in a `KeyboardHider` widget.

```dart
import 'package:keyboard_hider/keyboard_hider.dart';

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // When you now tap on the child, the keyboard should be dismissed.
    return KeyboardHider(
      child: Text('your widgets...'),
    );
  }
}
```

The package also includes two helper functions that simplified hiding your keyboard.

The `unfocus(BuildContext context)` function takes the context and dismisses the keyboard by un-focusing the context's `FocusScopeNode`.

The `hideTextInput()` function invokes the `TextInput.hide` method on the `SystemChannels.textInput` method channel.

If needed, you can also pass a `HideMode` value to the `KeyboardHider`.
By default, the `KeyboardHider` widget uses the `unfocus` approach, but you can change that to `hideTextInput`:

```dart
class YourOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // When you now tap on the child, the keyboard should be hidden.
    return KeyboardHider(
      mode: HideMode.hideTextInput,
      child: Text('your widgets...'),
    );
  }
}
```

With `hideTextInput`, the keyboard will be hidden, but it does not unfocus the current focus scope node.
This means that if a text field was in focus, it will stay in focus, only the keyboard will get hidden.

You can find the example app on [GitHub](https://github.com/dartsidedev/keyboard_hider/blob/main/example/lib/main.dart) and on [pub.dev](https://pub.dev/packages/keyboard_hider/example).

If you still have questions about the structure of this package, I encourage you to take another look at the [docs](https://pub.dev/documentation/keyboard_hider/latest/).
