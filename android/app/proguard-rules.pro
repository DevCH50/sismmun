# Reglas ProGuard para SisMMun
# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Mantener clases de la aplicación
-keep class mx.gob.villahermosa.sismmun.** { *; }

# Evitar ofuscación de modelos de datos
-keepattributes Signature
-keepattributes *Annotation*

# Suprimir advertencias de Play Core (deferred components)
-dontwarn com.google.android.play.core.**
