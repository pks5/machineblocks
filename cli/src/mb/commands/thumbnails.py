import os
import sys
import subprocess
from typing import Optional

from PIL import Image, ImageDraw, ImageFont

def _get_openscad_path() -> str:
    """
    Repliziert die Logik des Bash-Skripts:
    - macOS: /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
    - sonst: "C:/Program Files/OpenSCAD/openscad.exe"
    Optional: Umgebungsvariable OPENSCAD_PATH überschreibt den Wert.
    """
    if sys.platform.startswith("darwin"):
        default_path = "/Applications/OpenSCAD-Preview.app/Contents/MacOS/OpenSCAD"
    else:
        # TODO Support Linux (wie im Bash-Skript)
        default_path = "C:/Program Files/OpenSCAD/openscad.exe"
    return os.environ.get("OPENSCAD_PATH", default_path)

def _safe_title_32(s: str) -> str:
    base = os.path.basename(s)
    if base.lower().endswith(".scad"):
        base = base[:-5]
    base = base.replace("-", " ")
    return base[:32].title()

def _ensure_font(font_path: str, font_file: str, size: int) -> ImageFont.FreeTypeFont:
    font = font_path + font_file
    
    if font and os.path.exists(font):
        try:
            return ImageFont.truetype(font, size=size)
        except Exception:
            pass
    return ImageFont.load_default()

def _hex_with_alpha(hex_color: str) -> tuple:
    hc = hex_color.lstrip("#")
    if len(hc) == 8:
        r, g, b, a = int(hc[0:2], 16), int(hc[2:4], 16), int(hc[4:6], 16), int(hc[6:8], 16)
    elif len(hc) == 6:
        r, g, b, a = int(hc[0:2], 16), int(hc[2:4], 16), int(hc[4:6], 16), 255
    else:
        r, g, b, a = 0, 0, 0, 255
    return (r, g, b, a)

def _text_size(font: ImageFont.ImageFont, text: str) -> tuple:
    try:
        bbox = font.getbbox(text)
        return (bbox[2] - bbox[0], bbox[3] - bbox[1])
    except Exception:
        return font.getsize(text)

def generate_thumbnails(
    root_dir: str,
    target_dir: Optional[str] = None,
    image_width: int = 2400,
    image_height: int = 1800,
    image_border: int = 60,
    font_path: Optional[str] = None,
) -> None:
    """
    Findet rekursiv alle .scad-Dateien ab root_dir, rendert PNGs via OpenSCAD
    und erzeugt mit PIL beschriftete WebP-Thumbnails (halbe Breite).

    - Wenn target_dir gesetzt ist, werden PNG/WebP dort gespeichert.
      Die Unterordner-Struktur ab root_dir wird im target_dir nachgebildet,
      um Namenskonflikte zu vermeiden. Temporäre PNGs liegen ebenfalls dort.
    - Wenn target_dir nicht gesetzt ist, werden Dateien im jeweiligen SCAD-Ordner erzeugt.
    """
    if not os.path.isdir(root_dir):
        print(f"[thumbnails/generate] Directory does not exist: {root_dir}")
        return

    openscad = _get_openscad_path()
    if not os.path.exists(openscad) and not os.access(openscad, os.X_OK):
        print(f"[thumbnails/generate] Warning: OpenSCAD not found/executable at '{openscad}'.")

    image_width_full = image_width + 2 * image_border
    image_height_full = image_height + 2 * image_border
    image_width_half = image_width_full // 2

    border_color = (0xE5, 0xE5, 0xCE, 255)  # '#e5e5ce'
    overlay_color = _hex_with_alpha("#000000d0")

    font_big = _ensure_font(font_path, "RBNo3.1-Medium.otf", 140)
    font_mb = _ensure_font(font_path, "RBNo3.1-Book.otf", 140)
    font_small = _ensure_font(font_path, "RBNo3.1-Light.otf", 70)

    for current_root, _, files in os.walk(root_dir):
        files.sort()
        # Ausgabe-Unterordner bestimmen
        rel_root = os.path.relpath(current_root, root_dir)
        base_out_dir = (os.path.join(target_dir, rel_root) if target_dir else current_root)
        os.makedirs(base_out_dir, exist_ok=True)

        for name in files:
            if not name.lower().endswith(".scad"):
                continue

            scad_file = os.path.abspath(os.path.join(current_root, name))
            print(f"Creating preview for {scad_file} ...")

            label = _safe_title_32(name)
            base_name = os.path.splitext(name)[0]
            png_path = os.path.join(base_out_dir, base_name + ".png")
            webp_path = os.path.join(base_out_dir, base_name + ".webp")

            # OpenSCAD-Render (PNG) – Parameter direkt via -D übergeben
            cmd = [
                openscad,
                "-D", "previewQuality=1",
                "-D", "roundingResolution=256",
                "--o", png_path,
                "--csglimit", "3000000",
                "--imgsize", f"{image_width},{image_height}",
                "--autocenter",
                scad_file,
            ]
            try:
                subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            except Exception as e:
                print(f"[thumbnails/generate] OpenSCAD failed for '{scad_file}': {e}")
                continue

            try:
                base_img = Image.open(png_path).convert("RGBA")
                canvas = Image.new("RGBA", (image_width_full, image_height_full), border_color)
                canvas.paste(base_img, (image_border, image_border))

                overlay = Image.new("RGBA", (image_width_full, image_height_full), (0, 0, 0, 0))
                draw = ImageDraw.Draw(overlay)

                x_left = 120
                y_nw_1 = 120
                y_nw_2 = 280
                draw.text((x_left, y_nw_1), label, font=font_big, fill=overlay_color)
                draw.text((x_left, y_nw_2), "3D-printable", font=font_small, fill=overlay_color)

                _, h1 = _text_size(font_mb, "MachineBlocks")
                _, h2 = _text_size(font_small, "created with")
                y_sw_1 = image_height_full - 120 - h1
                y_sw_2 = image_height_full - 274 - h2
                draw.text((x_left, y_sw_1), "MachineBlocks", font=font_mb, fill=overlay_color)
                draw.text((x_left, y_sw_2), "created with", font=font_small, fill=overlay_color)

                composed = Image.alpha_composite(canvas, overlay)
                new_height = int(composed.height * (image_width_half / composed.width))
                resized = composed.resize((image_width_half, new_height), Image.LANCZOS)
                resized.convert("RGB").save(webp_path, "WEBP", quality=80)
                print(f"Created preview {webp_path} for scad file {scad_file}")
            except Exception as e:
                print(f"[thumbnails/generate] PIL processing failed for '{scad_file}': {e}")
            finally:
                try:
                    if os.path.exists(png_path):
                        os.remove(png_path)
                except Exception:
                    pass

