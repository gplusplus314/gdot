#!/usr/bin/env python3
"""
make_border_png.py

Usage:
  ./make_border_png.py X Y THICKNESS RRGGBB [out.png]

Creates an XxY PNG with an outside border of THICKNESS pixels in color RRGGBB.
Interior is fully transparent.

TODO: make this generate the entire quick-access-terminal config
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

from PIL import Image  # pip install pillow


HEX_RE = re.compile(r"^[0-9a-fA-F]{6}$")


def die(msg: str, code: int = 2) -> "NoReturn":
    print(f"error: {msg}", file=sys.stderr)
    raise SystemExit(code)


def parse_int(name: str, s: str) -> int:
    try:
        v = int(s, 10)
    except ValueError:
        die(f"{name} must be an integer, got {s!r}")
    if v < 0:
        die(f"{name} must be >= 0, got {v}")
    return v


def parse_rgb(hex6: str) -> tuple[int, int, int]:
    if not HEX_RE.match(hex6):
        die(f"RRGGBB must be 6 hex digits, got {hex6!r}")
    r = int(hex6[0:2], 16)
    g = int(hex6[2:4], 16)
    b = int(hex6[4:6], 16)
    return r, g, b


def main(argv: list[str]) -> int:
    if len(argv) not in (5, 6):
        die("usage: makepng.py X Y THICKNESS RRGGBB [out.png]")

    x = parse_int("X", argv[1])
    y = parse_int("Y", argv[2])
    t = parse_int("THICKNESS", argv[3])
    rrggbb = argv[4]
    out = Path(argv[5]) if len(argv) == 6 else Path("quick-access-terminal.png")

    if x == 0 or y == 0:
        die("X and Y must be > 0")
    if t > min(x, y) // 2 and t != 0:
        # Still valid if you want a fully-filled image, but it's usually accidental.
        # We'll clamp rather than error.
        t = min(x, y) // 2

    r, g, b = parse_rgb(rrggbb)

    img = Image.new("RGBA", (x, y), (0, 0, 0, 0))

    if t > 0:
        px = img.load()

        # Top + bottom rows
        for yy in range(0, t):
            for xx in range(0, x):
                px[xx, yy] = (r, g, b, 255)
        for yy in range(y - t, y):
            for xx in range(0, x):
                px[xx, yy] = (r, g, b, 255)

        # Left + right columns (excluding already painted corners to save work)
        for yy in range(t, y - t):
            for xx in range(0, t):
                px[xx, yy] = (r, g, b, 255)
            for xx in range(x - t, x):
                px[xx, yy] = (r, g, b, 255)

    img.save(out, format="PNG")
    print(out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
