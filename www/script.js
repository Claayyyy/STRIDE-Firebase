function animateCards() {
  const cards = document.querySelectorAll(".card");
  cards.forEach(card => {
    if (!card.classList.contains("animate")) {
      card.classList.add("hidden");
      // Trigger reflow so transition applies
      void card.offsetWidth;
      card.classList.add("animate");
      card.classList.remove("hidden");
    }
  });
}

document.addEventListener("DOMContentLoaded", animateCards);

// Re-run animation when Shiny updates the UI
$(document).on('shiny:value', function() {
  animateCards();
});

// Sync card + text scaling with page zoom
function syncDashboardScale() {
  const scale = window.innerWidth / window.outerWidth;
  document.documentElement.style.setProperty('--zoom-scale', scale);
}

window.addEventListener('resize', syncDashboardScale);
window.addEventListener('load', syncDashboardScale);


// Auto-show dropdowns on hover (desktop only)
$(document).ready(function() {
  if (window.innerWidth > 992) { // desktop only
    $(".navbar .dropdown").hover(
      function() {
        $(this).addClass("show");
        $(this).find(".dropdown-menu").addClass("show");
      },
      function() {
        $(this).removeClass("show");
        $(this).find(".dropdown-menu").removeClass("show");
      }
    );
  }
});


// === REPLAY SIDEBAR ANIMATION ON NAV SWITCH ===
$(document).on("click", ".nav-link", function() {
  const sidebar = document.querySelector(".bslib-sidebar-layout > .sidebar");
  if (sidebar) {
    sidebar.style.animation = "none";
    sidebar.offsetHeight; // trigger reflow
    sidebar.style.animation = "sidebarSlideIn 0.6s ease-out";
  }
});


// === REPLAY BODY + SIDEBAR ANIMATIONS ON NAV SWITCH ===
$(document).on("click", ".nav-link", function() {
  const sidebar = document.querySelector(".bslib-sidebar-layout > .sidebar");
  const main = document.querySelector(".bslib-sidebar-layout > .main");

  [sidebar, main].forEach(el => {
    if (el) {
      el.style.animation = "none";
      el.offsetHeight; // reflow
      const animName = el.classList.contains("sidebar") ? "sidebarSlideIn" : "bodyFadeIn";
      el.style.animation = `${animName} 2s ease-out`;
    }
  });
});

// === LOADER CONTROL ===
function showLoader(text) {
  if (text) $("#loading-text").text(text);
  $("#loading-overlay")
    .stop(true, true)
    .fadeIn(600)
    .css("display", "flex");
}

function hideLoader() {
  $("#loading-overlay").stop(true, true).fadeOut(1200);
}

// === SHINY MESSAGE HANDLERS ===
Shiny.addCustomMessageHandler("showLoader", function(message) {
  showLoader(message);
});

Shiny.addCustomMessageHandler("hideLoader", function(message) {
  hideLoader();
});

Shiny.addCustomMessageHandler("addDashboardClass", function(message) {
  $("body").addClass("dashboard-bg");
});

// === Smart Loader Control (Relaxed Version) ===

let shinyBusy = true;

$(document).on("shiny:busy", function() {
  shinyBusy = true;
  console.log("🚧 shiny busy");
});

$(document).on("shiny:idle", function() {
  console.log("✅ shiny idle");

  setTimeout(() => {
    if (!shinyBusy) return;
    shinyBusy = false;

    // Check for ANY sign of the dashboard (Navbar, Sidebars, or Content Divs)
    const dashboardExists = 
         $(".navbar").length > 0 || 
         $("#data_input_content").length > 0 ||
         $("#mgmt_content").length > 0 ||
         $(".bslib-sidebar-layout").length > 0;

    // Check if we are still on the login page
    const isLoginPage = $(".login-card").length > 0 && $(".login-card").is(":visible");

    if (dashboardExists && !isLoginPage) {
      console.log("✨ Dashboard detected. Hiding loader.");
      hideLoader();
    } else if (!isLoginPage) {
      // If we aren't on login page, but can't find dashboard, force hide anyway after 200ms
      // This prevents the white screen of death
      console.log("⏳ Dashboard structure unclear, forcing hide...");
      setTimeout(() => hideLoader(), 200);
    }
    // If isLoginPage is true, we DO NOT hide the loader automatically here; 
    // we let the UI settle.
  }, 200); 
});

