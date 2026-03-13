# SisMMun - Aplicación de Servicio de Sistemas Municipaes

## Descripción

Aplicación móvil Flutter para gestión de servicios municipales. Plataformas: Android e iOS.

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

## Arquitectura

Clean Architecture con BLoC pattern:

```
lib/src/
├── core/           # Utilidades, constantes, extensiones
├── data/           # Repositorios, datasources, modelos
├── di/             # Inyección de dependencias (get_it + injectable)
├── domain/         # Entidades, casos de uso, interfaces
└── presentation/   # Páginas, widgets, BLoCs
```

## Dependencias principales

- **State management:** flutter_bloc
- **DI:** get_it + injectable
- **HTTP:** http
- **Storage local:** shared_preferences
- **Caché imágenes:** cached_network_image
- **Imágenes:** image_picker, flutter_image_compress
- **Ubicación:** geolocator
- **URLs:** url_launcher, share_plus

## Configuración de Permisos (Verificado 2026-03-12)

### Android (AndroidManifest.xml)

```xml
<!-- Red -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<!-- Cámara -->
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>

<!-- Almacenamiento (Android 12 y anteriores) -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>

<!-- Medios (Android 13+) -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>

<!-- Ubicación -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS (Info.plist)

```xml
<!-- Cámara -->
<key>NSCameraUsageDescription</key>
<string>Se requiere acceso a la cámara para tomar fotos.</string>

<!-- Galería -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Se requiere acceso a la biblioteca de fotos para seleccionar imágenes.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Se requiere acceso a la biblioteca de fotos para seleccionar imágenes.</string>

<!-- Ubicación -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Se requiere acceso a la ubicación para registrar dónde se tomó la foto.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Se requiere acceso a la ubicación para registrar dónde se tomó la foto.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Se requiere acceso a la ubicación para registrar dónde se tomó la foto.</string>

<!-- URLs -->
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>https</string>
    <string>http</string>
</array>

<!-- App Store -->
<key>ITSAppUsesNonExemptEncryption</key>
<false/>

<!-- Seguridad de red (solo HTTPS) -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>
```

## Funcionalidades Implementadas

### ResultDialog - Reemplazo de SnackBar/Toast (2026-03-12) ✅ APROBADO
- **Ubicación:** `lib/src/presentation/widgets/ResultDialog.dart`
- **Archivos modificados:**
  - `SolicitudItem.dart` - Diálogos de resultado de subida
  - `ImageMetadataSheet.dart` - Diálogo de validación
  - `HomePage.dart` - Diálogo de resultado BlocListener
  - `LoginContent.dart` - Diálogo de validación de campos

- **Tipos disponibles:**
  - `ResultType.success` - Verde con icono check
  - `ResultType.error` - Rojo con icono error
  - `ResultType.warning` - Naranja con icono advertencia
  - `ResultType.info` - Azul con icono info

- **Uso:**
  ```dart
  await ResultDialog.success(context, message: 'Éxito');
  await ResultDialog.error(context, message: 'Error');
  await ResultDialog.warning(context, message: 'Advertencia');
  ```

### Modal de Metadatos de Imagen (2026-03-12) ✅ APROBADO
- **Ubicación:** `SolicitudItem` al presionar "+ Imagen"
- **Archivos modificados:**
  - `lib/src/domain/models/SubirImagenRequest.dart` - Campos `observacion` y `tipoFoto`
  - `lib/src/presentation/pages/home/widget/ImageMetadataSheet.dart` - Widget nuevo
  - `lib/src/presentation/pages/home/widget/ImageUploaderHelper.dart` - Método `subirImagenConMetadatos`
  - `lib/src/presentation/pages/home/widget/SolicitudItem.dart` - Nuevo flujo `_agregarImagen`
  - `lib/src/data/dataSource/remote/services/SolicitudService.dart` - Envío de nuevos campos

- **Características UX/UI:**
  - Bottom sheet con diseño Material Design 3
  - Vista previa de la imagen seleccionada
  - SegmentedButton para seleccionar Antes/Después
  - Campo de observación con validación
  - Botones con estilos modernos (FilledButton, OutlinedButton)
  - Compatible con tema claro/oscuro
  - Animaciones suaves

- **Flujo:**
  1. Usuario presiona "+ Imagen"
  2. Selecciona cámara o galería
  3. Toma/selecciona la foto
  4. Aparece modal con vista previa
  5. Selecciona Antes/Después
  6. Escribe observación (obligatoria)
  7. Presiona "Subir imagen"

### Buscador de Solicitudes (2026-03-12) ✅ APROBADO
- **Ubicación:** `HomePage` con widget `SearchSolicitudes`
- **Archivos modificados:**
  - `lib/src/presentation/pages/home/bloc/HomeState.dart` - Campos de búsqueda
  - `lib/src/presentation/pages/home/bloc/HomeEvent.dart` - Eventos de búsqueda
  - `lib/src/presentation/pages/home/bloc/HomeBloc.dart` - Lógica de filtrado
  - `lib/src/presentation/pages/home/HomePage.dart` - Integración del buscador
  - `lib/src/presentation/pages/home/widget/SearchSolicitudes.dart` - Widget nuevo

- **Búsqueda por:**
  - `solicitud_id` (ID de denuncia)
  - `servicio_id`
  - `dependencia_id`
  - `estatus_id` (ultimo_estatus_id)
  - Texto en: denuncia, servicio, dependencia, estatus, observaciones

- **Características:**
  - Filtrado local en tiempo real
  - Indicador de resultados
  - Botón para limpiar búsqueda
  - Compatible con tema claro/oscuro

## Reglas del código

- Todo en español (comentarios, commits, documentación)
- Widgets < 200 líneas
- No utilizar más de 3 niveles de anidación de widgets.
- Los widgets deben ser finamente responsivos para Android e iOS.
- Tests obligatorios para features nuevas
- Material Design 3
- Revisa que tengas todos los permisos necesarios tanto para iOS como para Android tanto de manera implicita como explicta.
- Archivos bien comentados
- Guardar todo el progreso en CLAUDE.md
- Guarda todo lo que ya esta aprobado y funcionando bien.
- No borrar nada sin preguntar.
- Asegurate de que todos los widgets y pantallas esten bien optimizados para Android e iOS y en ambos temas, oscuros y claros.
- Para tareas especificas utilizas subagentes, por ejemplo para crear un widget, utilizas un subagente para crear el widget, otro para crear el bloc, otro para crear el evento, otro para crear el estado, etc.
- Debes asegurarte de no romper nada y que se apage estrictamente a las arquitecturas limpias y la inyeccion de dependencias.
- Si tienes dudas, pregunta, antes de proceder.
- Si tienes que crear un nuevo archivo, asegurate de que este bien comentado y que este bien estructurado.
- No Toast, utiliza SnackBar para mostrar mensajes de error o éxito.
