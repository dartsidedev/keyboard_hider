import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_hider/keyboard_hider.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group(KeyboardHider, () {
    group('in ${HideMode.unfocus} mode', () {
      testWidgets(
          'focused node loses focus when any widget without a gesture detector is tapped',
          (t) async {
        // MaterialApp is necessary for the FocusScope to work
        await t.pumpWidget(
          MaterialApp(
            home: KeyboardHider(
              mode: HideMode.unfocus,
              child: Column(
                children: const [
                  Text('unfocus!', textDirection: TextDirection.ltr),
                  TestFocusScope(name: 'a'),
                ],
              ),
            ),
          ),
        );
        // Initially, nothing is focused
        expect(find.text('a (not focused)'), findsOneWidget);
        // Tap on TestFocusScope to request focus
        await t.tapAndPump(find.byType(TestFocusScope));
        expect(find.text('A (FOCUSED)'), findsOneWidget);
        // Tap on widget without an on-tap handler to remove focus from TestFocusScope
        await t.tapAndPump(find.text('unfocus!'));
        expect(find.text('a (not focused)'), findsOneWidget);
        // Tap on TestFocusScope to request focus again
        await t.tapAndPump(find.byType(TestFocusScope));
        expect(find.text('A (FOCUSED)'), findsOneWidget);
        // Tap on widget without an on-tap handler to remove focus from TestFocusScope again
        await t.tapAndPump(find.text('unfocus!'));
        expect(find.text('a (not focused)'), findsOneWidget);
      });

      testWidgets('can switch between focus nodes and still unfocus',
          (t) async {
        // MaterialApp is necessary for the FocusScope to work
        await t.pumpWidget(
          MaterialApp(
            home: KeyboardHider(
              mode: HideMode.unfocus,
              child: Column(
                children: const [
                  TestFocusScope(name: 'a'),
                  Text('unfocus!', textDirection: TextDirection.ltr),
                  TestFocusScope(name: 'b'),
                ],
              ),
            ),
          ),
        );
        // Initially, nothing is focused
        expect(find.text('a (not focused)'), findsOneWidget);
        expect(find.text('b (not focused)'), findsOneWidget);
        // Tap on A to request focus
        await t.tapAndPump(find.text('a (not focused)'));
        expect(find.text('A (FOCUSED)'), findsOneWidget);
        expect(find.text('b (not focused)'), findsOneWidget);
        // Tap on B to request focus
        await t.tapAndPump(find.text('b (not focused)'));
        expect(find.text('a (not focused)'), findsOneWidget);
        expect(find.text('B (FOCUSED)'), findsOneWidget);
        // Tap on widget without an on-tap handler to remove focus
        await t.tapAndPump(find.text('unfocus!'));
        expect(find.text('a (not focused)'), findsOneWidget);
        expect(find.text('b (not focused)'), findsOneWidget);
        // Tap on A to request focus again
        await t.tapAndPump(find.text('a (not focused)'));
        expect(find.text('A (FOCUSED)'), findsOneWidget);
        expect(find.text('b (not focused)'), findsOneWidget);
        // Tap on widget without an on-tap handler to remove focus again
        await t.tapAndPump(find.text('unfocus!'));
        expect(find.text('a (not focused)'), findsOneWidget);
        expect(find.text('b (not focused)'), findsOneWidget);
      });
    });

    group('in ${HideMode.hideTextInput} mode', () {
      testWidgets(
          'calls SystemChannels.textInput method channel to hide the keyboard',
          (t) async {
        final mockTextInput = MockMethodChannel()
          ..stubHideTextInput()
          ..use((mockTextInput) => textInput = mockTextInput);
        await t.pumpWidget(
          MaterialApp(
            home: KeyboardHider(
              mode: HideMode.hideTextInput,
              child: Column(
                children: const [
                  Text('hide input!', textDirection: TextDirection.ltr),
                  TestFocusScope(name: 'a'),
                ],
              ),
            ),
          ),
        );
        // Initially, nothing is focused
        expect(find.text('a (not focused)'), findsOneWidget);
        // Tap on TestFocusScope to request focus (this is when the text input would open with a text field)
        await t.tapAndPump(find.byType(TestFocusScope));
        expect(find.text('A (FOCUSED)'), findsOneWidget);
        // Tap on widget without an on-tap handler to trigger hiding the textInput
        await t.tapAndPump(find.text('hide input!'));
        // Verify mock was called
        mockTextInput.verifyHideTextInput();
        // The focused element in case of HideMode.hideTextInput stays in focus
        expect(find.text('A (FOCUSED)'), findsOneWidget);
      });
    });
  });

  group('unfocus', () {
    testWidgets(
        'focused node loses focus when any widget without a gesture detector is long pressed',
        (t) async {
      // MaterialApp is necessary for the FocusScope to work
      await t.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onLongPress: () => unfocus(context),
                    child: const Text(
                      'unfocus!',
                      textDirection: TextDirection.ltr,
                    ),
                  );
                },
              ),
              const TestFocusScope(name: 'a'),
            ],
          ),
        ),
      );
      // Initially, nothing is focused
      expect(find.text('a (not focused)'), findsOneWidget);
      // Tap on TestFocusScope to request focus
      await t.tapAndPump(find.byType(TestFocusScope));
      expect(find.text('A (FOCUSED)'), findsOneWidget);
      // Long press on widget without an on-tap handler to remove focus from TestFocusScope
      await t.longPressAndPump(find.text('unfocus!'));
      expect(find.text('a (not focused)'), findsOneWidget);
      // // Tap on TestFocusScope to request focus again
      await t.tapAndPump(find.text('a (not focused)'));
      expect(find.text('A (FOCUSED)'), findsOneWidget);
      // // Tap on widget without an on-tap handler to remove focus from TestFocusScope again
      await t.longPressAndPump(find.text('unfocus!'));
      expect(find.text('a (not focused)'), findsOneWidget);
    });
  });

  group('hideTextInput', () {
    test('invokes "TextInput.hide" on the textInput method channel', () async {
      final mockTextInput = MockMethodChannel()
        ..stubHideTextInput()
        ..use((mockTextInput) => textInput = mockTextInput);
      await hideTextInput();
      mockTextInput.verifyHideTextInput();
    });
  });
}

