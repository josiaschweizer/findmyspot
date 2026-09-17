/* Shared OpenStreetMap layer. Open via HTTP/HTTPS, not file://. */
function addBaseMap(target) {
  const container = target.getContainer();
  const notice = document.createElement('div');
  notice.className = 'map-provider-notice';
  notice.setAttribute('role', 'status');
  const show = message => { notice.textContent = message; if (!notice.isConnected) container.appendChild(notice); };
  if (location.protocol === 'file:') {
    show('Die Online-Karte benötigt eine Webadresse. Direkt als Datei funktioniert die Liste; für die Karte bitte den Prototyp über HTTP oder HTTPS öffnen.');
    return null;
  }
  const layer = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a>'
  });
  let failed = false;
  layer.on('loading', () => { failed = false; });
  layer.on('tileerror', () => { failed = true; show('Kartendaten nicht erreichbar. Bitte Internetverbindung prüfen. Die Liste bleibt verfügbar.'); });
  layer.on('load', () => { if (!failed) notice.remove(); });
  layer.addTo(target);
  return layer;
}
