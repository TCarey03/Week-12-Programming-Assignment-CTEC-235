Phase 1: Theme Settings with SharedPreferences

The purpose of the ?? operator is to provide a default value if something is null. In my program, I used ?? false so the app starts in Light Mode if no Dark Mode preference has been saved yet.

Without the ?? false, Dart would give an error because getBool() can return null, but a non-nullable boolean cannot store null.

--------------

Phase 2: Note File Storage & Console Inspection

Testing file writes with a console print button helps me make sure the notes are actually being saved correctly before adding more features to the app.

The NoteStorage helper class keeps the file operations separate from the user interface. This makes the code easier to organize, understand, and maintain. It also allows me to reuse the methods whenever I need to save or read notes.
