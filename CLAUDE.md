# SisMMun - Instrucciones para el Agente

> Contexto del proyecto, arquitectura y funcionalidades implementadas: ver `SISMMUN_CONTEXT.md`

## Comandos

```bash
# Desarrollo
flutter run                              # Ejecutar app
flutter pub get                          # Instalar dependencias
flutter pub run build_runner build       # Generar código (injectable)

# Tests
flutter test                             # Ejecutar todos los tests
flutter test --coverage                  # Tests con cobertura

# Build
flutter build apk --release              # APK para Android
flutter build ios --release              # Build para iOS

# Release (script automatizado)
./scripts/release.sh                     # Build APK
./scripts/release.sh 1.2.0               # Build con nueva versión
./scripts/release.sh --install           # Build e instalar en dispositivo
./scripts/release.sh 1.2.0 --install     # Build, versión e instalar
./scripts/release.sh 1.2.0 --bundle      # Build APK + App Bundle (Play Store)

# Utilidades
flutter pub run flutter_launcher_icons   # Regenerar iconos
flutter pub run flutter_native_splash:create  # Regenerar splash

# Git
./mygit_1.sh "mensaje del commit"        # Subir cambios a GitHub
```

## Instrucciones para Release (Agente)

**Cuando el usuario diga:** "nueva versión", "release", "sube versión", "build release", "genera APK"

**Ejecutar estos comandos en paralelo:**

```bash
# 1. Build APK (en paralelo)
flutter build apk --release

# 2. Build App Bundle (en paralelo)
flutter build appbundle --release
```

**Después de los builds, instalar en dispositivo:**

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

**Si especifica versión** (ej: "nueva versión 1.3.0"):

1. Editar `pubspec.yaml` línea `version:` → `version: 1.3.0+N` (incrementar N)
2. Ejecutar builds e instalar

**Rutas de salida:**

- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

**Verificar antes de release a producción:**

- `ApiConfig.isProduction = true`
- Permiso INTERNET en AndroidManifest.xml

## Reglas del código

- Todo en español (comentarios, commits, documentación)
- Widgets < 200 líneas
- No utilizar más de 3 niveles de anidación de widgets
- Los widgets deben ser finamente responsivos para Android e iOS
- Tests obligatorios para features nuevas
- Material Design 3
- Revisa que tengas todos los permisos necesarios tanto para iOS como para Android
- Archivos bien comentados
- Guardar funcionalidades aprobadas en `SISMMUN_CONTEXT.md`
- No borrar nada sin preguntar
- Asegurate de que todos los widgets y pantallas esten bien optimizados para Android e iOS y en ambos temas, oscuros y claros
- Para tareas especificas utilizas subagentes
- Debes asegurarte de no romper nada y que se apegue estrictamente a Clean Architecture y la inyeccion de dependencias
- Si tienes dudas, pregunta antes de proceder
- Si tienes que crear un nuevo archivo, asegurate de que este bien comentado y estructurado
- No Toast, utiliza ResultDialog para mostrar mensajes de error o éxito
- Siempre sube los cambios a github remoto con el arhivo mygit_1.sh
- Asuegurate de que todos los modulos tengan su test y que todos pasen satisfactoriamente.
- Asegurate de de seguir al pie de la letra las reglas de este .md
- Para tareas especifica, usa subagentes que te ayuden a resolver mas rápido.