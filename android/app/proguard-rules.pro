# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Add project-specific rules here
-keep class com.example.finanzas_personales_app.** { *; }

# Keep all classes that might be used via reflection
-keepattributes *Annotation*
-keepattributes Signature

# Keep all public classes, and their public and protected fields and methods
-keep public class * {
    public protected *;
}

# Keep setters in Views so that animations can still work
-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}

# Keep R classes
-keepclassmembers class **.R$* {
    public static <fields>;
}
