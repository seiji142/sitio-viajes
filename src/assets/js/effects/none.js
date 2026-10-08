// Modulo de ejemplo inerte: prueba la convencion "1 modulo por efecto"
// sin animar nada. Cada efecto futuro sigue este contrato: exportar init(slot).
export function init(slot) {
  slot.dataset.effectReady = "true";
}
