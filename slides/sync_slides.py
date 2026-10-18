# /// script
# requires-python = ">=3.11"
# dependencies = ["pymupdf>=1.24"]
# ///
"""Mirror the course's Google Slides decks as local PDFs.

For every deck in decks.toml this downloads the public PPTX export, computes a
content fingerprint from it, and, only if the fingerprint changed since the
last run, downloads the PDF export and writes to out/:

  <name>.pdf   every slide, page number = slide number, hidden (skipped)
               slides stamped with a red HIDDEN banner
  <name>.txt   per-slide text and speaker notes, hidden slides flagged

out/manifest.json records fingerprints, slide counts and hidden slides.

Usage (from the repo root):
  uv run slides/sync_slides.py            # update decks that changed
  uv run slides/sync_slides.py --check    # only report which decks changed
  uv run slides/sync_slides.py --force    # rebuild everything
  uv run slides/sync_slides.py 05 06      # only decks whose name starts with these
"""

import argparse
import datetime as dt
import hashlib
import io
import json
import re
import sys
import tomllib
import urllib.request
import zipfile
from pathlib import Path

import pymupdf

HERE = Path(__file__).resolve().parent
CONFIG = HERE / "decks.toml"
OUT = HERE / "out"
MANIFEST = OUT / "manifest.json"
EXPORT_URL = "https://docs.google.com/presentation/d/{id}/export/{fmt}"


def download(deck_id, fmt):
    url = EXPORT_URL.format(id=deck_id, fmt=fmt)
    with urllib.request.urlopen(url, timeout=120) as response:
        content_type = response.headers.get("Content-Type", "")
        data = response.read()
    # A deck that is not publicly viewable redirects to a sign-in page.
    if "html" in content_type:
        raise RuntimeError(f"got a web page instead of a {fmt}; is the deck shared publicly?")
    return data


def read_rels(pptx, part):
    """Map relationship ids to target part paths for one part of the package."""
    folder, name = part.rsplit("/", 1)
    rels_path = f"{folder}/_rels/{name}.rels"
    if rels_path not in pptx.namelist():
        return {}
    xml = pptx.read(rels_path).decode()
    rels = {}
    for attrs in re.findall(r"<Relationship ([^>]*)/?>", xml):
        rel_id = re.search(r'Id="([^"]+)"', attrs).group(1)
        target = re.search(r'Target="([^"]+)"', attrs).group(1)
        if 'TargetMode="External"' not in attrs:
            target = str(Path(folder, target)).replace("\\", "/")
            # Resolve "../" segments without touching the filesystem.
            parts = []
            for piece in target.split("/"):
                if piece == "..":
                    parts.pop()
                else:
                    parts.append(piece)
            target = "/".join(parts)
        rels[rel_id] = target
    return rels


def slide_parts(pptx):
    """Slide part paths in presentation order."""
    xml = pptx.read("ppt/presentation.xml").decode()
    rels = read_rels(pptx, "ppt/presentation.xml")
    return [rels[r] for r in re.findall(r'<p:sldId [^>]*r:id="([^"]+)"', xml)]


def normalized(pptx, part):
    """A part's XML with export noise removed, for fingerprinting.

    Google's export renames media files and regenerates table-style GUIDs on
    every download, so relationship ids are replaced by a hash of what they
    point to and GUIDs are blanked.
    """
    xml = pptx.read(part).decode()
    xml = re.sub(r"\{[0-9A-Fa-f-]{36}\}", "{GUID}", xml)
    names = set(pptx.namelist())
    for rel_id, target in read_rels(pptx, part).items():
        if target.startswith("ppt/media/") and target in names:
            stamp = hashlib.sha1(pptx.read(target)).hexdigest()
        else:
            stamp = target
        xml = xml.replace(f'"{rel_id}"', f'"{stamp}"')
    return xml


def paragraphs(xml):
    """Text of each non-empty <a:p> paragraph."""
    out = []
    for para in re.findall(r"<a:p>.*?</a:p>|<a:p .*?</a:p>", xml, flags=re.S):
        text = "".join(re.findall(r"<a:t>([^<]*)</a:t>", para))
        text = (text.replace("&lt;", "<").replace("&gt;", ">")
                    .replace("&quot;", '"').replace("&apos;", "'").replace("&amp;", "&"))
        if text.strip():
            out.append(text)
    return out


