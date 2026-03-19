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
- Siempre sube los cambios a github remoto con el arhivo mygit_1.sh, pero solo cuando yo te lo indique.
- Asegurate de que todos los modulos tengan su test y que todos pasen satisfactoriamente. Si alguno no lo tiene, creaselo.
- Asegurate de seguir al pie de la letra las reglas de este .md
- Para tareas especifica, usa subagentes que te ayuden a resolver mas rápido.
- Usar siempre `Endpoints` para los paths del API (no strings hardcodeados)
- Usar siempre `AppStrings` para los textos de error y UI
- Usar siempre `AppDurations` para timeouts y duraciones
- Usar siempre `AppLogger` en lugar de `print` o `kDebugMode print`
- Nunca usar colores hardcodeados (`Colors.red`, `Colors.green`, `Colors.grey`, etc.). Usar siempre `Theme.of(context).colorScheme` para todos los colores de la UI
- Cuando el usuario tenga que interacturar con algun método o evento, que pregunte si desea hacer x cosas, con la opcion No o Cancelar como predeterminada.

---

## Tareas Terminadas ✅

| Fecha | Tarea |
|---|---|
| 2026-03-12 | ResultDialog: Reemplazo de SnackBar/Toast con tipos success/error/warning/info |
| 2026-03-12 | Modal de metadatos de imagen (observación, tipo Antes/Después) |
| 2026-03-12 | Buscador de solicitudes con filtrado local en tiempo real |
| 2026-03-17 | Corrección de bugs críticos iOS/Android + 60 tests |
| 2026-03-17 | Configurar firma release y applicationId para Google Play Store |
| 2026-03-18 | Buenas prácticas de arjipagos: `endpoints.dart`, `AppLogger`, `AppStrings`, `AppDurations`, `ApiConfig` mejorado |

---

## Próximas Tareas 📋

### 1. Subida múltiple de imágenes desde galería

**Descripción:** Actualmente el usuario solo puede seleccionar una imagen por vez. Se debe permitir seleccionar múltiples imágenes del carrete en una sola operación.

**Alcance Flutter:**
- Modificar `ImageUploaderHelper` para aceptar selección múltiple usando `ImagePicker` con `pickMultiImage()`
- Modificar `ImageMetadataSheet` para mostrar previsualizaciones de múltiples imágenes (carrusel o grid)
- Modificar `SolicitudItem` para encolar y subir las imágenes secuencialmente o en paralelo
- Agregar indicador de progreso con contador (ej: "Subiendo 2 de 5...")
- Manejar errores parciales (si una falla, continuar con las demás)

**Dependencias Flutter ya disponibles:** `image_picker` ya está en `pubspec.yaml`

**Endpoint a usar:** `Endpoints.agregarImagen` (se llama N veces, una por imagen)

**Documentación para el backend (ServiMun - Laravel 7, PHP 7.4):**

El backend recibe **una imagen por petición** (no multipart batch). Para subir múltiples imágenes, el cliente Flutter hace varias llamadas al mismo endpoint:

```
POST /api/v1/denuncia/agregar/imagen
Authorization: Bearer {token}
Content-Type: application/json

{
  "user_id": 123,
  "denuncia_id": 456,
  "dependencia_id": 789,
  "estatus_id": 101,
  "servicio_id": 202,
  "solo_imagen": 0,
  "imagen": "{base64_de_la_imagen}",
  "latitud": 18.0,
  "longitud": -93.0,
  "observacion": "Descripción de la imagen",
  "tipo_foto": "antes"   // o "despues"
}
```

**Respuesta esperada del backend:**
```json
{
  "status": 1,
  "msg": "Imagen guardada correctamente",
  "url_imagen": "https://siac.villahermosa.gob.mx/storage/...",
  "url_thumb": "https://siac.villahermosa.gob.mx/storage/..."
}
```

**No se requieren cambios en el backend** para la subida múltiple, ya que Flutter realiza llamadas secuenciales al mismo endpoint existente.

---

### 2. Notificaciones Push desde el backend

**Descripción:** Implementar recepción de notificaciones push enviadas directamente desde el backend ServiMun.

**Alcance Flutter:**
- Integrar `firebase_messaging` (FCM) o alternativa como `flutter_local_notifications`
- Registrar el token del dispositivo y enviarlo al servidor en el login
- Manejar notificaciones en primer plano, segundo plano y con app cerrada
- Mostrar notificación con `ResultDialog` o `flutter_local_notifications` según corresponda
- Guardar historial de notificaciones localmente con `shared_preferences`

**Permisos necesarios:**

Android (`AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

iOS (`Info.plist`): Solicitar permiso en runtime con `firebase_messaging`.

**Documentación para el backend (ServiMun - Laravel 7, PHP 7.4):**

El backend necesita:

1. **Nuevo campo en tabla `users`:** `fcm_token` (string, nullable)

   ```sql
   ALTER TABLE users ADD COLUMN fcm_token VARCHAR(255) NULL;
   ```

2. **Endpoint para registrar el token del dispositivo:**

   ```
   POST /api/v1/usuario/fcm-token
   Authorization: Bearer {token}
   Content-Type: application/json

   {
     "user_id": 123,
     "fcm_token": "dGhpcyBpcyBhIHRlc3QgdG9rZW4..."
   }
   ```

3. **Servicio para enviar notificaciones** (usando Firebase Admin SDK o HTTP v1 API):

   ```php
   // Ejemplo en PHP usando cURL
   $url = 'https://fcm.googleapis.com/v1/projects/{PROJECT_ID}/messages:send';
   $headers = [
     'Authorization: Bearer ' . $accessToken,
     'Content-Type: application/json',
   ];
   $data = [
     'message' => [
       'token' => $fcmToken,
       'notification' => [
         'title' => 'SisMMun',
         'body' => 'Tu solicitud #123 fue actualizada',
       ],
       'data' => [
         'solicitud_id' => '123',
         'tipo' => 'actualizacion',
       ],
     ],
   ];
   ```

4. **Disparar notificación** cuando cambia el estatus de una denuncia:
   - En el controlador o modelo `Denuncia`, al guardar un nuevo estatus,
     buscar el `fcm_token` del usuario dueño y enviar la notificación.

**Referencias:**
- Firebase Console: https://console.firebase.google.com
- FCM HTTP v1 API: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages/send