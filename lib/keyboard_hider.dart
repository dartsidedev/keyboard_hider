/// Library that simplifies hiding the keyboard in Flutter apps.
///
/// The library includes the `KeyboardHider` widget with optional `HideMode`
/// to either unfocus the current `FocusScope`, or
/// to use `SystemChannels.textInput` to hide the keyboard.
///
/// It also includes the `unfocus` and `hideTextInput` helper methods that can
/// hide implementation details and make the code more expressive.
library keyboard_hider;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// How to hide the keyboard.
enum HideMode {
  /// Uses the context's [FocusScopeNode]'s (by calling the [FocusScope.of])
  /// unfocus method.
  unfocus,

  /// Uses the textInput channel used by the Flutter system, and invokes
  /// 'TextInput.hide' on it.
  hideTextInput,
}

/// A widget that upon tap attempts to hide the keyboard.
class KeyboardHider extends StatelessWidget {
  /// Creates a widget that on tap, hides the keyboard.
  const KeyboardHider({
    required this.child,
    this.mode = HideMode.unfocus,
    Key? key,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// How the widget should hide the keyboard.
  ///
  /// By default, [HideMode.unfocus] is used.
  final HideMode mode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        switch (mode) {
          case HideMode.unfocus:
            return unfocus(context);
          case HideMode.hideTextInput:
            return hideTextInput();
        }
      },
      child: child,
    );
  }
}

/// Hide keyboard by un-focusing the current context's [FocusScopeNode].
void unfocus(BuildContext context) => FocusScope.of(context).unfocus();

/// Hide keyboard by invoking the "TextInput.hide" method on
/// [SystemChannels.textInput].
Future<void> hideTextInput() => textInput.invokeMethod('TextInput.hide');

MethodChannel? _textInput;

@visibleForTesting
MethodChannel get textInput => _textInput ?? SystemChannels.textInput;

@visibleForTesting
set textInput(MethodChannel? v) => _textInput = v;
