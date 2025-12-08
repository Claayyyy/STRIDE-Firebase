// --- CONFIGURATION ---
// ⬇️ YOU WILL GET A NEW URL IN STEP 4 ⬇️
const GOOGLE_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbxD8SxFbX_6FlAgUdk0jCSrqhkCrGs645sKJNgrjme4zJkSEiNOfpu53RxqOd0HeOTeiQ/exec"; 
const CACHE_NAME = 'survey-app-shell-v201hiiiii-FINAL' ; 
const DB_NAME = 'surveyDB';
const STORE_NAME = 'surveys';

const FILES_TO_CACHE = [
    'index.html',
    'style.css',
    'app.js',
    'manifest.json'
];

// --- NEW: Message Listener ---
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        console.log('[ServiceWorker] Received SKIP_WAITING message. Activating now.');
        self.skipWaiting();
    }
});
// --- END: Message Listener ---

// --- CACHING (App Shell) ---
self.addEventListener('install', (event) => {
    console.log('[ServiceWorker] Install');
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('[ServiceWorker] Caching app shell');
            return cache.addAll(FILES_TO_CACHE);
        })
    );
    
    self.skipWaiting(); 
});

// --- FETCH (Unchanged) ---
self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request).then((response) => {
            return response || fetch(event.request);
        })
    );
});

// --- BACKGROUND SYNC (Unchanged) ---
self.addEventListener('sync', (event) => {
    if (event.tag === 'sync-surveys') {
        console.log('[ServiceWorker] Sync event fired: sync-surveys');
        event.waitUntil(syncSurveys());
    }
});

async function syncSurveys() {
    console.log('[ServiceWorker] Starting survey sync...');
    try {
        const surveys = await getAllSurveysFromDB();
        
        if (!surveys || surveys.length === 0) {
            console.log('[ServiceWorker] No surveys to sync.');
            return;
        }

        console.log(`[ServiceWorker] Found ${surveys.length} surveys to sync.`);

        const syncPromises = surveys.map(survey => {
            
            const dataToSend = { ...survey };
            delete dataToSend.id; // Remove the local DB ID before sending

            // --- START OF FIX ---
            return fetch(GOOGLE_SCRIPT_URL, {
                method: 'POST',
                body: JSON.stringify(dataToSend),
                headers: {
                    'Content-Type': 'text/plain;charset=utf-8', 
                },
                // mode: 'no-cors' <-- This was hiding the error
            })
            .then(response => {
                // Now we can *actually* check if it worked
                if (response.ok) {
                    console.log(`[ServiceWorker] Successfully synced survey ID ${survey.id}`);
                    // Only delete it if the server confirmed success
                    return deleteSurveyFromDB(survey.id);
                } else {
                    // The server returned an error (e.g., 404, 500)
                    console.error(`[ServiceWorker] Server error for survey ID ${survey.id}. Status: ${response.status}`);
                    // We do *not* delete the survey, so it will try again later
                    return Promise.reject(new Error(`Server error: ${response.status}`));
                }
            })
            // This catch block now works for network errors *and* server errors
            .catch(err => {
                console.error(`[ServiceWorker] Failed to sync survey ID ${survey.id}`, err);
                // Do not delete, will retry on next sync
            });
            // --- END OF FIX ---
        });

        await Promise.all(syncPromises);
        console.log('[ServiceWorker] Survey sync complete (or will retry failed items).');

    } catch (err) {
        console.error('[ServiceWorker] Error during sync:', err);
    }
}


// --- INDEXEDDB HELPER FUNCTIONS (Unchanged) ---
function openDB() {
    return new Promise((resolve, reject) => {
        const request = self.indexedDB.open(DB_NAME, 1);
        request.onsuccess = (event) => resolve(event.target.result);
        request.onerror = (event) => reject(event.target.error);
        request.onupgradeneeded = (event) => {
            const db = event.target.result;
            if (!db.objectStoreNames.contains(STORE_NAME)) {
                db.createObjectStore(STORE_NAME, { keyPath: 'id', autoIncrement: true });
            }
        };
    });
}

async function getAllSurveysFromDB() {
    const db = await openDB();
    return new Promise((resolve, reject) => {
        const transaction = db.transaction([STORE_NAME], 'readonly');
        const store = transaction.objectStore(STORE_NAME);
        const request = store.getAll();
        request.onsuccess = () => resolve(request.result);
        request.onerror = (event) => reject(event.target.error);
    });
}

async function deleteSurveyFromDB(id) {
    const db = await openDB();
    return new Promise((resolve, reject) => {
        const transaction = db.transaction([STORE_NAME], 'readwrite');
        const store = transaction.objectStore(STORE_NAME);
        const request = store.delete(id);
        request.onsuccess = () => resolve();
        request.onerror = (event) => reject(event.target.error);
    });
}


// --- ACTIVATION & CLEANUP (Unchanged) ---
self.addEventListener('activate', (event) => {
    console.log('[ServiceWorker] Activate');
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        console.log('[ServiceWorker] Deleting old cache:', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => {
            return self.clients.claim();
        })
    );
});