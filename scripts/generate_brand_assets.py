#!/usr/bin/env python3
"""Generate deterministic Notaku Sejarah branding PNGs using stdlib only."""
from __future__ import annotations

import math
import struct
import zlib
from pathlib import Path

NAVY = (0x10, 0x2A, 0x43, 255)
BLUE = (0x1F, 0x4E, 0x79, 255)
GOLD = (0xC4, 0x9A, 0x3A, 255)
SOFT_GOLD = (0xE8, 0xD3, 0xA2, 255)
CREAM = (0xF7, 0xF1, 0xE3, 255)
TRANSPARENT = (0, 0, 0, 0)
SUPERSAMPLE = 2


def canvas(size: int, color: tuple[int, int, int, int]) -> list[bytearray]:
    row = bytearray(color * size)
    return [bytearray(row) for _ in range(size)]


def set_pixel(img, x: int, y: int, color) -> None:
    if 0 <= y < len(img) and 0 <= x < len(img):
        offset = x * 4
        img[y][offset : offset + 4] = bytes(color)


def fill_circle(img, cx: float, cy: float, radius: float, color) -> None:
    y0 = max(0, int(cy - radius))
    y1 = min(len(img) - 1, int(cy + radius))
    rr = radius * radius
    for y in range(y0, y1 + 1):
        dy = y - cy
        span = math.sqrt(max(0.0, rr - dy * dy))
        x0 = max(0, int(cx - span))
        x1 = min(len(img) - 1, int(cx + span))
        for x in range(x0, x1 + 1):
            set_pixel(img, x, y, color)


def draw_line(img, p0, p1, width: float, color) -> None:
    x0, y0 = p0
    x1, y1 = p1
    distance = max(1, int(math.hypot(x1 - x0, y1 - y0)))
    radius = max(1.0, width / 2)
    for step in range(distance + 1):
        t = step / distance
        fill_circle(
            img,
            x0 + (x1 - x0) * t,
            y0 + (y1 - y0) * t,
            radius,
            color,
        )


def fill_polygon(img, points, color) -> None:
    min_y = max(0, int(min(y for _, y in points)))
    max_y = min(len(img) - 1, int(max(y for _, y in points)))
    for y in range(min_y, max_y + 1):
        intersections = []
        for i, (x1, y1) in enumerate(points):
            x2, y2 = points[(i + 1) % len(points)]
            if y1 == y2:
                continue
            if min(y1, y2) <= y < max(y1, y2):
                t = (y - y1) / (y2 - y1)
                intersections.append(x1 + (x2 - x1) * t)
        intersections.sort()
        for i in range(0, len(intersections) - 1, 2):
            x0 = max(0, int(math.ceil(intersections[i])))
            x1 = min(len(img) - 1, int(math.floor(intersections[i + 1])))
            for x in range(x0, x1 + 1):
                set_pixel(img, x, y, color)


def draw_arc(img, cx, cy, radius, start_deg, end_deg, width, color) -> None:
    points = []
    for degree in range(start_deg, end_deg + 1):
        angle = math.radians(degree)
        points.append(
            (
                cx + math.cos(angle) * radius,
                cy + math.sin(angle) * radius,
            )
        )
    for first, second in zip(points, points[1:]):
        draw_line(img, first, second, width, color)


def brand_mark(size: int, background: bool) -> list[bytearray]:
    scale = (size * SUPERSAMPLE) / 1024
    pixels = size * SUPERSAMPLE
    img = canvas(pixels, NAVY if background else TRANSPARENT)

    if background:
        fill_circle(img, 512 * scale, 512 * scale, 362 * scale, BLUE)
        draw_arc(
            img,
            512 * scale,
            512 * scale,
            322 * scale,
            0,
            359,
            10 * scale,
            SOFT_GOLD,
        )

    draw_arc(
        img,
        512 * scale,
        520 * scale,
        206 * scale,
        200,
        340,
        18 * scale,
        GOLD,
    )
    draw_line(
        img,
        (365 * scale, 435 * scale),
        (365 * scale, 550 * scale),
        18 * scale,
        GOLD,
    )
    draw_line(
        img,
        (659 * scale, 435 * scale),
        (659 * scale, 550 * scale),
        18 * scale,
        GOLD,
    )

    star = []
    for i in range(16):
        angle = -math.pi / 2 + i * math.pi / 8
        radius = (42 if i % 2 == 0 else 18) * scale
        star.append(
            (
                512 * scale + math.cos(angle) * radius,
                320 * scale + math.sin(angle) * radius,
            )
        )
    fill_polygon(img, star, GOLD)

    left = [
        (250, 540),
        (465, 475),
        (505, 515),
        (505, 735),
        (285, 790),
        (250, 745),
    ]
    right = [
        (774, 540),
        (559, 475),
        (519, 515),
        (519, 735),
        (739, 790),
        (774, 745),
    ]
    fill_polygon(img, [(x * scale, y * scale) for x, y in left], CREAM)
    fill_polygon(img, [(x * scale, y * scale) for x, y in right], CREAM)

    draw_line(
        img,
        (505 * scale, 515 * scale),
        (505 * scale, 735 * scale),
        10 * scale,
        GOLD,
    )
    draw_line(
        img,
        (519 * scale, 515 * scale),
        (519 * scale, 735 * scale),
        10 * scale,
        GOLD,
    )
    draw_line(
        img,
        (270 * scale, 555 * scale),
        (465 * scale, 500 * scale),
        8 * scale,
        GOLD,
    )
    draw_line(
        img,
        (754 * scale, 555 * scale),
        (559 * scale, 500 * scale),
        8 * scale,
        GOLD,
    )

    return downsample(img, size)


def downsample(img: list[bytearray], target: int) -> list[bytearray]:
    factor = len(img) // target
    if factor == 1:
        return img

    result = canvas(target, TRANSPARENT)
    samples = factor * factor
    for y in range(target):
        for x in range(target):
            channels = [0, 0, 0, 0]
            for sy in range(factor):
                row = img[y * factor + sy]
                for sx in range(factor):
                    offset = (x * factor + sx) * 4
                    for channel in range(4):
                        channels[channel] += row[offset + channel]
            set_pixel(
                result,
                x,
                y,
                tuple(value // samples for value in channels),
            )
    return result


def write_png(path: Path, img: list[bytearray]) -> None:
    size = len(img)
    raw = b"".join(b"\x00" + bytes(row) for row in img)

    def chunk(kind: bytes, data: bytes) -> bytes:
        checksum = zlib.crc32(kind + data) & 0xFFFFFFFF
        return (
            struct.pack(">I", len(data))
            + kind
            + data
            + struct.pack(">I", checksum)
        )

    png = b"\x89PNG\r\n\x1a\n"
    png += chunk(
        b"IHDR",
        struct.pack(">IIBBBBB", size, size, 8, 6, 0, 0, 0),
    )
    png += chunk(b"IDAT", zlib.compress(raw, 9))
    png += chunk(b"IEND", b"")

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png)


def main() -> None:
    output = Path("build/brand_assets")
    write_png(output / "app_icon.png", brand_mark(1024, True))
    write_png(
        output / "app_icon_foreground.png",
        brand_mark(1024, False),
    )
    write_png(output / "brand_mark.png", brand_mark(512, False))
    write_png(output / "Icon-512.png", brand_mark(512, True))
    write_png(output / "Icon-192.png", brand_mark(192, True))
    write_png(output / "favicon.png", brand_mark(64, True))
    print(f"Generated Notaku Sejarah brand assets in {output}")


if __name__ == "__main__":
    main()
