/// Strings de la aplicación SisMMun.
///
/// Centraliza todos los textos utilizados en la app para
/// facilitar el mantenimiento y futura internacionalización.
class AppStrings {
  AppStrings._();

  // ============================================================================
  // GENERAL
  // ============================================================================

  static const String appName = 'SisMMun';
  static const String appDescription = 'Sistema Municipal de Mantenimiento';

  // ============================================================================
  // SPLASH
  // ============================================================================

  static const String splashInitializing = 'Inicializando...';
  static const String splashConfiguring = 'Configurando...';
  static const String splashVerifyingSession = 'Verificando sesión...';
  static const String splashReady = 'Listo';

  // ============================================================================
  // LOGIN
  // ============================================================================

  static const String loginTitle = 'Iniciar Sesión';
  static const String loginUsername = 'Usuario';
  static const String loginPassword = 'Contraseña';
  static const String loginButton = 'Ingresar';
  static const String loginNoAccount = '¿No tienes cuenta?';
  static const String loginRegister = 'Regístrate';

  // Validaciones
  static const String loginUsernameRequired = 'Escribe el Nombre de Usuario';
  static const String loginPasswordRequired = 'Ingresa la Contraseña';
  static const String loginPasswordMinLength = 'Mínimo 6 caracteres';

  // ============================================================================
  // REGISTRO
  // ============================================================================

  static const String registerTitle = 'REGISTRO';
  static const String registerName = 'Nombre';
  static const String registerLastName = 'Apellido Paterno';
  static const String registerSecondLastName = 'Apellido Materno';
  static const String registerPhone = 'Celular';
  static const String registerEmail = 'Email';
  static const String registerPassword = 'Contraseña';
  static const String registerConfirmPassword = 'Confirmar Contraseña';
  static const String registerButton = 'Guardar';

  // ============================================================================
  // HOME / SOLICITUDES
  // ============================================================================

  static const String homeLoading = 'Cargando solicitudes...';
  static const String homeNoSolicitudes = 'No hay solicitudes registradas';
  static const String homeRefresh = 'Actualizar';
  static const String homeRetry = 'Reintentar';
  static const String homeError = 'Error al cargar';
  static const String homeSearchHint = 'Buscar solicitud...';

  // ============================================================================
  // IMÁGENES
  // ============================================================================

  static const String imagenSubiendo = 'Subiendo imagen...';
  static const String imagenExito = 'Imagen subida correctamente';
  static const String imagenError = 'Error al subir la imagen';
  static const String imagenSeleccionarFuente = 'Seleccionar fuente';
  static const String imagenCamara = 'Cámara';
  static const String imagenGaleria = 'Galería';
  static const String imagenObservacion = 'Observación';
  static const String imagenObservacionHint = 'Escribe una observación...';
  static const String imagenObservacionRequired = 'La observación es obligatoria';
  static const String imagenTipoAntes = 'Antes';
  static const String imagenTipoDespues = 'Después';

  // ============================================================================
  // LOGOUT
  // ============================================================================

  static const String logoutTitle = 'Cerrar Sesión';
  static const String logoutMessage = '¿Estás seguro que deseas cerrar sesión?';
  static const String logoutConfirm = 'Cerrar Sesión';
  static const String logoutCancel = 'Cancelar';

  // ============================================================================
  // ERRORES
  // ============================================================================

  static const String errorNoSession = 'No hay sesión activa';
  static const String errorNoUserId = 'No se encontró el ID de usuario en la sesión';
  static const String errorNoToken = 'No se encontró el token de autenticación';
  static const String errorConnection = 'Sin conexión, intente más tarde';
  static const String errorUnexpected = 'Error inesperado';
  static const String errorInvalidCredentials = 'Credenciales incorrectas o acceso denegado';
  static const String errorTimeout = 'Tiempo de espera agotado. Verifica tu conexión.';
  static const String errorConnectionRetry = 'Error de conexión. Intenta de nuevo.';
}
