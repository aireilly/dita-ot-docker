# Dockerfile for DITA-OT

A Dockerfile for the [DITA Open Toolkit](https://www.dita-ot.org/).

The image adds DITA-OT's `bin` directory to `PATH`, so you can run `dita` directly:

## Pull the prebuilt image

```bash
podman pull quay.io/rhn_support_aireilly/dita-ot
```

## Check it works

```bash
podman run --rm quay.io/rhn_support_aireilly/dita-ot dita --version
```

## Build HTML5 from a ditamap in your current folder

```bash
podman run --rm \
  -v "$PWD":/src:Z \
  -w /src \
  quay.io/rhn_support_aireilly/dita-ot \
  dita --input=./example.ditamap --format=html5 --output=/src/out
```

Swap `example.ditamap` for your map file. Output lands in `./out` on your machine. The `:Z` suffix relabels the volume for SELinux (Fedora/RHEL); drop it on macOS or Ubuntu if it complains.

