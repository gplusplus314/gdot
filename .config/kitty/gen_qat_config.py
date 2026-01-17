#!/usr/bin/env python3
"""
gen_qat_config.py

Usage:
  ./gen_qat_config.py <preset_name>

Generates quick-access-terminal.conf and quick-access-terminal.png
based on a named preset, auto-detecting screen resolution.
"""

from __future__ import annotations

import os
import platform
import re
import subprocess
import sys
from pathlib import Path

from PIL import Image  # pip install pillow


# ==============================================================================
# PRESETS - Edit this dictionary to add/modify configurations
# ==============================================================================
PRESETS = {
    "macos_4k_115": {
        "width": 2500,  # PNG width in pixels
        "height": 500,  # PNG height in pixels
        "scale_factor": 1.15,  # macOS display scaling
        "bottom_margin": 107,  # bottom margin in pixels
        "border_thickness": 2,
        "border_color": "FF8822",
    },
    # Add more presets here...
}


# ==============================================================================
# Screen Resolution Detection
# ==============================================================================


def get_screen_resolution_macos() -> tuple[int, int]:
    """Get logical screen resolution on macOS using system_profiler.

    Returns the logical resolution (native pixels / retina scale factor).
    """
    try:
        result = subprocess.run(
            ["system_profiler", "SPDisplaysDataType"],
            capture_output=True,
            text=True,
            check=True,
        )
        # Look for resolution like "Resolution: 3840 x 2160"
        match = re.search(r"Resolution:\s*(\d+)\s*x\s*(\d+)", result.stdout)
        if match:
            native_width = int(match.group(1))
            native_height = int(match.group(2))
            # Check for Retina display (look for "Retina" in output)
            if "Retina" in result.stdout:
                # Retina displays use 2x scaling for physical pixels
                return native_width // 2, native_height // 2
            return native_width, native_height
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass
    raise RuntimeError("Could not detect screen resolution on macOS")


def get_screen_resolution_linux() -> tuple[int, int]:
    """Get screen resolution on Linux from SCREEN_WIDTH/SCREEN_HEIGHT env vars."""
    width = os.environ.get("SCREEN_WIDTH")
    height = os.environ.get("SCREEN_HEIGHT")
    if width and height:
        try:
            return int(width), int(height)
        except ValueError:
            pass
    raise RuntimeError(
        "Could not detect screen resolution on Linux. "
        "Set SCREEN_WIDTH and SCREEN_HEIGHT environment variables."
    )


def get_screen_resolution() -> tuple[int, int]:
    """Get screen resolution based on current platform."""
    system = platform.system()
    if system == "Darwin":
        return get_screen_resolution_macos()
    elif system == "Linux":
        return get_screen_resolution_linux()
    else:
        raise RuntimeError(f"Unsupported platform: {system}")


# ==============================================================================
# PNG Generation
# ==============================================================================

HEX_RE = re.compile(r"^[0-9a-fA-F]{6}$")


def parse_rgb(hex6: str) -> tuple[int, int, int]:
    """Parse a 6-digit hex color to RGB tuple."""
    if not HEX_RE.match(hex6):
        raise ValueError(f"RRGGBB must be 6 hex digits, got {hex6!r}")
    r = int(hex6[0:2], 16)
    g = int(hex6[2:4], 16)
    b = int(hex6[4:6], 16)
    return r, g, b


def generate_png(
    width: int,
    height: int,
    thickness: int,
    color_hex: str,
    output_path: Path,
) -> None:
    """Generate a PNG with a colored border and transparent interior."""
    r, g, b = parse_rgb(color_hex)
    img = Image.new("RGBA", (width, height), (0, 0, 0, 0))

    if thickness > 0:
        # Clamp thickness if it would fill the entire image
        t = min(thickness, min(width, height) // 2)
        px = img.load()

        # Top + bottom rows
        for yy in range(0, t):
            for xx in range(0, width):
                px[xx, yy] = (r, g, b, 255)
        for yy in range(height - t, height):
            for xx in range(0, width):
                px[xx, yy] = (r, g, b, 255)

        # Left + right columns (excluding corners)
        for yy in range(t, height - t):
            for xx in range(0, t):
                px[xx, yy] = (r, g, b, 255)
            for xx in range(width - t, width):
                px[xx, yy] = (r, g, b, 255)

    img.save(output_path, format="PNG")


# ==============================================================================
# Config Generation
# ==============================================================================

CONFIG_TEMPLATE = """\
hide_on_focus_loss yes
edge bottom
kitty_override background_blur 16

lines {lines}px
margin_left {margin_left}
margin_right {margin_right}
margin_bottom {margin_bottom}
kitty_override window_margin_width {inner_margin}
kitty_override tab_bar_margin_height {inner_margin} 0
kitty_override tab_bar_margin_width {inner_margin}
kitty_override background_image quick-access-terminal.png
kitty_override background_image_layout clamped
"""


def generate_config(
    lines: int,
    margin_left: int,
    margin_right: int,
    margin_bottom: int,
    inner_margin: int,
    output_path: Path,
) -> None:
    """Generate the quick-access-terminal.conf file."""
    content = CONFIG_TEMPLATE.format(
        lines=lines,
        margin_left=margin_left,
        margin_right=margin_right,
        margin_bottom=margin_bottom,
        inner_margin=inner_margin,
    )
    output_path.write_text(content)


# ==============================================================================
# Main
# ==============================================================================


def die(msg: str, code: int = 2) -> "NoReturn":
    print(f"error: {msg}", file=sys.stderr)
    raise SystemExit(code)


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("Usage: gen_qat_config.py <preset_name>", file=sys.stderr)
        print(f"Available presets: {', '.join(PRESETS.keys())}", file=sys.stderr)
        return 2

    preset_name = argv[1]
    if preset_name not in PRESETS:
        die(f"Unknown preset: {preset_name!r}. Available: {', '.join(PRESETS.keys())}")

    preset = PRESETS[preset_name]
    png_width = preset["width"]
    png_height = preset["height"]
    border_thickness = preset["border_thickness"]
    border_color = preset["border_color"]
    scale_factor = preset["scale_factor"]
    bottom_margin = preset["bottom_margin"]

    # Detect screen resolution
    try:
        screen_width, screen_height = get_screen_resolution()
    except RuntimeError as e:
        die(str(e))

    print(f"Detected screen resolution: {screen_width}x{screen_height}")

    # Calculate derived values
    lines = int(png_height * scale_factor)
    margin_left = (screen_width - png_width) // 2
    margin_right = margin_left
    inner_margin = 2 * border_thickness

    print(f"Calculated values:")
    print(f"  lines: {lines}px")
    print(f"  margin_left: {margin_left}")
    print(f"  margin_right: {margin_right}")
    print(f"  margin_bottom: {bottom_margin}")

    # Output paths (same directory as this script)
    script_dir = Path(__file__).parent
    png_path = script_dir / "quick-access-terminal.png"
    conf_path = script_dir / "quick-access-terminal.conf"

    # Generate files
    generate_png(png_width, png_height, border_thickness, border_color, png_path)
    print(f"Generated: {png_path}")

    generate_config(
        lines, margin_left, margin_right, bottom_margin, inner_margin, conf_path
    )
    print(f"Generated: {conf_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
