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

  //=========Subscription
  String get unlockSoulPath =>
      _getText("UNLOCK YOUR FULL\nSOUL PATH", "DESBLOQUEA TU CAMINO\nCOMPLETO DEL ALMA",);
  String get accessUnlimitedReadings =>
      _getText(
        "Access Unlimited Readings, Voice Guidance, And\nDeeper Spiritual Clarity.",
        "Accede a lecturas ilimitadas, guía por voz y\nuna claridad espiritual más profunda.",
      );
  String get freeReadings =>
      _getText(
        "These are your free readings",
        "Estas son tus lecturas gratuitas",
      );

  String get startFreeTrial =>
      _getText(
        "Start Your 7-Day Free Trial",
        "Comienza tu prueba gratuita de 7 días",
      );
  String get trialNoChargeInfo =>
      _getText(
        "You won't be charged until the end of the trial. Cancel\nanytime.",
        "No se te cobrará hasta el final de la prueba. Cancela\nen cualquier momento.",
      );

  //===================================



   String get welcomeTitle =>
  _getText("Welcome to\nSoulGate", "Bienvenido a\nSoulGate");

   String get welcomeSubtitle =>
  _getText("To the realm of the soul", "Al reino del alma");

   String get welcomeDescription =>
  _getText(
    "A space of clarity, guidance, and light",
    "Un espacio de claridad, guía y luz",
  );

   String get customizeExperience =>
  _getText(
    "Customize Your Experience",
    "Personaliza tu experiencia",
  );

   String get continueText =>
  _getText("Continue", "Continuar");

   String get innerWorldTitle =>
  _getText(
    "Your inner\nworld,\nilluminated.",
    "Tu mundo\ninterior,\niluminado.",
  );

   String get personalizedReadings =>
  _getText(
    "Personalized tarot readings",
    "Lecturas de tarot personalizadas",
  );

   String get  voiceOrText =>
  _getText(
    "Voice or text guidance",
    "Guía por voz o texto",
  );

   String get guideMessages =>
  _getText(
    "Messages from your guides",
    "Mensajes de tus guías",
  );

   String get lifeInsights =>
  _getText(
    "Insights for love, purpose, money & spiritual path",
    "Perspectivas sobre amor, propósito, dinero y camino espiritual",
  );

   String get secureSpace =>
  _getText(
    "Secure, private, sacred space",
    "Espacio seguro, privado y sagrado",
  );

   String get freeReadingsTitle =>
  _getText(
    "Your first\nreadings\nare a gift.",
    "Tus primeras\nlecturas\nson un regalo.",
  );

   String  get freeReadingsDescription => _getText("To help you experience the depth of SoulGate, you receive 5 free readings. Each one is unique, channeled, and designed to bring clarity.", "Para ayudarte a experimentar la profundidad de SoulGate, recibes 5 lecturas gratuitas. Cada una es única, canalizada y diseñada para brindar claridad.",);

  String get selectDeckOfCards => _getText("Select Deck of Cards", "Selecciona una baraja de cartas",);

  String get howWouldYouLikeYourReading => _getText("How would you like\nyour reading?", "¿Cómo te gustaría\ntu lectura?",);

  String get stepIntoThePortal => _getText("Step into\nthe portal.", "Entra en\nel portal.",);

  String get enterThePortal => _getText("Enter the Portal", "Entrar al Portal",);

  String get askTheOracle => _getText("Ask the Oracle", "Pregunta al Oráculo",);


  //=================

  String get exploreQuestionPrompt => _getText("Is this the question\nyou want to explore?", "¿Es esta la pregunta\nque quieres explorar?",);

  String get typeYourQuestionHint => _getText("Type your question here...", "Escribe tu pregunta aquí...",);

  String get yesContinueButton => _getText("Yes, continue", "Sí, continuar",);

  String get preparingYourReading => _getText("Preparing Your Reading", "Preparando tu lectura",);

  String get shufflingBtn => _getText("Shuffling...", "Barajando...",);

  String get shuffleBtn => _getText("Shuffle", "Barajar",);
  String get sevenCardReading => _getText("7 Card Reading", "Lectura de 7 cartas",);

  String get threeCardReading => _getText("3 Card Reading", "Lectura de 3 cartas",);




  String get connectionIssue => _getText("Connection Issue", "Problema de conexión",);

  String get attemptOfMaxRetries => _getText("Attempt \$currentAttempt of \$maxRetries", "Intento \$currentAttempt de \$maxRetries",);

  String get retry => _getText("Retry", "Reintentar",);

  String get goBack => _getText("Go Back", "Regresar",);

  String get readingError => _getText("Reading Error", "Error de lectura",);


  String get yourReading => _getText("Your Reading", "Tu lectura",);

  String get listen => _getText("Listen", "Escuchar",);


  //==========================



  String get saintMichaelsBlessingTitle => _getText("Saint Michael's Blessing", "Bendición de San Miguel",);

  String get saintMichaelsBlessingText => _getText("IN THIS MOMENT, I OPEN THIS SESSION\nWITH CLARITY AND INTENTION.\nARCHANGEL MICHAEL SURROUNDS US\nWITH HIS LIGHT AND PROTECTS THIS\nSPACE.\nGUIDES OF LIGHT, REVEAL ONLY WHAT\nSERVES THE HIGHEST GOOD.\nMAY EVERY MESSAGE BRING TRUTH, PEACE,\nAND ALIGNMENT.\nTHANK YOU, THANK YOU, THANK YOU.\nAND SO IT IS", "EN ESTE MOMENTO, ABRO ESTA SESIÓN\nCON CLARIDAD E INTENCIÓN.\nEL ARCÁNGEL MIGUEL NOS RODEA\nCON SU LUZ Y PROTEGE ESTE\nESPACIO.\nGUÍAS DE LUZ, REVELEN SOLO LO QUE\nSIRVA AL BIEN MÁS ALTO.\nQUE CADA MENSAJE TRAIGA VERDAD, PAZ,\nY ALINEACIÓN.\nGRACIAS, GRACIAS, GRACIAS.\nASÍ SEA",);

  String get saintMichaelsBlessingTextSH => _getText(
        "In this moment, I open this session with clarity and intention. "
            "Archangel Michael surrounds us with his light and protects this space. "
            "Guides of light, reveal only what serves the highest good. "
            "May every message bring truth, peace, and alignment. "
            "Thank you, thank you, thank you. And so it is.",
        "En este momento, abro esta sesión con claridad e intención. "
            "El Arcángel Miguel nos rodea con su luz y protege este espacio. "
            "Guías de luz, revelen solo lo que sirva al bien más alto. "
            "Que cada mensaje traiga verdad, paz y alineación. "
            "Gracias, gracias, gracias. Así sea.",
      );




  String get consultingTheCards => _getText("Consulting the cards...", "Consultando las cartas...",);



   late List<String> messages = [
    _getText(
      "Reading the cards...",
      "Leyendo las cartas...",
    ),
    _getText(
      "Consulting the universe...",
      "Consultando el universo...",
    ),
    _getText(
      "Interpreting your path...",
      "Interpretando tu camino...",
    ),
    _getText(
      "Channeling wisdom...",
      "Canalizando sabiduría...",
    ),
  ];


  String get loadingTimeoutMessage => _getText("This may take up to 30 seconds...", "Esto puede tardar hasta 30 segundos...",);


  String get appProgressTitle =>
      _getText(
        "Your app is progressing beautifully.",
        "Tu aplicación está avanzando maravillosamente.",
      );

  String get appProgressMessage =>
      _getText(
        "Message",
        "Mensaje",
      );

  String get anyQuestionsPrompt =>
      _getText(
        "DO YOU HAVE ANY\nQUESTION OR DOUBTS?",
        "¿TIENES ALGUNA\nPREGUNTA O DUDA?",
      );

  String get currentSituationQuestion =>
      _getText(
        "What do I most need to understand about my\ncurrent situation?",
        "¿Qué necesito entender más sobre mi\nsituación actual?",
      );

  String get noThanks =>
      _getText(
        "No, Thanks",
        "No, gracias",
      );


  String get thankYouGuidance =>
      _getText(
        "THANK YOU FOR THE GUIDANCE RECEIVED IN THIS SESSION.",
        "GRACIAS POR LA ORIENTACIÓN RECIBIDA EN ESTA SESIÓN.",
      );

  String get closeReadingWithGratitude =>
      _getText(
        "I CLOSE THIS READING WITH GRATITUDE, CLARITY, AND PEACE.",
        "CIERRO ESTA LECTURA CON GRATITUD, CLARIDAD Y PAZ.",
      );

  String get insightsSupportHighestGood =>
      _getText(
        "MAY THE INSIGHTS OFFERED CONTINUE SUPPORTING MY HIGHEST GOOD.",
        "QUE LOS CONOCIMIENTOS OFRECIDOS SIGAN APOYANDO MI BIEN MÁS ALTO.",
      );

  String get soBeIt =>
      _getText(
        "SO BE IT.",
        "ASÍ SEA.",
      );


//==========================


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