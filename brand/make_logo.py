# Build the C3D Field Kit logo: outlined wordmark (font-independent SVG) + PNG renders.
import os, math
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer
from fontTools.pens.svgPathPen import SVGPathPen

OUT = r"C:\Users\michael.flynn\Desktop\AI\C3D-AutoCAD\brand"
PNG = os.path.join(OUT, "png")
os.makedirs(PNG, exist_ok=True)
SCRATCH = os.path.dirname(os.path.abspath(__file__))

NAVY   = "#0D1B2A"
NAVY_D = "#091420"
WHITE  = "#F4F8FA"
GREEN  = "#4FB67A"
GREEN_B= "#5FC98A"

# ---------------------------------------------------------------- fonts
def instanced(wght, wdth, tag):
    src = r"C:\Windows\Fonts\bahnschrift.ttf"
    f = TTFont(src)
    try:
        f = instancer.instantiateVariableFont(f, {"wght": wght, "wdth": wdth})
    except Exception as e:
        print("  instancer failed, using static Segoe UI Bold:", e)
        f = TTFont(r"C:\Windows\Fonts\segoeuib.ttf")
    p = os.path.join(SCRATCH, f"_c3dfk_{tag}.ttf")
    f.save(p)
    return f, p

FONT_HEAVY, PATH_HEAVY = instanced(700, 100, "heavy")   # C3D
FONT_MED,   PATH_MED   = instanced(600,  87, "med")     # FIELD KIT

def cap_height(font):
    try:
        ch = font["OS/2"].sCapHeight
        if ch:
            return ch
    except Exception:
        pass
    return int(font["head"].unitsPerEm * 0.7)

def glyph_paths(font, text, cap_px, tracking_em=0.0):
    """Return (list of (path_d, dx), total_advance_px, scale) at a target cap height."""
    upem = font["head"].unitsPerEm
    scale = cap_px / cap_height(font)
    gs = font.getGlyphSet()
    cmap = font.getBestCmap()
    hmtx = font["hmtx"]
    out, x = [], 0.0
    track = tracking_em * upem
    for ch in text:
        if ch == " ":
            x += hmtx[cmap[ord(" ")]][0] + track
            continue
        gname = cmap[ord(ch)]
        pen = SVGPathPen(gs)
        gs[gname].draw(pen)
        d = pen.getCommands()
        if d:
            out.append((d, x))
        x += hmtx[gname][0] + track
    return out, x * scale, scale

def text_group(font, text, cap_px, x, baseline_y, fill, tracking_em=0.0, anchor="start"):
    paths, width, scale = glyph_paths(font, text, cap_px, tracking_em)
    if anchor == "middle":
        x -= width / 2.0
    g = [f'<g fill="{fill}" transform="translate({x:.2f},{baseline_y:.2f}) scale({scale:.5f},{-scale:.5f})">']
    for d, dx in paths:
        g.append(f'<path transform="translate({dx:.1f},0)" d="{d}"/>')
    g.append("</g>")
    return "\n".join(g), width

# ---------------------------------------------------------------- the mark
# A deed/parcel traverse (white) with a survey point set inside it (green).
PARCEL = [(16, 46), (38, 18), (82, 30), (76, 72), (34, 82)]

