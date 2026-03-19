import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sismmun/src/core/constants/app_strings.dart';
import 'package:sismmun/src/data/api/ApiConfig.dart';
import 'package:sismmun/src/data/dataSource/local/SharedPref.dart';
import 'package:sismmun/src/domain/models/AuthResponse.dart';
import 'package:sismmun/src/domain/models/User.dart';
import 'package:sismmun/src/presentation/pages/home/widget/UserAvatar.dart';

/// Drawer lateral principal de la pantalla Home.
///
/// Muestra la foto de perfil, nombre completo y campos copiables
/// (username, email, celulares) del usuario autenticado.
class HomeDrawer extends StatelessWidget {
  /// Callback que se ejecuta cuando el usuario confirma cerrar sesión
  final VoidCallback onLogout;

  const HomeDrawer({super.key, required this.onLogout});

  /// Lee la sesión guardada localmente para mostrar los datos del usuario
  Future<AuthResponse?> _getSession() async {
    final sharedPref = SharedPref();
    final data = await sharedPref.read('user');
    if (data != null) return AuthResponse.fromJson(data);
    return null;
  }

  /// Construye la URL completa del avatar a partir del filename del backend.
  String? _avatarUrl(dynamic filenameThumb) {
    if (filenameThumb == null || filenameThumb.toString().isEmpty) return null;
    final base = ApiConfig.isProduction
        ? 'https://${ApiConfig.remoteUrl}'
        : 'http://${ApiConfig.localUrl}';
    return '$base/storage/profile/${filenameThumb.toString()}';
  }

  /// Copia [texto] al portapapeles y muestra confirmación breve.
  void _copiar(BuildContext context, String texto) {
    Clipboard.setData(ClipboardData(text: texto));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.drawerCopiado(texto)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<AuthResponse?>(
        future: _getSession(),
        builder: (context, snapshot) {
          final authResponse = snapshot.data;
          final user = authResponse?.user;
          final cs = Theme.of(context).colorScheme;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // ── Encabezado ──────────────────────────────────────────────
              _buildHeader(context, user, cs),

              // ── Campos copiables ────────────────────────────────────────
              if (user != null) ..._buildCamposCopiables(context, user, cs),

              const Divider(),

              // ── Versiones ───────────────────────────────────────────────
              ListTile(
                leading: Icon(Icons.info_outline, color: cs.onSurfaceVariant),
                title: const Text(AppStrings.drawerVersiones),
                subtitle: Text(
                  'App: ${authResponse?.appVersion ?? 'N/A'}\n'
                  'API: ${authResponse?.apiVersion ?? 'N/A'}',
                ),
              ),
              const Divider(),

              // ── Cerrar sesión ────────────────────────────────────────────
              ListTile(
                leading: Icon(Icons.logout, color: cs.error),
                title: Text(AppStrings.logoutTitle, style: TextStyle(color: cs.error)),
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

  // ── Widgets privados ──────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, User? user, ColorScheme cs) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, cs.primaryContainer],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar con foto o inicial
                UserAvatar(
                  urlPhoto: _avatarUrl(user?.filenameThumb),
                  nombre: user?.fullName ?? '',
                  radius: 32,
                  showBorder: true,
                ),
                Image.asset(
                  'assets/img/favicon-512-512.png',
                  width: 48,
                  height: 48,
                ),
              ],
            ),
            const Spacer(),
            Text(
              user?.fullName ?? 'Usuario',
              style: TextStyle(
                color: cs.onPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Genera los ListTile copiables para username, email y celulares.
  List<Widget> _buildCamposCopiables(
      BuildContext context, User user, ColorScheme cs) {
    final campos = <_CampoCopiable>[
      if (user.username.isNotEmpty)
        _CampoCopiable(
          icono: Icons.badge_outlined,
          etiqueta: AppStrings.loginUsername,
          valor: user.username,
        ),
      if (user.email.isNotEmpty)
        _CampoCopiable(
          icono: Icons.email_outlined,
          etiqueta: AppStrings.registerEmail,
          valor: user.email,
        ),
      if (user.celulares.isNotEmpty)
        _CampoCopiable(
          icono: Icons.phone_outlined,
          etiqueta: AppStrings.registerPhone,
          valor: user.celulares,
        ),
    ];

    return campos
        .map(
          (c) => ListTile(
            dense: true,
            leading: Icon(c.icono, color: cs.primary, size: 22),
            title: Text(
              c.etiqueta,
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurfaceVariant,
              ),
            ),
            subtitle: Text(
              c.valor,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.copy, size: 18, color: cs.onSurfaceVariant),
              tooltip: 'Copiar',
              onPressed: () => _copiar(context, c.valor),
            ),
          ),
        )
        .toList();
  }
}

/// Modelo interno para representar un campo copiable del drawer.
class _CampoCopiable {
  final IconData icono;
  final String etiqueta;
  final String valor;
  const _CampoCopiable({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });
}
