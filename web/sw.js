// Offline cache. IMPORTANT: change the version (goslow-v2, v3...) every time you publish an update,
// otherwise players' phones keep showing the old version.
var CACHE='goslow-v3';
var FILES=["index.html", "manifest.json", "icon-192.png", "icon-512.png", "art/ada.png", "art/auditor.png", "art/bello.png", "art/boardroom.jpg", "art/bukka.jpg", "art/carpark.jpg", "art/chidi.png", "art/emeka.png", "art/herobg.jpg", "art/icon-512.png", "art/lounge.jpg", "art/md.png", "art/nkechi.png", "art/office.jpg", "art/oga.png", "art/restaurant.jpg", "art/tunde.png", "art/you-braids.png", "art/you-male.png", "art/you.png"];
self.addEventListener('install',function(e){self.skipWaiting();e.waitUntil(caches.open(CACHE).then(function(c){return c.addAll(FILES);}));});
self.addEventListener('activate',function(e){e.waitUntil(caches.keys().then(function(ks){return Promise.all(ks.filter(function(k){return k!==CACHE;}).map(function(k){return caches.delete(k);}));}));self.clients.claim();});
self.addEventListener('fetch',function(e){e.respondWith(fetch(e.request).then(function(r){var c=r.clone();caches.open(CACHE).then(function(ca){ca.put(e.request,c);});return r;}).catch(function(){return caches.match(e.request);}));});
