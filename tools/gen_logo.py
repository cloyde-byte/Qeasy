#!/usr/bin/env python3
"""Rasteriser Qeasy-logoet (Waypoint Q) til addon-brug + CurseForge.

Producerer:
  ../Media/logo.tga        128x128 32-bit TGA (top-left origin) til minimap-
                           knap og config-header. WoW-kompatibelt format.
  ../logo_curseforge.png   800x260 banner med medaljon + gyldent ordmærke.

Waypoint Q = forgyldt kompas-medaljon; indre guldring danner Q'et, halen er
Qeasys cyan GPS-pil. Farver: WoW-guld + steel-blå + cyan (#6CCBF0).
"""
import math
import os
import struct
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
MEDIA = os.path.join(ROOT, "Media")

GOLD = (227, 163, 34)
GOLD_HI = (252, 233, 150)
GOLD_LO = (108, 67, 16)
BRONZE = (90, 58, 14)
CYAN = (108, 203, 240)
CYAN_HI = (200, 240, 255)
CYAN_LO = (46, 136, 190)
STEEL_HI = (22, 56, 90)
STEEL_LO = (6, 16, 28)

SS = 4  # supersampling


def vgrad(size, stops):
    """Lodret gradient RGBA. stops = [(pos0-1, (r,g,b)), ...]."""
    w, h = size
    img = Image.new("RGBA", size)
    px = img.load()
    stops = sorted(stops)
    for y in range(h):
        t = y / max(1, h - 1)
        for i in range(len(stops) - 1):
            p0, c0 = stops[i]
            p1, c1 = stops[i + 1]
            if p0 <= t <= p1:
                f = (t - p0) / max(1e-6, p1 - p0)
                c = tuple(round(c0[k] + (c1[k] - c0[k]) * f) for k in range(3))
                break
        else:
            c = stops[-1][1]
        for x in range(w):
            px[x, y] = c + (255,)
    return img


def radial_disc(size, cx, cy, r, c_in, c_out):
    """Fyldt cirkel med radial gradient."""
    w, h = size
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    px = img.load()
    for y in range(h):
        for x in range(w):
            d = math.hypot(x - cx, y - cy)
            if d <= r:
                f = min(1.0, d / r)
                c = tuple(round(c_in[k] + (c_out[k] - c_in[k]) * f) for k in range(3))
                px[x, y] = c + (255,)
    return img