def mark_svg(size, x0=0, y0=0, plate=True, grid=True, r_ratio=0.22, simple=False):
    """The mark drawn in a `size` box at (x0,y0). Geometry authored on a 100 grid."""
    s = size / 100.0
    def P(p):
        return f"{x0 + p[0]*s:.2f},{y0 + p[1]*s:.2f}"
    parts = []
    if plate:
        r = size * r_ratio
        cid = f"plate{int(size)}_{int(x0)}_{int(y0)}"
        parts.append(f'<clipPath id="{cid}"><rect x="{x0:.2f}" y="{y0:.2f}" width="{size:.2f}" '
                     f'height="{size:.2f}" rx="{r:.2f}"/></clipPath>')
        parts.append(f'<rect x="{x0:.2f}" y="{y0:.2f}" width="{size:.2f}" height="{size:.2f}" '
                     f'rx="{r:.2f}" fill="{NAVY}"/>')
        if grid:
            parts.append(f'<g clip-path="url(#{cid})" stroke="#FFFFFF" stroke-opacity="0.08" stroke-width="{max(0.8, size*0.005):.2f}">')
            for i in range(1, 8):
                v = x0 + size * i / 8.0
                h = y0 + size * i / 8.0
                parts.append(f'<line x1="{v:.2f}" y1="{y0:.2f}" x2="{v:.2f}" y2="{y0+size:.2f}"/>')
                parts.append(f'<line x1="{x0:.2f}" y1="{h:.2f}" x2="{x0+size:.2f}" y2="{h:.2f}"/>')
            parts.append("</g>")
    # total-station sight lines, then the deed traverse over them
    cx, cy = x0 + 51 * s, y0 + 48 * s
    if not simple:
        parts.append(f'<g stroke="{GREEN}" stroke-opacity="0.6" stroke-width="{size*0.026:.2f}" stroke-linecap="round">')
        parts.append(f'<line x1="{x0+size*0.09:.2f}" y1="{cy:.2f}" x2="{x0+size*0.91:.2f}" y2="{cy:.2f}"/>')
        parts.append(f'<line x1="{cx:.2f}" y1="{y0+size*0.09:.2f}" x2="{cx:.2f}" y2="{y0+size*0.91:.2f}"/>')
        parts.append("</g>")
    pts = " ".join(P(p) for p in PARCEL)
    w_par = size * (0.105 if simple else 0.076)
    parts.append(f'<polygon points="{pts}" fill="none" stroke="{WHITE}" '
                 f'stroke-width="{w_par:.2f}" stroke-linejoin="round"/>')
    if simple:
        parts.append(f'<circle cx="{cx:.2f}" cy="{cy:.2f}" r="{size*0.150:.2f}" fill="{GREEN}"/>')
    else:
        parts.append(f'<circle cx="{cx:.2f}" cy="{cy:.2f}" r="{size*0.100:.2f}" fill="none" '
                     f'stroke="{GREEN}" stroke-width="{size*0.048:.2f}"/>')
        parts.append(f'<circle cx="{cx:.2f}" cy="{cy:.2f}" r="{size*0.032:.2f}" fill="{GREEN}"/>')
    return "\n".join(parts)

def svg(w, h, body, bg=None):
    b = f'<rect width="{w}" height="{h}" fill="{bg}"/>' if bg else ""
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" '
            f'width="{w}" height="{h}" role="img" aria-label="C3D Field Kit">\n{b}\n{body}\n</svg>\n')

def write(name, content):
    p = os.path.join(OUT, name)
    with open(p, "w", encoding="utf-8") as f:
        f.write(content)
    print("  wrote", p)

# ---------------------------------------------------------------- 1. mark only
write("c3dfk_mark.svg", svg(512, 512, mark_svg(512)))
write("c3dfk_mark_flat.svg", svg(512, 512, mark_svg(512, simple=True)))

# ---------------------------------------------------------------- 2. app icon with words
body = [mark_svg(512, 0, 0)]
# lift the mark, make room for type
body = [f'<rect width="512" height="512" rx="112" fill="{NAVY}"/>']
body.append('<clipPath id="iconplate"><rect width="512" height="512" rx="112"/></clipPath>')
body.append(f'<g clip-path="url(#iconplate)" stroke="#FFFFFF" stroke-opacity="0.08" stroke-width="2.5">')
for i in range(1, 8):
    v = 512 * i / 8.0
    body.append(f'<line x1="{v:.1f}" y1="0" x2="{v:.1f}" y2="512"/>')
    body.append(f'<line x1="0" y1="{v:.1f}" x2="512" y2="{v:.1f}"/>')
