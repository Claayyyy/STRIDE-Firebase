# ui_parts/01_head_elements.R

ui_head <- tagList(
  tags$head(
    # --- 1. FIREBASE SDK (Manual Load) ---
    tags$script(src = "https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js"),
    tags$script(src = "https://www.gstatic.com/firebasejs/8.10.1/firebase-auth.js"),
    tags$script(src = "https://www.gstatic.com/firebasejs/8.10.1/firebase-firestore.js"),
    
    # --- 2. LOCAL ASSETS (CSS & JS) ---
    includeCSS("www/style.css"),
    includeScript("www/script.js"),
    
    tags$link(rel = "icon", type = "image/png", href = "deped_logo.png"),
    
    # --- 3. FIREBASE CONFIGURATION & BRIDGE ---
    tags$script(HTML("
      $(document).ready(function() {
        console.log('JS: Initializing Firebase Bridge...');

        var firebaseConfig = {
          apiKey: 'AIzaSyCK889hMN-rzQ9f3zz1JufqsGcV-3zBZ0A',
          authDomain: 'stride-64550.firebaseapp.com',
          projectId: 'stride-64550',
          storageBucket: 'stride-64550.firebasestorage.app',
          appId: '1:438486481554:web:fadfd74b2567e8c9c0444b'
        };

        try {
          if (typeof firebase !== 'undefined' && !firebase.apps.length) {
            firebase.initializeApp(firebaseConfig);
            console.log('JS: Firebase Initialized Successfully.');
          }
        } catch (e) {
          console.error('JS: Firebase Init Error', e);
        }

        // --- C. SIGN IN HANDLER (Updated to Force Hide Loader) ---
        Shiny.addCustomMessageHandler('firebase-sign_in', function(msg) {
          console.log('JS: Signing in ' + msg.email);
          
          if (typeof firebase === 'undefined') {
             alert('Error: Firebase SDK not loaded.'); return;
          }

          firebase.auth().signInWithEmailAndPassword(msg.email, msg.password)
            .then((cred) => {
              console.log('JS: Login Success - Forcing UI Unlock');
              
              // ✅ FORCE HIDE LOADER IMMEDIATELY
              $('#loading-overlay').fadeOut(); 
              $('body').removeClass('login-hidden'); // Ensure body is visible

              Shiny.setInputValue('fire_signed_in', {
                response: true,
                user: { email: cred.user.email, uid: cred.user.uid }
              }, {priority: 'event'});
            })
            .catch((error) => {
              console.error('JS: Login Failed', error);
              Shiny.setInputValue('fire_signed_in', {
                response: false,
                error: { message: error.message }
              }, {priority: 'event'});
            });
        });

        // D. CREATE USER HANDLER (Also Force Hide)
        Shiny.addCustomMessageHandler('firebase-create_user', function(msg) {
          console.log('JS: Creating user ' + msg.email);
          firebase.auth().createUserWithEmailAndPassword(msg.email, msg.password)
            .then((cred) => {
              console.log('JS: Register Success - Forcing UI Unlock');
              
              // ✅ FORCE HIDE LOADER
              $('#loading-overlay').fadeOut();
              
              Shiny.setInputValue('fire_created', {
                 response: true,
                 user: { email: cred.user.email }
              }, {priority: 'event'});
            })
            .catch((error) => {
              console.error('JS: Register Failed', error);
              Shiny.setInputValue('fire_created', {
                 response: false,
                 error: { message: error.message }
              }, {priority: 'event'});
            });
        });

        // E. SIGN OUT HANDLER
        Shiny.addCustomMessageHandler('firebase-sign_out', function(msg) {
          firebase.auth().signOut().then(() => console.log('JS: Signed Out'));
        });
      });
    ")),
    
    # --- 4. EXISTING EXTERNAL SCRIPTS ---
    tags$script(src = "https://unpkg.com/leaflet.smoothmarkerbouncing/leaflet.smoothmarkerbouncing.js"),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0, maximum-scale=3.0"),
    
    # --- 5. CUSTOM STYLES ---
    tags$style(HTML("
    .btn-warning {
      background-color: #ffc107 !important;
      border-color: #ffc107 !important;
      color: #212529 !important;
      font-weight: 600;
    }
    .btn-warning:hover {
      background-color: #e0a800 !important;
      border-color: #d39e00 !important;
      color: #fff !important;
    }
    .login-container {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    "))
  ),
  
  tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap",
      rel = "stylesheet"
    ),
    tags$style(HTML("body, h1, h2, h3, h4, h5, h6, p, span, button { font-family: 'Poppins', sans-serif; }"))
  ),
  
  rintrojs::introjsUI(),
  tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = "anonymous")
)