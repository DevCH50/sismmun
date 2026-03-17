import 'package:flutter/material.dart';
import 'package:sismmun/src/data/dataSource/local/SharedPref.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';

/// Drawer lateral principal de la pantalla Home.
///
/// Muestra el nombre del usuario autenticado, las versiones de la app y la API,
/// y el botón para cerrar sesión.
class HomeDrawer extends StatelessWidget {
  /// Callback que se ejecuta cuando el usuario confirma cerrar sesión
  final VoidCallback onLogout;

  const HomeDrawer({super.key, required this.onLogout});

  /// Lee la sesión guardada localmente para mostrar los datos del usuario
  Future<AuthResponse?> _getSession() async {
    final sharedPref = SharedPref();
    final data = await sharedPref.read('user');
    if (data != null) {
      return AuthResponse.fromJson(data);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<AuthResponse?>(
        future: _getSession(),
        builder: (context, snapshot) {
          final authResponse = snapshot.data;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Encabezado con gradiente rojo corporativo y datos del usuario
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 94, 1, 1), Color.fromARGB(255, 164, 2, 2)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.account_circle, size: 60, color: Colors.white),
                        Image.asset('assets/img/favicon-512-512.png', width: 60, height: 60),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      authResponse?.user.fullName ?? 'Usuario',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),

              // Información de versiones de app y API
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Versiones'),
                subtitle: Text(
                  'App: ${authResponse?.appVersion ?? 'N/A'}\nAPI: ${authResponse?.apiVersion ?? 'N/A'}',
                ),
              ),
              const Divider(),

              // Opción para cerrar sesión
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Cerrar Sesion'),
                onTap: () {
                  Navigator.pop(context);
                  onLogout();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
