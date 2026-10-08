// Loader del esqueleto extensible: escanea slots [data-effect] e importa
// el modulo correspondiente (1 modulo por efecto). Los slots sin modulo
// registrado se ignoran sin error; sin red (CDN caido) la pagina sigue
// legible porque el contenido no depende de JS.
const EFFECT_LOADERS = {
  none: () => import("./effects/none.js"),
};

function initNavToggle() {
  const toggle = document.querySelector(".nav-toggle");
  const menu = document.getElementById("nav-menu");
  if (!toggle || !menu) {
    return;
  }
  toggle.addEventListener("click", () => {
    const open = menu.classList.toggle("open");
    toggle.setAttribute("aria-expanded", String(open));
  });
}

async function initEffects() {
  if (typeof window.gsap !== "undefined" && typeof window.ScrollTrigger !== "undefined") {
    window.gsap.registerPlugin(window.ScrollTrigger);
  }
  const slots = document.querySelectorAll("[data-effect]");
  for (const slot of slots) {
    const load = EFFECT_LOADERS[slot.dataset.effect];
    if (!load) {
      continue;
    }
    try {
      const mod = await load();
      if (mod && typeof mod.init === "function") {
        mod.init(slot);
      }
    } catch (err) {
      console.warn("Efecto no disponible:", slot.dataset.effect, err);
    }
  }
}

initNavToggle();
initEffects();
