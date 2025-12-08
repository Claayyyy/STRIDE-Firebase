// --- NEW: Robust Instant Update Logic ---
// (This section is unchanged)
let refreshing = false;
if ('serviceWorker' in navigator) {
    
    // 1. This is our "reload" trigger. It fires when the new worker takes control.
    navigator.serviceWorker.addEventListener('controllerchange', () => {
        if (refreshing) return;
        console.log('New version detected. Reloading page...');
        refreshing = true;
        window.location.reload();
    });

    // 2. We run this on 'load' to register and check for updates
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('sw.js')
            .then((reg) => {
                console.log('Service worker registered.', reg);

                // 3. This checks if a new worker is already installed and waiting.
                // If so, we tell it to take over.
                if (reg.waiting) {
                    console.log('New worker found waiting. Activating...');
                    reg.waiting.postMessage({ type: 'SKIP_WAITING' });
                }

                // 4. This listens for *future* updates that get found
                reg.addEventListener('updatefound', () => {
                    console.log('New service worker update found.');
                    const newWorker = reg.installing;
                    
                    newWorker.addEventListener('statechange', () => {
                        // 5. When the new worker is installed, we tell it to take over.
                        if (newWorker.state === 'installed') {
                            console.log('New worker installed. Activating...');
                            // This message is caught by the 'message' listener in sw.js
                            newWorker.postMessage({ type: 'SKIP_WAITING' });
                        }
                    });
                });
            })
            .catch((err) => {
                console.error('Service worker registration failed:', err);
            });
    });
}
// --- END: Robust Instant Update Logic ---


// --- MODIFIED: Landing Page Logic ---
const landingPage = document.getElementById('landingPage');
const appContainer = document.getElementById('appContainer');
const startSurveyBtn = document.getElementById('startSurveyBtn');

/**
 * Checks if the user agent string indicates a mobile device.
 * @returns {boolean} True if mobile, false if not.
 */
function isMobileDevice() {
    // This regex checks for 'Mobi' (common in mobile browsers) or 'Android'
    // 'i' makes the check case-insensitive.
    return /Mobi|Android/i.test(navigator.userAgent);
}

/* if (startSurveyBtn) {
    startSurveyBtn.addEventListener('click', () => {
        
        if (isMobileDevice()) {
            // --- OUTCOME 1: USER IS ON MOBILE ---
            // This is the normal flow: show the app.
            console.log('Mobile device detected. Starting app...');
            landingPage.style.display = 'none';
            appContainer.style.display = 'flex'; // Show the app
            showPage(0); // Show the first page of the form
        } else {
            // --- OUTCOME 2: USER IS ON DESKTOP ---
            // We will replace the landing page content with the new message and QR code.
            console.log('Desktop device detected. Showing message and QR code.');
            
            // --- THIS HTML BLOCK IS UPDATED ---
            landingPage.innerHTML = `
                <h1 style="text-align: center;">Desktop Detected</h1>
                <p style="text-align: center;">This data collection tool is designed for mobile use.</p>
                <p style="text-align: center;">Access this page using your mobile browser and install the app! </p>
                
            `;
            // --- END OF UPDATED BLOCK ---

            // We remove the green theme color from the h1
            const h1 = landingPage.querySelector('h1');
            if (h1) {
                h1.style.color = '#333'; // A neutral dark color
            }
        }
    });
}
// --- END: Landing Page Logic --- */

// --- PASTE THIS NEW CODE ---

if (startSurveyBtn) {
    startSurveyBtn.addEventListener('click', () => {

        // This code now runs for ALL devices (desktop or mobile)
        console.log('Starting app...');
        landingPage.style.display = 'none';
        appContainer.style.display = 'flex'; // Show the app
        showPage(0); // Show the first page of the form

    });
}


// --- Database Setup (IndexedDB) ---
// (This section is unchanged)
const DB_NAME = 'surveyDB';
const STORE_NAME = 'surveys';
let db;

function initDB() {
    return new Promise((resolve, reject) => {
        const request = indexedDB.open(DB_NAME, 1);
        request.onupgradeneeded = (event) => {
            const db = event.target.result;
            db.createObjectStore(STORE_NAME, { keyPath: 'id', autoIncrement: true });
            console.log('Database created or upgraded.');
        };
        request.onsuccess = (event) => {
            db = event.target.result;
            console.log('Database opened successfully.');
            resolve();
        };
        request.onerror = (event) => {
            console.error('Database error:', event.target.error);
            reject(event.target.error);
        };
    });
}

function addSurveyToDB(surveyData) {
    return new Promise((resolve, reject) => {
        if (!db) {
            console.error('Database is not open.');
            return reject('Database not open');
        }
        const transaction = db.transaction([STORE_NAME], 'readwrite');
        const store = transaction.objectStore(STORE_NAME);
        const request = store.add(surveyData);
        request.onsuccess = () => {
            console.log('Survey added to IndexedDB:', surveyData);
            if ('serviceWorker' in navigator && 'SyncManager' in window) {
                navigator.serviceWorker.ready.then(function(reg) {
                    return reg.sync.register('sync-surveys');
                }).then(() => {
                    console.log('Sync task registered');
                }).catch((err) => {
                    console.error('Sync task registration failed:', err);
                });
            }
            resolve(request.result);
        };
        request.onerror = (event) => {
            console.error('Error adding survey to DB:', event.target.error);
            reject(event.target.error);
        };
    });
}

// --- Multi-Page Form Logic ---
// (This section is unchanged)
let currentPage = 0;
const surveyForm = document.getElementById('surveyForm');
const formPages = document.querySelectorAll('.form-page');
const nextBtn = document.getElementById('nextBtn');
const prevBtn = document.getElementById('prevBtn');
const submitBtn = document.getElementById('submitBtn');
const clearFormBtn = document.getElementById('clearFormBtn');
const stepIndicators = document.querySelectorAll('.step');