body.append("</g>")
body.append(mark_svg(232, 140, 52, plate=False))
t1, w1 = text_group(FONT_HEAVY, "C3D", 74, 256, 372, WHITE, anchor="middle")
body.append(t1)
body.append(f'<rect x="{256-56}" y="392" width="112" height="7" fill="{GREEN}"/>')
t2, w2 = text_group(FONT_MED, "FIELD KIT", 34, 256, 452, "#B9CBD6", tracking_em=0.10, anchor="middle")
body.append(t2)
write("c3dfk_icon.svg", svg(512, 512, "\n".join(body)))

# ---------------------------------------------------------------- 3. horizontal lockups
def lockup(fg_main, fg_sub, with_plate, filename, bg=None):
    body = []
    if with_plate:
        body.append(mark_svg(180, 30, 30))
    else:
        body.append(mark_svg(180, 30, 30, plate=False))
    tx = 250
    t1, w1 = text_group(FONT_HEAVY, "C3D", 78, tx, 122, fg_main)
    t2, w2 = text_group(FONT_MED, "FIELD KIT", 40, tx, 202, fg_sub, tracking_em=0.11)
    body += [t1, f'<rect x="{tx}" y="140" width="96" height="8" fill="{GREEN}"/>', t2]
    w = int(tx + max(w1, w2) + 40)
    write(filename, svg(w, 240, "\n".join(body), bg=bg))
    return w

W_LOCK = lockup(WHITE, "#B9CBD6", True, "c3dfk_lockup_dark.svg")
lockup(NAVY, "#40586B", True, "c3dfk_lockup_light.svg")
lockup(WHITE, "#B9CBD6", True, "c3dfk_lockup_on_navy.svg", bg=NAVY)

# ---------------------------------------------------------------- 4. PNG renders
from PIL import Image, ImageDraw, ImageFont

def rr(draw, box, r, fill):
    draw.rounded_rectangle(box, radius=r, fill=fill)

def hexrgb(h, a=255):
    h = h.lstrip("#")
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), a)

def grid_layer(img, box, radius, step=8, alpha=20, w=None):
    """Faint drafting grid, alpha-composited and clipped to the rounded plate."""
    x0, y0, x1, y1 = box
    size = x1 - x0
    lay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    ld = ImageDraw.Draw(lay)
    wl = w or max(1, int(size * 0.005))
    for i in range(1, step):
        v = x0 + size * i / step
        h = y0 + size * i / step
        ld.line([v, y0, v, y1], fill=(255, 255, 255, alpha), width=wl)
        ld.line([x0, h, x1, h], fill=(255, 255, 255, alpha), width=wl)
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(box, radius=radius, fill=255)
    lay.putalpha(Image.composite(lay.split()[3], Image.new("L", img.size, 0), mask))
    img.alpha_composite(lay)


def draw_mark(d, size, x0, y0, plate=True, grid=True, simple=False, img=None):
    s = size / 100.0
    if plate:
        rr(d, [x0, y0, x0 + size, y0 + size], int(size * 0.22), hexrgb(NAVY))
        if grid and img is not None:
            grid_layer(img, [x0, y0, x0 + size, y0 + size], int(size * 0.22))
    cx, cy = x0 + 51 * s, y0 + 48 * s
    wl = max(1, int(size * 0.026))
    if not simple:
        g = hexrgb(GREEN, 165)
        d.line([x0 + size * 0.09, cy, x0 + size * 0.91, cy], fill=g, width=wl)
        d.line([cx, y0 + size * 0.09, cx, y0 + size * 0.91], fill=g, width=wl)
    pts = [(x0 + p[0] * s, y0 + p[1] * s) for p in PARCEL]
    d.line(pts + [pts[0]], fill=hexrgb(WHITE),
           width=max(2, int(size * (0.105 if simple else 0.076))), joint="curve")
    if simple:
        r = size * 0.150
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=hexrgb(GREEN))
    else:
        r, wr = size * 0.100, max(2, int(size * 0.048))
        d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=hexrgb(GREEN), width=wr)
        r = size * 0.032
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=hexrgb(GREEN))