// Force hide on window load just in case
$(window).on("load", function() {
  setTimeout(() => hideLoader(), 500);
});



Shiny.addCustomMessageHandler("setLoginMode", function(mode) {
  if (mode === "login") {
    document.body.classList.add("login-hidden");
  } else {
    document.body.classList.remove("login-hidden");
  }
});



// --- Enlarge register panel for HR/Engineer ---
$(document).on("change", "select[id$='govlev']", function() {
  const selected = $(this).val();
  const $body = $("body");
  
  if (selected === "HR" || selected === "Engineer") {
    $body.addClass("enlarge-panel");
  } else {
    $body.removeClass("enlarge-panel");
  }
});


// Add this function for better responsive scaling
function handleResponsiveLayout() {
  const isMobile = window.innerWidth <= 768;
  const root = document.documentElement;
  
  if (isMobile) {
    root.style.setProperty('--base-font-size', '14px');
    root.style.setProperty('--card-padding', '10px');
  } else {
    root.style.setProperty('--base-font-size', '16px');
    root.style.setProperty('--card-padding', '20px');
  }
}

// Add event listeners
window.addEventListener('load', handleResponsiveLayout);
window.addEventListener('resize', handleResponsiveLayout);


// === PASSWORD VISIBILITY TOGGLE ===
// Click handler for eye toggle; toggles input type between password and text
$(document).on('click', '.toggle-password', function(e) {
  e.preventDefault();
  var target = $(this).attr('data-target') || $(this).data('target');
  if (!target) return;

  // IDs produced by Shiny ns() may contain characters that need escaping in jQuery selectors
  var esc = target.replace(/([:\\.\[\],=@])/g, "\\$1");
  var $input = $('#' + esc);

  // Fallback: try attribute selector if direct id not found
  if ($input.length === 0) {
    $input = $("[id$='" + target.split('-').slice(-1)[0] + "']");
  }

  if ($input.length === 0) return;

  if ($input.attr('type') === 'password') {
    $input.attr('type', 'text');
    $(this).find('i').removeClass('fa-eye').addClass('fa-eye-slash');
  } else {
    $input.attr('type', 'password');
    $(this).find('i').removeClass('fa-eye-slash').addClass('fa-eye');
  }
});

// =======================================================
// FIREBASE AUTHENTICATION HANDLER (The Missing Link)
// =======================================================

Shiny.addCustomMessageHandler("firebase-sign_in", function(message) {
  console.log("🔥 JS: Received login command for " + message.email);
  
  // 1. Show a loading state immediately
  if(typeof showLoader === "function") {
    showLoader("Authenticating with Firebase...");
  }

  // 2. Perform the actual Firebase Login
  // NOTE: This assumes 'firebase' is already initialized in your HTML head
  firebase.auth().signInWithEmailAndPassword(message.email, message.password)
    .then((userCredential) => {
      // Signed in successfully
      var user = userCredential.user;
      console.log("✅ JS: Firebase Login Success:", user.email);
      
      // 3. SEND SUCCESS SIGNAL BACK TO R
      // We use a custom input name 'login_success_manual' to avoid conflicts
      Shiny.setInputValue("login_success_manual", {
        email: user.email,
        uid: user.uid,
        token: "valid_token" 
      }, {priority: "event"});
      
    })
    .catch((error) => {
      var errorCode = error.code;
      var errorMessage = error.message;
      console.error("❌ JS: Login Failed", errorMessage);
      
      // 4. Send Error Signal back to R
      Shiny.setInputValue("login_error_manual", {
        code: errorCode,
        message: errorMessage
      }, {priority: "event"});
      
      // Hide loader so they can try again
      if(typeof hideLoader === "function") {
        hideLoader();
      }
    });
});