class MockMethodChannel extends Mock implements MethodChannel {
  void stubHideTextInput() {
    when(() => invokeMethod('TextInput.hide')).thenAnswer((_) async => null);
  }

  void verifyHideTextInput() {
    verify(() => invokeMethod('TextInput.hide')).called(1);
  }
}

extension<T extends Object> on T {
  use(void Function(T v) fn) => fn(this);
}

extension on WidgetTester {
  Future tapAndPump(Finder f) => tap(f).then((_) => pump());

  Future longPressAndPump(Finder f) => longPress(f).then((_) => pump());
}

class TestFocusScope extends StatefulWidget {
  const TestFocusScope({
    required this.name,
    Key? key,
  }) : super(key: key);

  final String name;

  @override
  TestFocusScopeState createState() => TestFocusScopeState();
}

class TestFocusScopeState extends State<TestFocusScope> {
  late final FocusScopeNode node;
  late String label;

  @override
  void initState() {
    super.initState();
    node = FocusScopeNode();
    label = _label;
    node.addListener(updateLabel);
  }

  @override
  void dispose() {
    node.removeListener(updateLabel);
    node.dispose();
    super.dispose();
  }

  String get _label => node.hasFocus
      ? '${widget.name.toUpperCase()} (FOCUSED)'
      : '${widget.name.toLowerCase()} (not focused)';

  void updateLabel() => setState(() => label = _label);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(node),
      child: FocusScope(
        node: node,
        child: Text(label, textDirection: TextDirection.ltr),
      ),
    );
  }
}