def ptext(d, font, text, cap_px, cx, baseline, fill, tracking=0.0, anchor="mm"):
    f = ImageFont.truetype(font, int(cap_px / 0.70))
    widths = []
    for ch in text:
        widths.append(d.textlength(ch, font=f) + tracking * cap_px)
    total = sum(widths) - (tracking * cap_px if text else 0)
    x = cx - total / 2.0
    for ch, w in zip(text, widths):
        d.text((x, baseline), ch, font=f, fill=fill, anchor="ls")
        x += w

def render_icon(px, words=True, simple=False):
    S = 4 if px <= 256 else 2
    W = px * S
    img = Image.new("RGBA", (W, W), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    k = W / 512.0
    rr(d, [0, 0, W, W], int(112 * k), hexrgb(NAVY))
    grid_layer(img, [0, 0, W, W], int(112 * k), w=max(1, int(2.5 * k)))
    if words:
        draw_mark(d, 232 * k, 140 * k, 52 * k, plate=False, simple=simple)
        ptext(d, PATH_HEAVY, "C3D", 74 * k, W / 2, 372 * k, hexrgb(WHITE))
        d.rectangle([W / 2 - 56 * k, 392 * k, W / 2 + 56 * k, 399 * k], fill=hexrgb(GREEN))
        ptext(d, PATH_MED, "FIELD KIT", 34 * k, W / 2, 452 * k, hexrgb("#B9CBD6"), tracking=0.10)
    else:
        ms = 408 if simple else 344
        off = (512 - ms) / 2.0
        draw_mark(d, ms * k, off * k, off * k, plate=False, simple=simple)
    return img.resize((px, px), Image.LANCZOS)

for px in (1024, 512, 256, 128):
    render_icon(px).save(os.path.join(PNG, f"c3dfk_icon_{px}.png"))
for px in (512, 256, 128, 64, 48, 32, 16):
    render_icon(px, words=False, simple=(px <= 48)).save(os.path.join(PNG, f"c3dfk_mark_{px}.png"))
render_icon(256, words=False).save(os.path.join(PNG, "c3dfk_mark_256.png"))

def render_lockup(px_h, on_navy, fname, main, sub):
    S = 3
    W, H = int(W_LOCK * px_h / 240 * S), int(px_h * S)
    img = Image.new("RGBA", (W, H), hexrgb(NAVY) if on_navy else (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    k = H / 240.0
    draw_mark(d, 180 * k, 30 * k, 30 * k, img=img)
    tx = 250 * k
    f1 = ImageFont.truetype(PATH_HEAVY, int(78 * k / 0.70))
    d.text((tx, 122 * k), "C3D", font=f1, fill=hexrgb(main), anchor="ls")
    d.rectangle([tx, 140 * k, tx + 96 * k, 148 * k], fill=hexrgb(GREEN))
    f2 = ImageFont.truetype(PATH_MED, int(40 * k / 0.70))
    x = tx
    for ch in "FIELD KIT":
        d.text((x, 202 * k), ch, font=f2, fill=hexrgb(sub), anchor="ls")
        x += d.textlength(ch, font=f2) + 0.11 * 40 * k
    img.resize((W // S, H // S), Image.LANCZOS).save(os.path.join(PNG, fname))

render_lockup(240, False, "c3dfk_lockup_dark_240.png", WHITE, "#B9CBD6")
render_lockup(240, True,  "c3dfk_lockup_on_navy_240.png", WHITE, "#B9CBD6")
render_lockup(480, False, "c3dfk_lockup_dark_480.png", WHITE, "#B9CBD6")
render_lockup(240, False, "c3dfk_lockup_light_240.png", NAVY, "#40586B")

# favicon-style .ico for the product page
ic = [render_icon(px, words=False, simple=(px <= 48)) for px in (16, 32, 48, 64, 128, 256)]
ic[0].save(os.path.join(PNG, "c3dfk.ico"), sizes=[(s, s) for s in (16, 32, 48, 64, 128, 256)],
           append_images=ic[1:])
print("\nPNG folder:", PNG)
print("files:", sorted(os.listdir(PNG)))
