import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show MultiBlocProvider;
import 'package:sismmun/injection.dart';
import 'package:sismmun/src/blocProvider.dart';
import 'package:sismmun/src/core/theme/app_theme.dart';
import 'package:sismmun/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:sismmun/src/presentation/pages/auth/register/RegisterPage.dart';
import 'package:sismmun/src/presentation/pages/home/HomePage.dart';
import 'package:sismmun/src/presentation/pages/splash/SplashPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Bloquear orientación vertical en todas las plataformas
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Ajuste 1: limitar caché de imágenes en RAM ───────────────────────────
  // Máximo 100 entradas o 50 MB, lo que se alcance primero.
  // Evita que cargar muchas fotos de solicitudes sature la memoria.
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

  // ── Ajuste 2: limpiar archivos temporales huérfanos de sesiones previas ──
  // image_picker deja archivos .jpg/.png en el directorio temporal del sistema
  // cuando la app se cierra inesperadamente antes de que se suban.
  // Solo aplica en iOS/Android; solo elimina imágenes > 1 hora de antigüedad.
  _limpiarArchivosTemporalesHuerfanos();

  runApp(const MyApp());
}

/// Elimina archivos de imagen huérfanos del directorio temporal del sistema.
///
/// Aplica únicamente en dispositivos móviles (iOS y Android).
/// Solo borra archivos `.jpg`, `.jpeg` y `.png` con más de 1 hora de
/// antigüedad para no interferir con operaciones activas.
/// Los errores se ignoran silenciosamente: son archivos temporales del OS.
void _limpiarArchivosTemporalesHuerfanos() {
  if (!Platform.isIOS && !Platform.isAndroid) return;

  try {
    final tempDir = Directory.systemTemp;
    if (!tempDir.existsSync()) return;

    final limiteAntiguo = DateTime.now().subtract(const Duration(hours: 1));
    final extensionesImagen = {'.jpg', '.jpeg', '.png'};

    for (final entity in tempDir.listSync(recursive: false)) {
      if (entity is! File) continue;

      final extension = entity.path.split('.').last.toLowerCase();
      if (!extensionesImagen.contains('.$extension')) continue;

      try {
        final modificado = entity.lastModifiedSync();
        if (modificado.isBefore(limiteAntiguo)) {
          entity.deleteSync();
        }
      } catch (_) {
        // Ignorar errores por archivo individual (puede estar en uso).
      }
    }
  } catch (_) {
    // Ignorar errores generales; la limpieza es opcional y no crítica.
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SISMMUN',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routes: {
          'login': (BuildContext context) => const LoginPage(),
          'register': (BuildContext context) => const RegisterPage(),
          'Homes': (BuildContext context) => const HomesPage(),
          'splash': (BuildContext context) => const SplashPage(),
        },
        initialRoute: 'splash',
      ),
    );
  }
}
