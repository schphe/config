"use strict";

(() => {
  const palette = globalThis.__STYLIX_PALETTE__;
  if (!palette) return;

  const COLOR = /#[0-9a-f]{8}\b|#[0-9a-f]{6}\b|#[0-9a-f]{3,4}\b|rgba?\([^)]*\)|hsla?\([^)]*\)/gi;

  const CSS_PROPS = [
    "color",
    "background-color",
    "background-image",
    "border-color",
    "border-top-color",
    "border-right-color",
    "border-bottom-color",
    "border-left-color",
    "outline-color",
    "text-decoration-color",
    "caret-color",
    "fill",
    "stroke",
  ];

  const COMPUTED = [
    ["color", "color", "fg"],
    ["backgroundColor", "background-color", "bg"],
    ["backgroundImage", "background-image", "bg"],
    ["borderTopColor", "border-top-color", "edge"],
    ["borderRightColor", "border-right-color", "edge"],
    ["borderBottomColor", "border-bottom-color", "edge"],
    ["borderLeftColor", "border-left-color", "edge"],
  ];

  function hslToRgb(h, s, l) {
    if (s === 0) {
      const v = Math.round(l * 255);
      return [v, v, v];
    }
    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;
    const to = (t) => {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    };
    return [to(h + 1 / 3), to(h), to(h - 1 / 3)].map((x) => Math.round(x * 255));
  }

  function parse(v) {
    if (v[0] === "#") {
      let h = v.slice(1);
      if (h.length === 3 || h.length === 4) h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2] + (h[3] ? h[3] + h[3] : "");
      if (h.length !== 6 && h.length !== 8) return null;
      const n = (i) => parseInt(h.slice(i, i + 2), 16);
      return { r: n(0), g: n(2), b: n(4), a: h.length === 8 ? n(6) / 255 : 1 };
    }
    const nums = v.match(/-?[\d.]+%?/g);
    if (!nums || nums.length < 3) return null;
    const n = (i, scale) => {
      const raw = nums[i];
      if (raw === undefined) return undefined;
      const f = parseFloat(raw);
      return raw.endsWith("%") ? (f / 100) * scale : f;
    };
    if (v[0] === "r") return { r: n(0, 255), g: n(1, 255), b: n(2, 255), a: nums[3] === undefined ? 1 : n(3, 1) };
    if (v[0] === "h") {
      const [r, g, b] = hslToRgb(n(0, 360) / 360, n(1, 1), n(2, 1));
      return { r, g, b, a: nums[3] === undefined ? 1 : n(3, 1) };
    }
    return null;
  }

  function toHsl({ r, g, b }) {
    const R = r / 255,
      G = g / 255,
      B = b / 255;
    const max = Math.max(R, G, B),
      min = Math.min(R, G, B);
    const l = (max + min) / 2;
    if (max === min) return { h: 0, s: 0, l };
    const d = max - min;
    const s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    let h;
    if (max === R) h = ((G - B) / d + (G < B ? 6 : 0)) / 6;
    else if (max === G) h = ((B - R) / d + 2) / 6;
    else h = ((R - G) / d + 4) / 6;
    return { h, s, l };
  }

  const hex = ({ r, g, b }) =>
    "#" + [r, g, b].map((c) => Math.round(Math.min(255, Math.max(0, c))).toString(16).padStart(2, "0")).join("");

  const mix = (a, b, t) => ({ r: a.r + (b.r - a.r) * t, g: a.g + (b.g - a.g) * t, b: a.b + (b.b - a.b) * t });

  const lighten = (c, amount) => {
    const { h, s, l } = toHsl(c);
    const [r, g, b] = hslToRgb(h, s, Math.min(1, l + amount));
    return { r, g, b };
  };

  const bg = parse(palette.background);

  const declared = palette.ramp.slice(0, 3).map(parse);
  const surfaces =
    new Set(declared.map(hex)).size === 3
      ? declared
      : [bg, lighten(bg, 0.03), lighten(bg, 0.06)];

  const edges = [lighten(bg, 0.1), lighten(bg, 0.16), lighten(bg, 0.24)];

  const chromaOf = ({ r, g, b }) => (Math.max(r, g, b) - Math.min(r, g, b)) / 255;

  const isGradientOnly = (value) => value.indexOf("gradient") >= 0 && value.indexOf("url(") < 0;

  const ICON_SEL = ["icon", "symbol", "material", "glyph", "octicon", "awesome", "codicon"]
    .map((word) => `:not([class*="${word}" i])`)
    .join("");
  const fontCss = palette.font
    ? `*${ICON_SEL}:not(i){font-family:"${palette.font}", monospace !important;}`
    : "";

  const foregrounds = palette.ramp.slice(4).map(parse);
  const accents = palette.accents.map((c) => ({ rgb: parse(c), h: toHsl(parse(c)).h }));

  const nearestH = (h) => {
    let best = accents[0],
      dist = Infinity;
    for (const c of accents) {
      let d = Math.abs(c.h - h);
      if (d > 0.5) d = 1 - d;
      if (d < dist) {
        dist = d;
        best = c;
      }
    }
    return best.rgb;
  };

  const roleOf = (prop) =>
    prop.indexOf("background") >= 0
      ? "bg"
      : prop.indexOf("border") >= 0 || prop.indexOf("outline") >= 0 || prop.indexOf("shadow") >= 0
        ? "edge"
        : "fg";

  const map = new Map();

  const produced = new Set();
  const rgbKey = (c) => `${Math.round(c.r)},${Math.round(c.g)},${Math.round(c.b)}`;
  for (const c of [...surfaces, ...edges, ...foregrounds, ...accents.map((a) => a.rgb)]) produced.add(rgbKey(c));

  function mapColor(token, role) {
    const key = role + "|" + token;
    const hit = map.get(key);
    if (hit !== undefined) return hit;

    const src = parse(token.toLowerCase());
    if (!src || Number.isNaN(src.r) || src.a === 0) {
      map.set(key, null);
      return null;
    }
    if (produced.has(rgbKey(src))) {
      map.set(key, null);
      return null;
    }

    const { h, l } = toHsl(src);
    const chroma = chromaOf(src);

    const extreme = Math.min(l, 1 - l);
    let out;

    if (chroma < 0.1) {
      if (role === "bg") {
        out = extreme < 0.16 ? surfaces[0] : extreme < 0.26 ? surfaces[1] : surfaces[2];
      } else if (role === "edge") {
        out = extreme < 0.12 ? edges[0] : extreme < 0.28 ? edges[1] : edges[2];
      } else {
        out =
          extreme < 0.08
            ? foregrounds[3]
            : extreme < 0.2
              ? foregrounds[2]
              : extreme < 0.34
                ? foregrounds[1]
                : foregrounds[0];
      }
    } else {
      const accent = nearestH(h);
      const strength = chroma >= 0.35 ? 1 : role === "bg" ? 0.14 : role === "edge" ? 0.35 : 1;
      out = strength === 1 ? accent : mix(bg, accent, strength);
    }

    produced.add(rgbKey(out));
    const result =
      src.a < 1
        ? `rgba(${Math.round(out.r)}, ${Math.round(out.g)}, ${Math.round(out.b)}, ${src.a})`
        : hex(out);
    map.set(key, result);
    return result;
  }

  const replaceIn = (value, role) => {
    if (value.indexOf("url(") >= 0 && value.indexOf("gradient") < 0) return null;
    COLOR.lastIndex = 0;
    if (!COLOR.test(value)) return null;
    COLOR.lastIndex = 0;
    let changed = false;
    const out = value.replace(COLOR, (t) => {
      const mapped = mapColor(t, role);
      if (mapped && mapped !== t) changed = true;
      return mapped || t;
    });
    return changed ? out : null;
  };

  const STYLE_ID = "stylix-recolor";
  const STYLE_ATTR = "data-stylix-recolor";
  const seenSheets = new WeakSet();
  let overrides = "";

  function harvest(sheet) {
    if (seenSheets.has(sheet)) return "";
    if (styleEl && sheet.ownerNode === styleEl) {
      seenSheets.add(sheet);
      return "";
    }
    let rules;
    try {
      rules = sheet.cssRules;
    } catch {
      seenSheets.add(sheet);
      return "";
    }
    if (!rules) return "";
    seenSheets.add(sheet);

    let css = "";
    const walk = (list) => {
      for (const rule of list) {
        if (rule.cssRules) {
          if (rule.conditionText !== undefined) {
            const inner = [];
            for (const r of rule.cssRules) inner.push(r);
            const before = css;
            css = "";
            walk(inner);
            const body = css;
            css = before + (body ? `@media ${rule.conditionText}{${body}}` : "");
          } else {
            walk(rule.cssRules);
          }
          continue;
        }
        if (!rule.style || !rule.selectorText) continue;

        let decls = "";
        for (const prop of CSS_PROPS) {
          const value = rule.style.getPropertyValue(prop);
          if (!value) continue;
          if (prop === "background-image" && isGradientOnly(value)) {
            decls += "background-image:none !important;";
            continue;
          }
          const mapped = replaceIn(value, roleOf(prop));
          if (mapped) decls += `${prop}:${mapped} !important;`;
        }
        if (decls) css += `${rule.selectorText}{${decls}}`;
      }
    };

    try {
      walk(rules);
    } catch {
      return css;
    }
    return css;
  }

  const baseCss = () => `:root{color-scheme:${palette.polarity};}
html,body{background-color:${palette.background} !important;color:${palette.foreground} !important;}
::selection{background-color:${palette.selection} !important;color:${palette.background} !important;}
html{scrollbar-color:${palette.scrollbar} ${palette.background};}
${fontCss}`;

  let bootEl = null;
  function installBoot() {
    bootEl = document.createElement("style");
    bootEl.setAttribute(STYLE_ATTR, "");
    bootEl.textContent = `*{background-color:${palette.background} !important;color:${palette.foreground} !important;border-color:${hex(edges[1])} !important;}
img,video,canvas,picture,svg,iframe,embed,object{background-color:transparent !important;}`;
    (document.head || document.documentElement).prepend(bootEl);
  }

  let bootRemoved = false;
  function removeBoot() {
    if (bootRemoved || !bootEl) return;
    bootRemoved = true;
    bootEl.remove();
  }

  let styleEl = null;
  function install() {
    if (!styleEl || !styleEl.isConnected) {
      styleEl = document.createElement("style");
      styleEl.id = STYLE_ID;
      styleEl.setAttribute(STYLE_ATTR, "");
      (document.head || document.documentElement).append(styleEl);
    }
    const css = baseCss() + overrides;
    if (styleEl.textContent !== css) styleEl.textContent = css;
  }

  function harvestAll() {
    let added = "";
    for (const sheet of document.styleSheets) added += harvest(sheet);
    for (const sheet of document.adoptedStyleSheets || []) added += harvest(sheet);
    for (const root of shadowRoots) {
      for (const sheet of root.styleSheets || []) added += harvest(sheet);
      for (const sheet of root.adoptedStyleSheets || []) added += harvest(sheet);
    }
    if (added) {
      overrides += added;
      install();
    }
  }

  const done = new WeakSet();
  let queueEls = [];

  function scanElements(root) {
    const els = root.querySelectorAll("*");
    for (const el of els) if (!done.has(el)) queueEls.push(el);
    drain(false);
  }

  let draining = false;

  function drain(fast) {
    if (draining || !queueEls.length) return;
    draining = true;
    const run = fast ? requestAnimationFrame : (fn) => idle(fn, { timeout: 100 });
    run(() => {
      draining = false;
      try {
      const start = performance.now();
      const budget = fast ? 6 : 12;

      const writes = [];
      while (queueEls.length && performance.now() - start < budget) {
        const el = queueEls.pop();
        if (!el || done.has(el) || !el.isConnected) continue;
        done.add(el);
        if (el.id === STYLE_ID || el.tagName === "STYLE" || el.tagName === "SCRIPT") continue;

        let computed;
        try {
          computed = getComputedStyle(el);
        } catch {
          continue;
        }

        let props = null;
        for (const [jsProp, cssProp, role] of COMPUTED) {
          const value = computed[jsProp];
          if (!value || value === "rgba(0, 0, 0, 0)" || value === "transparent" || value === "none") continue;
          if (jsProp === "backgroundImage") {
            if (isGradientOnly(value)) (props ||= []).push(["background-image", "none"]);
            continue;
          }
          const mapped = replaceIn(value, role);
          if (mapped) (props ||= []).push([cssProp, mapped]);
        }
        if (props) writes.push([el, props]);
      }

      for (const [el, props] of writes) {
        for (const [prop, value] of props) el.style.setProperty(prop, value, "important");
      }
      } catch (e) {
        console.debug("stylix-recolor drain", e);
      }
      if (queueEls.length) drain(fast);
      else removeBoot();
    });
  }

  const observer = new MutationObserver((records) => {
    let sheets = false;
    for (const r of records) {
      if (r.type === "attributes") {
        const el = r.target;
        if (el.nodeType !== 1 || el.hasAttribute(STYLE_ATTR)) continue;
        done.delete(el);
        queueEls.push(el);
        if (el.childElementCount && el.childElementCount < 200) {
          for (const child of el.querySelectorAll("*")) {
            done.delete(child);
            queueEls.push(child);
          }
        }
        continue;
      }
      for (const node of r.addedNodes) {
        if (node.nodeType !== 1) continue;
        const tag = node.tagName;
        if (tag === "STYLE" || tag === "LINK") sheets = true;
        else queueEls.push(node);
        if (node.childElementCount) queueEls.push(...node.querySelectorAll("*"));
      }
    }
    if (sheets) schedule();
    else drain(true);
  });

  const OBSERVE = {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ["hidden", "class", "aria-hidden", "aria-expanded", "opened"],
  };

  const shadowRoots = new Set();
  const nativeAttach = Element.prototype.attachShadow;
  Element.prototype.attachShadow = function (init) {
    const root = nativeAttach.call(this, init);
    shadowRoots.add(root);
    try {
      observer.observe(root, OBSERVE);
    } catch {
    }
    schedule();
    return root;
  };

  const idle = globalThis.requestIdleCallback || ((fn) => setTimeout(fn, 16));
  let scheduled = false;
  let attempts = 0;
  function schedule() {
    if (scheduled) return;
    scheduled = true;
    idle(
      () => {
        scheduled = false;
        try {
          install();
          harvestAll();
          if (document.body) scanElements(document.body);
          for (const root of shadowRoots) scanElements(root);
        } catch (e) {
          console.debug("stylix-recolor", e);
        }
      },
      { timeout: 500 },
    );
  }

  installBoot();
  install();
  setTimeout(removeBoot, 3000);

  observer.observe(document.documentElement, OBSERVE);

  document.addEventListener("DOMContentLoaded", schedule, { once: true });
  window.addEventListener("load", schedule, { once: true });
  schedule();

  globalThis.__STYLIX_RECOLOR_STATS__ = () => ({
    mapped: map.size,
    overrideBytes: overrides.length,
    pending: queueEls.length,
    shadow: shadowRoots.size,
  });
})();
