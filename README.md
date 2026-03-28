# rpi-mopidy

Minimal Mopidy setup with:

- ALSA soft volume (no hardware step issues)
- Fast volume response
- Systemd service

## Install

```bash
sudo ./install.sh
```

## Uninstall

```bash
sudo ./uninstall.sh
```

## Structure

```
.
├── asound.conf
├── mopidy.conf
├── mopidy.service
├── install.sh
└── uninstall.sh
```

## Docs

- [audio.md](./docs/audio.md)
- [buffer.md](./docs/buffer.md)
- [troubleshoot.md](./docs/troubleshoot.md)
