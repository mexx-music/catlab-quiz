'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "eae00e856f47315476ce90033d9de890",
"version.json": "f42a8578e8a232d5615dc8bbf6790dc1",
"index.html": "dff40e872029ba2932fd8c99827a90e2",
"/": "dff40e872029ba2932fd8c99827a90e2",
"CNAME": "a3f210f20bd3ac6c2449d07fe7acf149",
"main.dart.js": "f6ae3cb6417c69b688fa76ad72e846ff",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "0d470ffc358cbb303f20436e98900e3d",
"icons/Icon-192.png": "6f1a5760dd80fadd4f53cb547b6d0bae",
"icons/Icon-maskable-192.png": "6f1a5760dd80fadd4f53cb547b6d0bae",
"icons/Icon-maskable-512.png": "03a876dc417b2dc7eefd25403f1b9b93",
"icons/Icon-512.png": "03a876dc417b2dc7eefd25403f1b9b93",
"manifest.json": "0ff30dcf72a385afb1eb1188af30b099",
"assets/AssetManifest.json": "8417786a7ca268a9e638c3107fd85f54",
"assets/NOTICES": "bfedd5b0e76515af34b7a55bce2654ed",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "dcfc1cfb8a993b7fceb257c6e0b8494e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "975d7a088a6ca9bbe7f526447c7991c5",
"assets/fonts/MaterialIcons-Regular.otf": "e126618f4908ae50ec816e0cfd39a651",
"assets/assets/images/purring.png": "8009ee60ab76fbcdc1b80c20e76f4586",
"assets/assets/images/myths.png": "04bb32ad40a98c7d23d86d8f123078b7",
"assets/assets/images/behavior.png": "cbc1215cd62141da5f89df83f8dcd2d4",
"assets/assets/images/breeds.png": "cf6cbbc95de9daf5238314e458050f3a",
"assets/assets/quiz/quiz_catalog.json": "b2c1231d88b1cde33869df3f9b15fec9",
"assets/assets/quiz/cat_kittens.json": "b7d76f7f691795fde75e95c948cdce05",
"assets/assets/quiz/cat_myths.json": "77687e30570daee2324e2d74493a4dd5",
"assets/assets/quiz/cat_purring.json": "8683a7f6b33407a383c081a9558c0da4",
"assets/assets/quiz/cat_house_cats.json": "99f4271c64ee9f18bbc28a175dd63b8a",
"assets/assets/quiz/cat_human_bond.json": "7146817339ef2b1d0154c71e18d58707",
"assets/assets/quiz/cat_mixed_challenge.json": "e5562b3966f22855b6e9a7704693c85f",
"assets/assets/quiz/cat_expert_knowledge.json": "81b66033ff8fedb2d89960f87cd99e65",
"assets/assets/quiz/cat_cat_communication.json": "ae7f8476690e7740b373622ac307ebe1",
"assets/assets/quiz/cat_breeds_beginner.json": "6a5146097bc67d8714fb9e0fe1af7405",
"assets/assets/quiz/cat_behavior.json": "1239baaf968a77ff7d20325a12f97f9c",
"assets/assets/quiz/cat_body_language.json": "d38cd4ebe05f00f8ef553ee680f1408f",
"assets/assets/quiz/cat_indoor_outdoor.json": "3c8db5ffa0f3101fbed4e78249b6ac5f",
"assets/assets/content/cat_indoor_outdoor_posts.json": "4375934d840e3ffcefa67336ee99d650",
"assets/assets/content/cat_purring_posts.json": "4e8f5407a3c02b942626435dd28957e5",
"assets/assets/content/cat_human_bond_posts.json": "1d6b95988c4e54bd64d464f1180860fa",
"assets/assets/content/cat_body_language_posts.json": "656cf517b69a50f9a0c4ecb91483ff30",
"assets/assets/content/cat_kittens_posts.json": "a24b20f2e8d69a75e1eb0f5f71139ca0",
"assets/assets/content/cat_house_cats_posts.json": "f0c1f0e39daf4afa33722f17a3e3b440",
"assets/assets/content/cat_mixed_challenge_posts.json": "3ea2933a4a0dd6ce927edcd73f186949",
"assets/assets/content/cat_breeds_beginner_posts.json": "dca2e2f697764a2c9be7f96d4ab02c53",
"assets/assets/content/cat_myths_posts.json": "7b6c3a11ff024232d407f8b8a1715691",
"assets/assets/content/cat_expert_knowledge_posts.json": "e06a1d38a721c54cc4e90da61918729f",
"assets/assets/content/cat_behavior_posts.json": "a2971397abfe0183098cdf3f8ffbc9a3",
"assets/assets/content/cat_cat_communication_posts.json": "c31ba4de4a08ad62f0053010a4ab8d39",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
