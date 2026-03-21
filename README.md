# SisMMun

**Sistema de Servicios Municipales**

Aplicación móvil desarrollada para la gestión de servicios municipales. Permite a los usuarios reportar y dar seguimiento a solicitudes de servicios como baches, alumbrado público, recolección de basura, entre otros.

## Plataformas

- Android
- iOS

## Características

- **Gestión de Solicitudes:** Visualiza y administra solicitudes de servicios municipales asignadas
- **Captura de Evidencias:** Toma fotografías con metadatos (tipo de foto, observaciones, ubicación GPS)
- **Búsqueda Avanzada:** Filtra solicitudes por ID, servicio, dependencia, estatus u observaciones
- **Notificaciones Visuales:** Diálogos de resultado para feedback claro al usuario
- **Tema Claro/Oscuro:** Soporte completo para ambos temas del sistema

## Arquitectura

El proyecto implementa **Clean Architecture** con el patrón **BLoC** para el manejo de estados:

```
lib/src/
├── core/           # Utilidades, constantes, extensiones
├── data/           # Repositorios, datasources, modelos
├── di/             # Inyección de dependencias (get_it + injectable)
├── domain/         # Entidades, casos de uso, interfaces
└── presentation/   # Páginas, widgets, BLoCs
```

## Tecnologías

- **Framework:** Flutter
- **State Management:** flutter_bloc
- **Inyección de Dependencias:** get_it + injectable
- **HTTP Client:** http
- **Storage Local:** shared_preferences
- **Caché de Imágenes:** cached_network_image
- **Captura de Imágenes:** image_picker, flutter_image_compress
- **Geolocalización:** geolocator

## Requisitos

- Flutter SDK 3.x
- Dart 3.x
- Android SDK (para Android)
- Xcode (para iOS)

## Licencia

Proyecto privado - Todos los derechos reservados.
