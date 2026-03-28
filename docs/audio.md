# Audio

## Pipeline

```

UI (0–100)
→ Mopidy
→ ALSA SoftMaster
→ ALSA output

```

## ALSA (`asound.conf`)

```conf
pcm.!default {
  type plug
  slave.pcm "softvol"
}

pcm.softvol {
  type softvol
  slave.pcm "plughw:0,0"
  control.name "SoftMaster"
  control.card 0
}
```

## Why softvol

Hardware mixers (`PCM`) have uneven steps.

`softvol` provides:

- consistent volume curve
- predictable behavior
- control via Mopidy

## Mopidy config

```ini
[audio]
mixer = alsamixer
output = alsasink

[alsamixer]
control = SoftMaster
volume_scale = cubic
```

## Important

Do not use:

```ini
output = alsasink device=hw:0,0
```

This bypasses `softvol`.
