#!/usr/bin/env python3
"""Render R Markdown (.Rmd) course scripts into an easy-to-read document.

This is a thin Python wrapper around R's ``rmarkdown::render()``. Rendering
*executes* each script's code chunks and lays out the prose, syntax-highlighted
code, printed output, and plots into a single PDF (or HTML) -- far easier to
read and review than the raw .Rmd source.

Requirements (all present on this machine):
  * R with the ``rmarkdown`` and ``knitr`` packages
  * pandoc
  * a LaTeX engine (pdflatex / xelatex) -- only needed for ``--format pdf``

Examples
--------
  python3 render_rmds.py                    # every .Rmd here  -> ./rendered/*.pdf
  python3 render_rmds.py --format html      # render to HTML instead
  python3 render_rmds.py --outdir /tmp/out  # choose the output folder
  python3 render_rmds.py Distributions.Rmd  # just one (or a few) files
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path

FORMAT_TO_R = {"pdf": "pdf_document", "html": "html_document"}
EXT = {"pdf": ".pdf", "html": ".html"}


def r_string(value: str) -> str:
    """Return an R double-quoted string literal for *value* (paths, etc.)."""
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def render_one(rscript: str, rmd: Path, fmt: str, outdir: Path) -> bool:
    """Render a single .Rmd to *fmt* in *outdir*. Returns True on success.

    rmarkdown::render() uses the .Rmd's own directory as the knit working
    directory, so relative paths inside the scripts (e.g. "data/wages1833.csv")
    resolve correctly no matter where this script is launched from.

    PDF uses the xelatex engine so Unicode in the scripts (Greek letters,
    sqrt, arrows: μ, σ, λ, χ², √, ▸) compiles without errors.
    """
    if fmt == "pdf":
        output_format = 'rmarkdown::pdf_document(latex_engine = "xelatex")'
    else:
        output_format = '"html_document"'
    expr = (
        "rmarkdown::render("
        f"{r_string(str(rmd))}, "
        f"output_format={output_format}, "
        f"output_dir={r_string(str(outdir))}, "
        "quiet=TRUE)"
    )
    proc = subprocess.run(
        [rscript, "-e", expr], capture_output=True, text=True
    )
    if proc.returncode != 0:
        # Surface R's error so the user can see what went wrong.
        sys.stderr.write(proc.stdout)
        sys.stderr.write(proc.stderr)
    return proc.returncode == 0


def main(argv: list[str] | None = None) -> int:
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(
        description="Render .Rmd course scripts to PDF (or HTML)."
    )
    parser.add_argument(
        "files", nargs="*",
        help="Specific .Rmd files to render (default: all .Rmd in --indir).",
    )
    parser.add_argument(
        "--indir", type=Path, default=here,
        help="Folder to search for .Rmd files (default: this script's folder).",
    )
    parser.add_argument(
        "--outdir", type=Path, default=here / "rendered",
        help="Where to write the rendered files (default: ./rendered).",
    )
    parser.add_argument(
        "--format", choices=("pdf", "html"), default="pdf",
        help="Output format (default: pdf).",
    )
    parser.add_argument(
        "--no-fallback", action="store_true",
        help="Do not retry as HTML if a PDF render fails (e.g. missing LaTeX).",
    )
    args = parser.parse_args(argv)

    rscript = shutil.which("Rscript")
    if not rscript:
        print("ERROR: 'Rscript' not found on PATH. Install R.", file=sys.stderr)
        return 2

    if args.files:
        rmds = [Path(f) if Path(f).is_absolute() else args.indir / f
                for f in args.files]
    else:
        rmds = sorted(args.indir.glob("*.Rmd"))

    rmds = [p for p in rmds if p.suffix.lower() == ".rmd" and p.is_file()]
    if not rmds:
        print(f"No .Rmd files found in {args.indir}", file=sys.stderr)
        return 1

    args.outdir.mkdir(parents=True, exist_ok=True)
    print(f"Rendering {len(rmds)} script(s) -> {args.outdir}  [{args.format}]\n")

    ok, failed = [], []
    for rmd in rmds:
        print(f"  {rmd.name} ... ", end="", flush=True)
        if render_one(rscript, rmd, args.format, args.outdir):
            print(f"OK  ({rmd.stem}{EXT[args.format]})")
            ok.append(rmd.name)
            continue
        # PDF can fail on incomplete LaTeX installs; HTML needs no LaTeX.
        if args.format == "pdf" and not args.no_fallback:
            print("PDF failed, retrying as HTML ... ", end="", flush=True)
            if render_one(rscript, rmd, "html", args.outdir):
                print(f"OK  ({rmd.stem}.html)")
                ok.append(rmd.name)
                continue
        print("FAILED")
        failed.append(rmd.name)

    print(f"\nDone: {len(ok)} rendered, {len(failed)} failed.")
    if failed:
        print("Failed:", ", ".join(failed))
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