def analyse(pptx_bytes):
    """Fingerprint, hidden-slide numbers and a text dump of a PPTX export."""
    pptx = zipfile.ZipFile(io.BytesIO(pptx_bytes))
    digest = hashlib.sha256()
    hidden = []
    dump = []
    parts = slide_parts(pptx)
    for number, part in enumerate(parts, start=1):
        xml = pptx.read(part).decode()
        is_hidden = re.search(r'<p:sld\b[^>]*\bshow="0"', xml) is not None
        if is_hidden:
            hidden.append(number)
        digest.update(normalized(pptx, part).encode())

        notes = ""
        for target in read_rels(pptx, part).values():
            if "notesSlides/" in target:
                digest.update(normalized(pptx, target).encode())
                # The notes page repeats the slide number; drop bare digits.
                notes = "\n".join(p for p in paragraphs(pptx.read(target).decode())
                                  if not p.strip().isdigit())

        header = f"=== Slide {number}" + (" [HIDDEN]" if is_hidden else "") + " ==="
        dump.append(header)
        dump.extend(paragraphs(xml))
        if notes:
            dump.append("--- notes ---")
            dump.append(notes)
        dump.append("")
    return digest.hexdigest(), hidden, len(parts), "\n".join(dump)


def stamp_hidden(pdf_bytes, hidden, slide_count):
    """Mark hidden slides in the PDF export with a banner."""
    doc = pymupdf.open(stream=pdf_bytes, filetype="pdf")
    if doc.page_count != slide_count:
        print(f"  warning: PDF has {doc.page_count} pages but the deck has "
              f"{slide_count} slides; HIDDEN banners may be misplaced", file=sys.stderr)
    for number in hidden:
        if number > doc.page_count:
            continue
        page = doc[number - 1]
        width = page.rect.width
        height = page.rect.height * 0.08
        banner = pymupdf.Rect(0, 0, width, height)
        page.draw_rect(banner, color=None, fill=(0.85, 0.1, 0.1), fill_opacity=0.85, overlay=True)
        page.insert_textbox(banner, f"HIDDEN  ·  slide {number}", fontsize=height * 0.5,
                            fontname="helv", color=(1, 1, 1), align=pymupdf.TEXT_ALIGN_CENTER)
        page.draw_rect(page.rect, color=(0.85, 0.1, 0.1), width=6, overlay=True)
    return doc.tobytes(garbage=3, deflate=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("prefixes", nargs="*", help="only decks whose name starts with one of these")
    parser.add_argument("--check", action="store_true", help="report changes without writing files")
    parser.add_argument("--force", action="store_true", help="rebuild even if unchanged")
    args = parser.parse_args()

    decks = tomllib.loads(CONFIG.read_text())["deck"]
    if args.prefixes:
        decks = [d for d in decks if d["name"].startswith(tuple(args.prefixes))]

    OUT.mkdir(exist_ok=True)
    manifest = json.loads(MANIFEST.read_text()) if MANIFEST.exists() else {}
    failed = False

    for deck in decks:
        name = deck["name"]
        try:
            fingerprint, hidden, slide_count, text = analyse(download(deck["id"], "pptx"))
        except Exception as error:
            print(f"{name}: FAILED ({error})")
            failed = True
            continue

        previous = manifest.get(name, {})
        files_present = (OUT / f"{name}.pdf").exists() and (OUT / f"{name}.txt").exists()
        changed = previous.get("fingerprint") != fingerprint or not files_present
        hidden_note = f", hidden: {compress(hidden)}" if hidden else ""
        summary = f"{slide_count} slides{hidden_note}"

        if not changed and not args.force:
            print(f"{name}: up to date ({summary})")
            continue
        if args.check:
            print(f"{name}: CHANGED ({summary})")
            continue

        try:
            pdf = stamp_hidden(download(deck["id"], "pdf"), hidden, slide_count)
        except Exception as error:
            print(f"{name}: FAILED on PDF ({error})")
            failed = True
            continue
        (OUT / f"{name}.pdf").write_bytes(pdf)
        (OUT / f"{name}.txt").write_text(text)
        manifest[name] = {
            "id": deck["id"],
            "fingerprint": fingerprint,
            "slides": slide_count,
            "hidden": hidden,
            "synced": dt.datetime.now().astimezone().isoformat(timespec="seconds"),
        }
        MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n")
        print(f"{name}: updated ({summary})")

    return 1 if failed else 0


def compress(numbers):
    """[3, 4, 5, 9] -> '3-5, 9'."""
    runs = []
    for n in numbers:
        if runs and n == runs[-1][1] + 1:
            runs[-1][1] = n
        else:
            runs.append([n, n])
    return ", ".join(f"{a}" if a == b else f"{a}-{b}" for a, b in runs)


if __name__ == "__main__":
    sys.exit(main())