def clean_thumbnails(root_dir: str) -> None:
    """
    Sucht rekursiv nach .webp-Dateien ab root_dir und gibt pro Treffer
    den absoluten Pfad aus. Zusätzlich wird ein auskommentierter
    Löschbefehl (plattformabhängig) in derselben Zeile ausgegeben.
    """
    if not os.path.isdir(root_dir):
        print(f"[thumbnails/clean] Directory does not exist: {root_dir}")
        return

    print(f"[thumbnails/clean] Cleaning thumbnails in {root_dir} ...")

    count = 0
    for current_root, _, files in os.walk(root_dir):
        files.sort()
        for name in files:
            if name.lower().endswith(".webp"):
                abs_path = os.path.abspath(os.path.join(current_root, name))
                os.remove(abs_path)
                print(f'[thumbnails/clean] Deleted {abs_path}')
                count += 1

    print(f"[thumbnails/clean] Deleted {count} thumbnails in {root_dir} and subdirectories.")
    print(f"[thumbnails/clean] DONE - Have a nice day!")


def _handle_thumbnails(args, unknown, usage_printer):
    if args.thumbs_cmd is None:
        if unknown:
            usage_printer(f"Error: unknown 'thumbnails' subcommand '{unknown[0]}'.")
        usage_printer("Error: no 'thumbnails' subcommand provided.")
        return

    if args.thumbs_cmd == "generate":
        abs_path = os.path.abspath(os.path.relpath(args.path, start=os.curdir))
        out_dir = os.path.abspath(args.target_dir) if args.target_dir else None
        if out_dir:
            os.makedirs(out_dir, exist_ok=True)

        generate_thumbnails(
            abs_path,
            target_dir=out_dir,
            image_width=args.image_width,
            image_height=args.image_height,
            image_border=args.image_border,
            font_path=args.font_path,
        )
    elif args.thumbs_cmd == "clean":
        abs_path = os.path.abspath(os.path.relpath(args.path, start=os.curdir))
        clean_thumbnails(abs_path)
    else:
        usage_printer(f"Error: unknown 'thumbnails' subcommand '{args.thumbs_cmd}'.")

def register_thumbnails(lvl1):
    p_thumbs = lvl1.add_parser(
        "thumbnails",
        help="Manage thumbnails (PIL-based)."
    )
    th_sub = p_thumbs.add_subparsers(dest="thumbs_cmd")

    p_th_generate = th_sub.add_parser(
        "generate",
        help="Generate thumbnails (PIL implementation; replaces ImageMagick)."
    )
    p_th_generate.add_argument(
        "path",
        help="Path to a directory (processed recursively for .scad files).",
        type=str,
    )
    p_th_generate.add_argument(
        "--target-dir", dest="target_dir", type=str, default=None,
        help="Optional output directory. If set, structure from <path> is mirrored here."
    )
    p_th_generate.add_argument(
        "--image-width", dest="image_width", type=int, default=2400,
        help="Inner image width (default: 2400)."
    )
    p_th_generate.add_argument(
        "--image-height", dest="image_height", type=int, default=1800,
        help="Inner image height (default: 1800)."
    )
    p_th_generate.add_argument(
        "--image-border", dest="image_border", type=int, default=60,
        help="Border size in pixels (default: 60)."
    )
    p_th_generate.add_argument(
        "--font-path", dest="font_path", type=str, default="/Library/Fonts/",
        help="Path to fonts."
    )
    p_th_clean = th_sub.add_parser(
        "clean",
        help="List .webp thumbnails recursively and print a commented delete command for each."
    )
    p_th_clean.add_argument(
        "path",
        help="Path to a directory (processed recursively for .webp files).",
        type=str,
    )

    p_thumbs.set_defaults(command_handler=_handle_thumbnails)
