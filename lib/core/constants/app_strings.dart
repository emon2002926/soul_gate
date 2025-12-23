import '../util/storage_service.dart';

class AppStrings {
  // Singleton pattern
  static final AppStrings instance = AppStrings._internal();
  factory AppStrings() => instance;
  AppStrings._internal();

  // Language detection
  String get currentLanguage => StorageService.language;
  bool get isEnglish => currentLanguage == 'en';
  bool get isSpanish => currentLanguage == 'es';

  // Helper method to get text in current language
  String _getText(String english, String spanish) {
    return isSpanish ? spanish : english;
  }

  // ========== App Name ==========
  String get appName => "SOULGATE";
  String get appTagline => _getText("TAROT & LIGHT", "TAROT Y LUZ");

  // ========== Language Selection ==========
  String get selectLanguage => _getText("Select Language", "Seleccionar idioma");
  String get english => "English";
  String get spanish => "Español";

  // ========== Authentication ==========
  String get login => _getText("Log in", "Iniciar sesión");
  String get signUp => _getText("Sign Up", "Registrarse");
  String get email => _getText("Email", "Correo electrónico");
  String get password => _getText("Password", "Contraseña");
  String get enterYourEmail => _getText("Enter your email", "Ingresa tu correo electrónico");
  String get enterYourPassword => _getText("Enter your password", "Ingresa tu contraseña");
  String get forgotPassword => _getText("Forgot Password?", "¿Olvidaste tu contraseña?");
  String get dontHaveAccount => _getText("Don't have an account?", "¿No tienes una cuenta?");
  String get alreadyHaveAccount => _getText("Already have an account?", "¿Ya tienes una cuenta?");
  String get createAccount => _getText("Create Account", "Crear cuenta");
  String get createAccountBtn =>
      _getText("Create account", "Crear cuenta");

  String get creatingAccountBtn =>
      _getText("Creating account...", "Creando cuenta...");

  String get confirmPassword => _getText("Confirm Password", "Confirmar contraseña");
  String get fullName => _getText("Full Name", "Nombre completo");

  // ========== Home Screen ==========
  String get home => _getText("Home", "Inicio");
  String get start => _getText("Start", "Comenzar");
  String get profile => _getText("Profile", "Perfil");
  String get welcome => _getText("Welcome", "Bienvenido");
  String get welcomeBack => _getText("Welcome back", "Bienvenido de nuevo");

  // ========== Tarot Reading ==========
  String get shuffleCards => _getText("Shuffle Cards", "Barajar cartas");
  String get drawCards => _getText("Draw Cards", "Sacar cartas");
  String get selectStack => _getText("Select a Stack", "Selecciona una pila");
  String get revealCards => _getText("Reveal Cards", "Revelar cartas");
  String get tapToReveal => _getText("Tap to reveal", "Toca para revelar");
  String get cardMeaning => _getText("Card Meaning", "Significado de la carta");
  String get interpretation => _getText("Interpretation", "Interpretación");
  String get readingComplete => _getText("Reading Complete", "Lectura completa");
  String get newReading => _getText("New Reading", "Nueva lectura");
  String get saveReading => _getText("Save Reading", "Guardar lectura");
  String get shareReading => _getText("Share Reading", "Compartir lectura");

  // ========== Card Positions (Celtic Cross) ==========
  String get presentPosition => _getText("Present Position", "Posición presente");
  String get challenge => _getText("Challenge", "Desafío");
  String get past => _getText("Past", "Pasado");
  String get future => _getText("Future", "Futuro");
  String get above => _getText("Above", "Arriba");
  String get below => _getText("Below", "Abajo");
  String get advice => _getText("Advice", "Consejo");
  String get externalInfluence => _getText("External Influence", "Influencia externa");
  String get hopesAndFears => _getText("Hopes and Fears", "Esperanzas y miedos");
  String get outcome => _getText("Outcome", "Resultado");

