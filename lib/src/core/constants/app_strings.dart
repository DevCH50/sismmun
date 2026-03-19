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

  static const String cancelar = 'Cancelar';
  static const String confirmarNo = 'No';
  static const String confirmarSi = 'Sí';
  static const String errorDesconocido = 'Error desconocido';
  static const String preparando = 'Preparando...';

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

  static const String imagenAgregar = '+ Imagen';
  static const String marcarAtendidaBoton = 'Marcar como Atendida';
  static const String marcarAtendidaHint =
      'Sube al menos una foto "Después" para habilitar este botón';
  static const String confirmarEnvioTitulo = 'Confirmar envío';
  static const String confirmarEnvioMensajeUno =
      '¿Desea enviar la imagen seleccionada?';
  static String confirmarEnvioMensajePlural(int n) =>
      '¿Desea enviar las $n imágenes seleccionadas?';
  static const String imagenFuenteTomarFoto = 'Tomar Foto';
  static const String imagenFuenteGaleria = 'Seleccionar de Galería';

  // ============================================================================
  // IMÁGENES
  // ============================================================================

  static const String imagenSubiendo = 'Subiendo imagen...';
  static const String imagenExito = 'Imagen subida correctamente';
  static const String imagenError = 'Error al subir la imagen';
  static const String imagenErrorCargar = 'Error al cargar la imagen';
  static const String imagenSeleccionarFuente = 'Seleccionar fuente';
  static const String imagenCamara = 'Cámara';
  static const String imagenGaleria = 'Galería';
  static const String imagenObservacion = 'Observación';
  static const String imagenObservacionHint = 'Escribe una observación...';
  static const String imagenObservacionRequired = 'La observación es obligatoria';
  static const String imagenTipoAntes = 'Antes';
  static const String imagenTipoDespues = 'Después';
  static const String imagenEliminarConfirmTitulo = 'Eliminar imagen';
  static const String imagenEliminarConfirmMensaje =
      '¿Deseas eliminar esta imagen? Esta acción no se puede deshacer.';
  static const String imagenEliminarExito = 'Imagen eliminada correctamente';
  static const String imagenEliminarError = 'Error al eliminar la imagen';
  static const String imagenSinId =
      'No se puede eliminar esta imagen. Recarga la solicitud e intenta de nuevo.';
  static const String imagenPdfAbrir = 'Abrir PDF';
  static const String imagenPdfCompartir = 'Compartir';
  static const String imagenPdfEtiqueta = 'PDF';

  // ============================================================================
  // DRAWER
  // ============================================================================

  static const String drawerVersiones = 'Versiones';
  static String drawerCopiado(String texto) => 'Copiado: $texto';

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
