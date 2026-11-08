Phase 1: Theme Settings with SharedPreferences

The purpose of the ?? operator is to provide a default value if something is null. In my program, I used ?? false so the app starts in Light Mode if no Dark Mode preference has been saved yet.

Without the ?? false, Dart would give an error because getBool() can return null, but a non-nullable boolean cannot store null.
