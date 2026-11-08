import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

// Handles saving and reading notes
class NoteStorage {
  // Get the application documents folder
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get the notes file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.txt');
  }

  // Save note to file
  Future<File> writeNote(String text) async {
    final file = await _localFile;
    return file.writeAsString(text);
  }

  // Read note from file
  Future<String> readRawContent() async {
    final file = await _localFile;
    return file.readAsString();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  final NoteStorage _noteStorage = NoteStorage();
  final TextEditingController _noteController =
      TextEditingController();

  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load saved theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Update and save theme preference
  Future<void> _updateTheme(bool newValue) async {
    setState(() {
      _isDarkMode = newValue;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
  }

  // Save note
  Future<void> _saveNote() async {
    try {
      await _noteStorage.writeNote(_noteController.text);

      setState(() {
        _statusMessage = 'Note saved to disk!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving note: $e';
      });
    }
  }

  // Print saved note to debug console
  Future<void> _printNote() async {
    try {
      final content = await _noteStorage.readRawContent();

      debugPrint('Saved Note Contents:');
      debugPrint(content);

      setState(() {
        _statusMessage = 'Note printed to debug console!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error reading note: $e';
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Persistent Notes App',
      theme: _isDarkMode
          ? ThemeData.dark()
          : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Persistent Notes App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: _isDarkMode,
                onChanged: _updateTheme,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Type your notes here...',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Save Note'),
              ),

              OutlinedButton(
                onPressed: _printNote,
                child: const Text('Print File to Console'),
              ),

              const SizedBox(height: 15),

              Text(_statusMessage),
            ],
          ),
        ),
      ),
    );
  }
}
