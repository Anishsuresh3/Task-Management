import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskm/home.dart';

import 'Models/data/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Define a TextEditingController
  final TextEditingController _controller = TextEditingController();
  bool _isEditable = false; // State variable to track if the text is editable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editable Text Fields'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display TextField with initial content
            TextField(
              controller: _controller,
              enabled: _isEditable, // Set enabled based on the editable state
              decoration: InputDecoration(
                labelText: 'Enter Text',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0), // Add some spacing
            // Display Button to toggle editable state
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditable = !_isEditable; // Toggle editable state
                  if (!_isEditable) {
                    // Clear focus to hide the keyboard when not editable
                    FocusScope.of(context).unfocus();
                  }
                });
              },
              child: Text(_isEditable ? 'Save' : 'Edit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the TextEditingController when the widget is disposed
    _controller.dispose();
    super.dispose();
  }
}