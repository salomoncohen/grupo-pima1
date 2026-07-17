const V='pima-v2';
const ASSETS=['./','./index.html','./manifest.json',
  'https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@3.19.0/dist/tabler-icons.min.css',
  'https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(V).then(c=>c.addAll(ASSETS)).catch(()=>{}));self.skipWaiting();});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==V).map(x=>caches.delete(x)))));self.clients.claim();});
self.addEventListener('fetch',e=>{
  if(e.request.url.includes('supabase.co'))return;
  e.respondWith(fetch(e.request).then(r=>{const c=r.clone();caches.open(V).then(cache=>cache.put(e.request,c));return r;}).catch(()=>caches.match(e.request)));
});
