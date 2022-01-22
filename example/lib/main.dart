import 'package:flutter/material.dart';
import 'package:keyboard_hider/keyboard_hider.dart';

// It's an example project, we don't care about const and print, it makes
// the code harder to reason about for beginners.
//
// ignore_for_file: prefer_const_constructors, avoid_print

void main() => runApp(const ExampleWidget());

const title = 'keyboard_hider_example';

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const p = EdgeInsets.fromLTRB(16, 8, 16, 8);
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(
          // The app bar is outside of the keyboard hider widget, so if you
          // tap on the app bar title, the keyboard will not be hidden.
          title: const Text(title),
          actions: [
            // Make sure that the context can access a FocusScope.
            // If the keyboard is not hidden, try wrapping it in a builder
            // to get a context that is able to unfocus the current focus scope
            // node.
            Builder(
              builder: (context) => IconButton(
                onPressed: () => unfocus(context),
                icon: const Icon(Icons.keyboard),
              ),
            )
          ],
        ),
        body: KeyboardHider(
          child: ListView(
            children: [
              // If the keyboard is open, you can tap on this text to get
              // rid of the keyboard.
              Text('This is a simple text'),
              // hideTextInput works slightly differently than the unfocus.
              // It will hide the keyboard, but it will not unfocus the
              // focus scope node, so the text field will stay highlighted.
              ElevatedButton(
                onPressed: hideTextInput,
                child: Text('Hide text input'),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'First text field',
                ),
                onChanged: (s) => print('first changed $s'),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Second text field',
                ),
                onChanged: (s) => print('second changed $s'),
              ),
              Text('More text. ' * 20),
            ].map((e) => Padding(padding: p, child: e)).toList(),
          ),
        ),
      ),
    );
  }
}
