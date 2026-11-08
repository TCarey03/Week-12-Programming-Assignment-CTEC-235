Phase 1: Theme Settings with SharedPreferences

The purpose of the ?? operator is to provide a default value if something is null. In my program, I used ?? false so the app starts in Light Mode if no Dark Mode preference has been saved yet.

Without the ?? false, Dart would give an error because getBool() can return null, but a non-nullable boolean cannot store null.

--------------

Phase 2: Note File Storage & Console Inspection

Testing file writes with a console print button helps me make sure the notes are actually being saved correctly before adding more features to the app.

The NoteStorage helper class keeps the file operations separate from the user interface. This makes the code easier to organize, understand, and maintain. It also allows me to reuse the methods whenever I need to save or read notes.

--------------

Phase 3: Restoring & Displaying Notes in the UI

When an application tries to read a file that does not exist, it can cause an exception. I used a try/catch block to handle this situation so the app does not crash.

If the file does not exist yet, my program returns an empty string instead. I also added a feature that automatically loads saved notes when the app starts. The saved note now appears in a display card and updates whenever I save a new note.

--------------

Phase 4: Validation & Reflection

During testing, I verified that the Dark Mode setting stays saved after restarting the application. I also tested saving notes, printing the file contents to the console, and restoring saved notes when reopening the app.

One important thing I learned was how to use try/catch to handle file errors and prevent the application from crashing when a file does not exist.

I also learned how SharedPreferences and file storage serve different purposes. SharedPreferences is useful for saving small settings, while file storage is better for saving larger text content like notes.

Overall, this assignment helped me understand how Flutter applications can save and restore information between sessions.
