import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:sismmun/src/domain/utils/Resource.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:sismmun/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _progress = 0.0;
  String _statusText = 'Inicializando...';
  Timer? _progressTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _startProgressAnimation();
    _initializeApp();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startProgressAnimation() {
    // Animación de progreso cada 100ms
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && _progress < 0.9) {
        setState(() {
          _progress += 0.05;
          if (_progress < 0.3) {
            _statusText = 'Inicializando...';
          } else if (_progress < 0.6) {
            _statusText = 'Configurando...';
          } else {
            _statusText = 'Verificando sesión...';
          }
        });
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Las dependencias ya fueron inicializadas en main.dart
      // Esperar brevemente para mostrar la animación
      await Future.delayed(const Duration(milliseconds: 300));

      // Completar progreso
      if (mounted) {
        setState(() {
          _progress = 1.0;
          _statusText = 'Listo';
        });
      }

      // Pequeña pausa al 100% antes de navegar
      await Future.delayed(const Duration(milliseconds: 800));

      // Verificar sesión y navegar
      if (mounted && !_hasNavigated) {
        context.read<LoginBloc>().add(const CheckSession());

        // Dar tiempo al BLoC para procesar la sesión
        await Future.delayed(const Duration(milliseconds: 500));

        // Navegar según el estado actual
        final currentState = context.read<LoginBloc>().state;
        _navigateBasedOnState(currentState);
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error en splash: $e');
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        Navigator.pushReplacementNamed(context, 'login');
      }
    } finally {
      _progressTimer?.cancel();
    }
  }

  void _navigateBasedOnState(LoginState state) {
    if (_hasNavigated) return;
    _hasNavigated = true;

    if (state.response is Success) {
      Navigator.pushNamedAndRemoveUntil(context, 'Homes', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // Listener adicional por si el estado cambia después
        if (!_hasNavigated && _progress >= 1.0) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              _navigateBasedOnState(state);
            }
          });
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 112, 2, 2), Color.fromARGB(255, 229, 30, 30)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.camera, size: 60, color: Color.fromARGB(255, 229, 30, 30)),
                ),
                const SizedBox(height: 48),
                const Text(
                  'SISMMUN',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sistema de Monitoreo Municipal',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 4,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _statusText,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