def gold_ring(draw, bbox, width, hi_bias=True):
    x0, y0, x1, y1 = bbox
    # bronze yderkant
    draw.ellipse(bbox, outline=BRONZE, width=width + 2 * SS)
    # guld-basis
    draw.ellipse(bbox, outline=GOLD, width=width)
    # top-highlight + bund-skygge (metallisk)
    draw.arc(bbox, start=185, end=355, fill=GOLD_HI, width=max(1, width // 3))
    draw.arc(bbox, start=5, end=175, fill=GOLD_LO, width=max(1, width // 3))


def rot(cx, cy, x, y, ang):
    ca, sa = math.cos(ang), math.sin(ang)
    return (cx + (x - cx) * ca - (y - cy) * sa,
            cy + (x - cx) * sa + (y - cy) * ca)


def gps_arrow(draw, cx, cy, scale, ang):
    """Cyan GPS-pil (kite), peger 'op' før rotation ang (radianer)."""
    pts = [(0, -36), (23, 20), (0, 9), (-23, 20)]
    pts = [(cx + px * scale, cy + py * scale) for px, py in pts]
    pts = [rot(cx, cy, x, y, ang) for x, y in pts]
    draw.polygon(pts, fill=CYAN, outline=(10, 39, 64))
    # midterlinje-highlight
    a = rot(cx, cy, cx, cy - 36 * scale, ang)
    b = rot(cx, cy, cx, cy + 9 * scale, ang)
    draw.line([a, b], fill=CYAN_HI, width=max(1, round(1.4 * SS)))


def render_medallion(px=128):
    S = px * SS
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    c = S / 2
    # steel-disc
    disc = radial_disc((S, S), int(S * 0.42), int(S * 0.36), S * 0.47, STEEL_HI, STEEL_LO)
    mask = Image.new("L", (S, S), 0)
    ImageDraw.Draw(mask).ellipse([c - S * 0.47, c - S * 0.47, c + S * 0.47, c + S * 0.47], fill=255)
    img.paste(disc, (0, 0), mask)

    d = ImageDraw.Draw(img)
    R = S * 0.455
    gold_ring(d, [c - R, c - R, c + R, c + R], int(9 * SS / 2))
    # kompas-ticks
    for ang in (0, 90, 180, 270):
        a = math.radians(ang)
        x0 = c + math.cos(a) * (S * 0.38)
        y0 = c + math.sin(a) * (S * 0.38)
        x1 = c + math.cos(a) * (S * 0.44)
        y1 = c + math.sin(a) * (S * 0.44)
        d.line([(x0, y0), (x1, y1)], fill=GOLD_HI, width=round(3 * SS / 2))
    # indre guldring = Q'et (let forskudt)
    r2 = S * 0.235
    cx2, cy2 = c - S * 0.02, c - S * 0.01
    gold_ring(d, [cx2 - r2, cy2 - r2, cx2 + r2, cy2 + r2], int(12 * SS / 2))
    # cyan GPS-pil (Q'ets hale, NØ)
    gps_arrow(d, c + S * 0.14, c + S * 0.15, SS * 1.02, math.radians(45))

    return img.resize((px, px), Image.LANCZOS)


def write_tga(img, path):
    """Skriv 32-bit uncompressed TGA, top-left origin (WoW-kompatibelt)."""
    w, h = img.size
    img = img.convert("RGBA")
    header = struct.pack("<BBBHHBHHHHBB", 0, 0, 2, 0, 0, 0, 0, 0, w, h, 32, 0x28)
    data = img.tobytes("raw", "BGRA")  # WoW forventer BGRA
    with open(path, "wb") as f:
        f.write(header)
        f.write(data)
    print(f"{path}: {w}x{h}, {len(data)+18} bytes")


def load_font(size):
    for name in ("liberation/LiberationSerif-Bold.ttf",
                 "freefont/FreeSerifBold.ttf"):
        p = "/usr/share/fonts/truetype/" + name
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def gold_text(draw_img, text, font, xy):
    """Tegn tekst med guld-gradient + mørk bevel på draw_img (RGBA)."""
    x, y = xy
    tmp = Image.new("L", draw_img.size, 0)
    ImageDraw.Draw(tmp).text((x, y), text, font=font, fill=255)
    bbox = tmp.getbbox()
    grad = vgrad(draw_img.size, [
        (0.0, GOLD_HI), (0.42, (232, 179, 60)), (0.52, (154, 100, 21)),
        (0.72, (228, 174, 57)), (1.0, GOLD_LO)])
    grad.putalpha(tmp)
    # bevel: mørk offset
    bev = Image.new("RGBA", draw_img.size, (0, 0, 0, 0))
    ImageDraw.Draw(bev).text((x, y + max(2, font.size // 40)), text, font=font, fill=(58, 35, 10, 230))
    draw_img.alpha_composite(bev)
    draw_img.alpha_composite(grad)
    return bbox


def render_gear(px=32):
    """Lille grønt tandhjul til objektiv-markører (transparent baggrund)."""
    S = px * SS
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    c = S / 2
    teeth = 8
    Rout, Rin = S * 0.46, S * 0.33
    tw = (math.pi / teeth) * 0.55
    pts = []
    for k in range(teeth):
        a = 2 * math.pi * k / teeth
        av = 2 * math.pi * (k + 0.5) / teeth
        pts += [(c + math.cos(a - tw) * Rout, c + math.sin(a - tw) * Rout),
                (c + math.cos(a + tw) * Rout, c + math.sin(a + tw) * Rout),
                (c + math.cos(av - tw) * Rin, c + math.sin(av - tw) * Rin),
                (c + math.cos(av + tw) * Rin, c + math.sin(av + tw) * Rin)]
    # mørk kant + grønt fyld
    d.polygon(pts, fill=(58, 210, 82, 255), outline=(14, 74, 26, 255))
    hi = ImageDraw.Draw(img)
    hi.polygon(pts, outline=(150, 255, 170, 180))
    # nav-ring
    rr = Rin * 0.62
    d.ellipse([c - rr, c - rr, c + rr, c + rr], outline=(18, 96, 34, 255), width=int(3 * SS / 2))
    # center-hul (transparent)
    r = S * 0.12
    d.ellipse([c - r, c - r, c + r, c + r], fill=(0, 0, 0, 0))
    return img.resize((px, px), Image.LANCZOS)


def render_sword(px=32):
    """Røde krydsede sværd til 'dræb'-objektiver (a la Questie). Transparent."""
    S = px * SS
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    c = S / 2

    STEEL = (222, 226, 234, 255)
    STEEL_EDGE = (150, 156, 168, 255)
    RED = (196, 32, 32, 255)
    RED_HI = (240, 90, 70, 255)
    DARK = (40, 8, 8, 255)

    def one_sword(ang):
        # lokalt sværd, spids opad; y ned. Roteres om centrum med `ang`.
        bw = S * 0.052   # klingebredde
        gw = S * 0.20    # parérstang halvbredde
        hw = S * 0.030   # skæftebredde
        tipY, guY, guY2, pomY = 0.07 * S, 0.60 * S, 0.66 * S, 0.90 * S
        blade = [(c, tipY), (c + bw, 0.19 * S), (c + bw, guY),
                 (c - bw, guY), (c - bw, 0.19 * S)]
        guard = [(c - gw, guY), (c + gw, guY), (c + gw, guY2), (c - gw, guY2)]
        handle = [(c - hw, guY2), (c + hw, guY2), (c + hw, pomY), (c - hw, pomY)]
        R = lambda pts: [rot(c, c, x, y, math.radians(ang)) for x, y in pts]
        d.polygon(R(blade), fill=STEEL, outline=STEEL_EDGE)
        d.polygon(R(guard), fill=RED, outline=DARK)
        d.polygon(R(handle), fill=(92, 52, 22, 255), outline=DARK)
        pc = rot(c, c, c, pomY + S * 0.02, math.radians(ang))
        pr = S * 0.05
        d.ellipse([pc[0] - pr, pc[1] - pr, pc[0] + pr, pc[1] + pr], fill=RED_HI, outline=DARK)

    one_sword(-38)   # spids op mod venstre
    one_sword(38)    # spids op mod højre
    return img.resize((px, px), Image.LANCZOS)


def render_bang(px=32):
    """Simpelt grønt '!' til uopdagede flyvemestre (i stil med quest-ikonet)."""
    S = px * SS
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    c = S / 2
    GREEN = (58, 210, 82, 255)
    EDGE = (14, 74, 26, 255)
    HI = (150, 255, 170, 220)
    w = max(1, int(SS))
    bw = S * 0.15
    top, bot = S * 0.13, S * 0.58
    d.rounded_rectangle([c - bw, top, c + bw, bot], radius=bw * 0.8,
                        fill=GREEN, outline=EDGE, width=w)
    r = S * 0.155
    dy = S * 0.80
    d.ellipse([c - r, dy - r, c + r, dy + r], fill=GREEN, outline=EDGE, width=w)
    # lys stribe på stangen (metallisk/pop)
    d.line([(c - bw * 0.25, top + bw), (c - bw * 0.25, bot - bw)], fill=HI,
           width=max(1, int(SS * 1.2)))
    return img.resize((px, px), Image.LANCZOS)


def render_curseforge():
    W, H = 800, 260
    img = radial_disc((W, H), int(W * 0.3), int(H * 0.2), max(W, H) * 0.9,
                      (18, 33, 51), (7, 12, 20)).convert("RGBA")
    # medaljon venstre
    med = render_medallion(200)
    img.alpha_composite(med, (28, 30))
    # ordmærke
    font = load_font(132)
    gold_text(img, "Qeasy", font, (250, 44))
    # gylden regel
    d = ImageDraw.Draw(img)
    d.line([(256, 186), (700, 186)], fill=GOLD, width=3)
    d.line([(256, 188), (700, 188)], fill=GOLD_LO, width=1)
    # tagline
    tag = load_font(22)
    d.text((258, 198), "O U T L A N D   ·   L E V E L I N G   ·   G J O R T   L E T",
           font=tag, fill=(201, 168, 94))
    path = os.path.join(ROOT, "logo_curseforge.png")
    img.save(path)
    print(f"{path}: {W}x{H}")


def main():
    os.makedirs(MEDIA, exist_ok=True)
    write_tga(render_medallion(128), os.path.join(MEDIA, "logo.tga"))
    write_tga(render_gear(32), os.path.join(MEDIA, "objective.tga"))
    write_tga(render_sword(32), os.path.join(MEDIA, "slay.tga"))
    write_tga(render_bang(32), os.path.join(MEDIA, "flightpoint.tga"))
    render_curseforge()


if __name__ == "__main__":
    main()
