# Dockerfile for DITA-OT

A Dockerfile for the [DITA Open Toolkit](https://www.dita-ot.org/).

The image adds DITA-OT's `bin` directory to `PATH`, so you can run `dita` directly:

```bash
docker run --rm <image> dita --version
```
