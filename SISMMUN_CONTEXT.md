# SisMMun - Contexto del Proyecto

## Descripción

Aplicación móvil Flutter para gestión de servicios municipales. Plataformas: Android e iOS.

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

### AppTheme + Material Theme Builder (2026-03-18) ✅ APROBADO
- **Ubicación:** `lib/src/core/theme/`
  - `material_theme.dart` — ColorScheme completo light/dark generado con Material Theme Builder
  - `app_theme.dart` — ThemeData completo con todos los componentes (AppBar, botones, inputs, cards, dialogs, FAB, ListTile, Divider, SnackBar, ProgressIndicator, Checkbox, Switch, NavigationBar)
- **Uso en main.dart:**
  ```dart
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
  ```
- **Regla obligatoria:** Nunca usar colores hardcodeados (`Colors.red`, etc.). Siempre `Theme.of(context).colorScheme`.

### Mejoras Login (2026-03-18) ✅ APROBADO
- **LoginPage** — Teclado ya no oculta el botón "Iniciar Sesión":
  - Fondo (`LoginBackGround`) vive fuera del Scaffold en un Stack raíz
  - `Scaffold(resizeToAvoidBottomInset: true)` encoge el body cuando aparece el teclado
  - `ScrollController` + `_scrollAlFinal()` con `addPostFrameCallback` anima hasta `maxScrollExtent`
  - `SingleChildScrollView` con `keyboardDismissBehavior.onDrag`
- **LoginContent** — Eliminados: "¿Olvidaste tu contraseña?", "¿No tienes una cuenta?"
- **LogoRedondoUno** — Tamaño reducido 35%: de 150×150 → 98×98
- **DefaultTextField** — `filled: false` para evitar fondo blanco del AppTheme; `enableIMEPersonalizedLearning: false` para suprimir Teclado Seguro Samsung
- **PrimaryElevatedButton** — Color del texto adaptativo con `ThemeData.estimateBrightnessForColor()` para garantizar legibilidad siempre

### Corrección de colores hardcodeados (2026-03-18) ✅ APROBADO
Todos los `Colors.X` reemplazados con `Theme.of(context).colorScheme` en:
- `SolicitudItem.dart` — grey/orange/blue/green/white → `onSurfaceVariant`/`tertiary`/`primary`/`onPrimary`
- `SolicitudGaleria.dart` — grey/blue → `onSurfaceVariant`/`primary`
- `SolicitudMiniatura.dart` — grey/red → `outlineVariant`/`errorContainer`/`error`/`onSurfaceVariant`; etiqueta tipo_foto con color semántico
- `ImageMetadataSheet.dart` — grises → colorScheme; typo "Observaciónes" → "Observaciones"
- `MultiImageMetadataSheet.dart` — black54/white → `onSurface`/`surface`
- `HomePage.dart` — orange/red/white → `tertiary`/`error`/`onError`

### ApiConfig.fixImageUrl() aplicado (2026-03-18) ✅ APROBADO
- `SolicitudMiniatura.dart` — `ApiConfig.fixImageUrl(imagen.urlThumb)` en `Image.network`
- `VisorImagenesCompleto.dart` — `ApiConfig.fixImageUrl(imagen.urlImagen)` en `Image.network`
- Resuelve el problema de URLs `localhost:8000` que los dispositivos físicos no pueden resolver en debug

### SolicitudMiniatura — Etiqueta tipo_foto (2026-03-18) ✅ APROBADO
- Overlay `Stack`+`Positioned` en la parte inferior de cada miniatura
- Color semántico: "después" → `cs.primary`, "antes" → `cs.secondary`
- SafeArea aplicado en `VisorImagenesCompleto` para notch iOS

### Inicialización correcta del contador de imágenes (2026-03-18) ✅ APROBADO
- `SolicitudItem.initState()` ahora cuenta las imágenes existentes con `tipo_foto == 'después'/'despues'`
- El botón "Marcar como Atendida" se habilita correctamente al cargar solicitudes que ya tienen imágenes
