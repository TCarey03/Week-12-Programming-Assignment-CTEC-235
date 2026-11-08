import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

// Handles saving and reading notes
class NoteStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.txt');
  }

  // Save note to file
  Future<File> writeNote(String text) async {
    final file = await _localFile;
    return file.writeAsString(text);
  }

  // Read note safely
  Future<String> readNote() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      debugPrint('Error reading note: $e');
      return '';
    }
  }

  // Read raw content for console
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
  String _savedNote = '';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadSavedNote();
  }

  // Load theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Update theme preference
  Future<void> _updateTheme(bool newValue) async {
    setState(() {
      _isDarkMode = newValue;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
  }

  // Load saved note when app starts
  Future<void> _loadSavedNote() async {
    final note = await _noteStorage.readNote();

    if (!mounted) return;

    setState(() {
      _savedNote = note;
      _noteController.text = note;
    });
  }

  // Save note and update display
  Future<void> _saveNote() async {
    try {
      final note = _noteController.text;

      await _noteStorage.writeNote(note);

      setState(() {
        _savedNote = note;
        _statusMessage = 'Note saved successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving note: $e';
      });
    }
  }

  // Print note to console
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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

              const SizedBox(height: 20),

              Text(
                'Saved Note:',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _savedNote.isEmpty
                        ? 'No notes saved yet.'
                        : _savedNote,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _statusMessage,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
