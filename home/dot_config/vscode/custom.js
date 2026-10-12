// Loaded into VS Code by the Custom CSS and JS Loader extension, next to custom.css, which draws the effects.
// Marks each move of the editor cursor with its direction (data-motion) for as long as it keeps moving,
// and leaves a fading afterimage where it was. VS Code never touches these attributes or elements.
(() => {
  const SETTLE_MS = 200; // how long the cursor keeps its motion pose after the last move
  const AFTERIMAGE_MS = 440; // as long as the cursor-afterimage animation in custom.css
  const SKEW = { right: -30, left: 30, up: 0, down: 0 }; // as in custom.css's data-motion rules
  const last = new WeakMap();
  const timers = new WeakMap();

  const leaveAfterimage = (cursor, from, motion) => {
    const ghost = document.createElement('div');
    ghost.className = 'cursor-afterimage';
    Object.assign(ghost.style, { top: from.top, left: from.left, width: from.width || '2px', height: from.height });
    ghost.style.setProperty('--skew', `${SKEW[motion]}deg`);
    cursor.parentElement.insertBefore(ghost, cursor); // painted under the cursor
    setTimeout(() => ghost.remove(), AFTERIMAGE_MS);
  };

  const onCursorStyle = (cursor) => {
    const { top, left, width, height } = cursor.style;
    const prev = last.get(cursor);
    last.set(cursor, { top, left, width, height });
    if (!prev || (prev.top === top && prev.left === left)) return;
    const dx = parseFloat(left) - parseFloat(prev.left);
    const dy = parseFloat(top) - parseFloat(prev.top);
    const motion = Math.abs(dx) >= Math.abs(dy) ? (dx > 0 ? 'right' : 'left') : (dy > 0 ? 'down' : 'up');
    cursor.dataset.motion = motion;
    leaveAfterimage(cursor, prev, motion);
    clearTimeout(timers.get(cursor));
    timers.set(cursor, setTimeout(() => { delete cursor.dataset.motion; }, SETTLE_MS));
  };

  const observer = new MutationObserver((mutations) => {
    for (const { target } of mutations) {
      if (target.classList.contains('cursor')) onCursorStyle(target);
    }
  });

  // Watch only the editors' cursor layers: the rest of the window changes styles on every scrolled frame.
  // An editor's layer exists before the editor can take focus or a click, so new ones are picked up then.
  const watched = new WeakSet();
  const cursorLayers = document.getElementsByClassName('cursors-layer'); // live, cheap to re-read
  const watchCursorLayers = () => {
    for (const layer of cursorLayers) {
      if (watched.has(layer)) continue;
      watched.add(layer);
      observer.observe(layer, { subtree: true, attributes: true, attributeFilter: ['style'] });
    }
  };
  addEventListener('focusin', watchCursorLayers, true);
  addEventListener('mousedown', watchCursorLayers, true);
})();