  // ========== Profile ==========
  String get editProfile => _getText("Edit Profile", "Editar perfil");
  String get settings => _getText("Settings", "Configuración");
  String get language => _getText("Language", "Idioma");
  String get notifications => _getText("Notifications", "Notificaciones");
  String get readingHistory => _getText("Reading History", "Historial de lecturas");
  String get favorites => _getText("Favorites", "Favoritos");
  String get aboutUs => _getText("About Us", "Acerca de nosotros");
  String get privacyPolicy => _getText("Privacy Policy", "Política de privacidad");
  String get termsOfService => _getText("Terms of Service", "Términos de servicio");
  String get termsOfServiceAgreement =>
      _getText("I agree to Terms of Service", "Acepto los Términos de servicio");
  String get logout => _getText("Logout", "Cerrar sesión");

  // ========== Loading & Messages ==========
  String get loading => _getText("Loading...", "Cargando...");
  String get shuffling => _getText("Shuffling cards...", "Barajando cartas...");
  String get preparing => _getText("Preparing your reading...", "Preparando tu lectura...");
  String get pleaseWait => _getText("Please wait", "Por favor espera");
  String get success => _getText("Success", "Éxito");
  String get error => _getText("Error", "Error");
  String get tryAgain => _getText("Try again", "Intentar de nuevo");
  String get ok => _getText("OK", "Aceptar");
  String get cancel => _getText("Cancel", "Cancelar");
  String get confirm => _getText("Confirm", "Confirmar");
  String get save => _getText("Save", "Guardar");
  String get delete => _getText("Delete", "Eliminar");

  // ========== Error Messages ==========
  String get emailRequired => _getText("Email is required", "El correo electrónico es obligatorio");
  String get passwordRequired => _getText("Password is required", "La contraseña es obligatoria");
  String get invalidEmail => _getText("Invalid email format", "Formato de correo electrónico no válido");
  String get passwordTooShort => _getText("Password must be at least 6 characters", "La contraseña debe tener al menos 6 caracteres");
  String get passwordsDoNotMatch => _getText("Passwords do not match", "Las contraseñas no coinciden");
  String get loginFailed => _getText("Login failed. Please try again.", "Inicio de sesión fallido. Inténtalo de nuevo.");
  String get registrationFailed => _getText("Registration failed. Please try again.", "Registro fallido. Inténtalo de nuevo.");
  String get networkError => _getText("Network error. Please check your connection.", "Error de red. Verifica tu conexión.");
  String get somethingWentWrong => _getText("Something went wrong", "Algo salió mal");

  // ========== Onboarding ==========
  String get getStarted => _getText("Get Started", "Comenzar");
  String get next => _getText("Next", "Siguiente");
  String get skip => _getText("Skip", "Omitir");
  String get done => _getText("Done", "Listo");

  // ========== Card Details ==========
  String get majorArcana => _getText("Major Arcana", "Arcanos Mayores");
  String get minorArcana => _getText("Minor Arcana", "Arcanos Menores");
  String get cups => _getText("Cups", "Copas");
  String get wands => _getText("Wands", "Bastos");
  String get swords => _getText("Swords", "Espadas");
  String get pentacles => _getText("Pentacles", "Pentáculos");

  // ========== Time & Date ==========
  String get today => _getText("Today", "Hoy");
  String get yesterday => _getText("Yesterday", "Ayer");
  String get thisWeek => _getText("This week", "Esta semana");
  String get thisMonth => _getText("This month", "Este mes");

  // ========== Common Actions ==========
  String get close => _getText("Close", "Cerrar");
  String get back => _getText("Back", "Atrás");
  String get continue_ => _getText("Continue", "Continuar");
  String get submit => _getText("Submit", "Enviar");
  String get search => _getText("Search", "Buscar");
  String get filter => _getText("Filter", "Filtrar");
  String get sortBy => _getText("Sort by", "Ordenar por");
  String get viewAll => _getText("View all", "Ver todo");
  String get readMore => _getText("Read more", "Leer más");
  String get readLess => _getText("Read less", "Leer menos");
}