const totalPages = formPages.length;

function showPage(pageIndex) {
    // Hide all pages
    formPages.forEach(page => page.classList.remove('active'));
    // Show the current page
    formPages[pageIndex].classList.add('active');

    // Update button visibility
    prevBtn.style.display = pageIndex === 0 ? 'none' : 'inline-block';
    nextBtn.style.display = pageIndex === totalPages - 1 ? 'none' : 'inline-block';
    submitBtn.style.display = pageIndex === totalPages - 1 ? 'inline-block' : 'none';

    // Update step indicator
    stepIndicators.forEach((step, index) => {
        if (index === pageIndex) {
            step.classList.add('active');
        } else {
            step.classList.remove('active');
        }
    });
    
    // Scroll to top of content area
    const contentArea = document.querySelector('.content-area');
    if (contentArea) {
        contentArea.scrollTo(0, 0);
    }
    currentPage = pageIndex;
}

if (nextBtn) {
    nextBtn.addEventListener('click', () => {
        if (currentPage < totalPages - 1) {
            showPage(currentPage + 1);
        }
    });
}

if (prevBtn) {
    prevBtn.addEventListener('click', () => {
        if (currentPage > 0) {
            showPage(currentPage - 1);
        }
    });
}

// --- Handle Form Submission ---
// (This section is unchanged)
if (surveyForm) {
    surveyForm.addEventListener('submit', (event) => {
        event.preventDefault(); // Prevent default submission

        // Get all form data
        const formData = new FormData(surveyForm);
        const surveyData = Object.fromEntries(formData.entries());
        
        // Add timestamp
        surveyData.timestamp = new Date().toISOString();

        // Save the complete data to IndexedDB
        addSurveyToDB(surveyData)
            .then(() => {
                console.log('Full survey saved to IndexedDB.');
                alert('Thank you! Your survey has been saved and will sync when online.');

                // Clear the form and the draft
                surveyForm.reset();
                clearDraft();
                
                // Go back to the first page
                showPage(0);
            })
            .catch((err) => {
                console.error('Failed to save full survey:', err);
                alert('There was an error saving your survey.');
            });
    });
}

// --- Draft Saving ---
// (This section is unchanged)
const DRAFT_KEY = 'strideSurveyDraft';

if (surveyForm) {
    surveyForm.addEventListener('input', () => {
        saveDraft();
    });
}

function saveDraft() {
    const formData = new FormData(surveyForm);
    const surveyData = Object.fromEntries(formData.entries());
    localStorage.setItem(DRAFT_KEY, JSON.stringify(surveyData));
    // console.log('Draft saved to localStorage.'); // Uncomment for debugging
}

function loadDraft() {
    const draft = localStorage.getItem(DRAFT_KEY);
    if (!draft || !surveyForm) {
        console.log('No draft found or form missing.');
        return;
    }
    
    try {
        const draftData = JSON.parse(draft);
        // Loop through saved data and populate form fields
        for (const key in draftData) {
            if (draftData.hasOwnProperty(key)) {
                const element = surveyForm.elements[key];
                if (element) {
                    element.value = draftData[key];
                }
            }
        }
        
        // Special handling to re-populate the dynamic division dropdown
        if (draftData['stride_region']) {
            populateDivisions(draftData['stride_region']);
            // We must re-set the division value *after* populating
            if (surveyForm.elements['stride_division']) {
                surveyForm.elements['stride_division'].value = draftData['stride_division'] || '';
            }
        }
        
        console.log('Draft loaded from localStorage.');
    } catch (err) {
        console.error('Failed to parse or load draft:', err);
        clearDraft(); // Clear corrupted draft
    }
}

function clearDraft() {
    localStorage.removeItem(DRAFT_KEY);
    console.log('Draft cleared from localStorage.');
}

if (clearFormBtn) {
    clearFormBtn.addEventListener('click', () => {
        if (confirm('Are you sure you want to clear all data in this form? This cannot be undone.')) {
            surveyForm.reset();
            clearDraft();
            // Manually clear division dropdown
            populateDivisions('');
            showPage(0); // Go back to start
            console.log('Form and draft cleared by user.');
        }
    });
}


// --- Dynamic Dropdown Logic ---
// (This section is unchanged)
const divisionData = {
    "Region I": ["Ilocos Norte", "Ilocos Sur", "La Union", "Pangasinan"],
    "Region II": ["Batanes", "Cagayan", "Isabela", "Nueva Vizcaya", "Quirino"],
    "NCR": ["Manila", "Quezon City", "Calocan", "Pasig"],
    "CAR": ["Abra", "Apayao", "Benguet", "Ifugao", "Kalinga", "Mountain Province"],
    // ... Add all other regions and their divisions here
};

const regionSelect = document.getElementById('stride_region');
const divisionSelect = document.getElementById('stride_division');

function populateDivisions(region) {
    if (!divisionSelect) return; // Exit if element doesn't exist
    
    const divisions = divisionData[region] || [];
    
    divisionSelect.innerHTML = '<option value="">--- Select Division ---</option>';
    
    divisions.forEach(division => {
        const option = document.createElement('option');
        option.value = division;
        option.textContent = division;
        divisionSelect.appendChild(option);
    });
}

if (regionSelect) {
    regionSelect.addEventListener('change', (event) => {
        populateDivisions(event.target.value);
    });
}


// --- Initialize ---
// (This section is unchanged)
initDB()
    .then(() => {
        loadDraft();
    })
    .catch(err => console.error('Failed to initialize database:', err));