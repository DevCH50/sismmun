import 'dart:async';
import 'package:sismmun/src/core/utils/app_logger.dart';
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
      AppLogger.error('Error en splash: $e', tag: 'Splash');
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
        body: Builder(
          builder: (context) {
            final cs = Theme.of(context).colorScheme;
            final onBg = cs.onPrimary;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [cs.inverseSurface, cs.primary],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLowest,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: cs.shadow.withAlpha(66),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(Icons.camera, size: 60, color: cs.primary),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'SISMMUN',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: onBg,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sistema de Monitoreo Municipal',
                      style: TextStyle(
                        fontSize: 14,
                        color: onBg.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 200,
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: onBg.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(onBg),
                            minHeight: 4,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _statusText,
                            style: TextStyle(
                              color: onBg.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(_progress * 100).toInt()}%',
                            style: TextStyle(
                              color: onBg.withValues(alpha: 0.54),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
