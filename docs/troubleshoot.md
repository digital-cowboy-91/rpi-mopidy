# Troubleshoot

## No sound

Check device:

```bash
aplay -l
```

Check ALSA default:

```bash
speaker-test -D default -c 2
```

---

## Volume does not change

Check control exists:

```bash
amixer scontrols
```

Expect:

```text
SoftMaster
```

Check value:

```bash
amixer get SoftMaster
```

---

## Volume changes but no effect on sound

Playback is not using `default`.

Fix Mopidy:

```ini
[audio]
output = alsasink
```

Do NOT use:

```ini
output = alsasink device=hw:0,0
```

---

## Delay too high

Reduce buffer:

```ini
buffer_time = 200
output = alsasink buffer-time=200000 latency-time=20000
```

---

## Crackling / dropouts

Increase buffer:

```ini
buffer_time = 400
output = alsasink buffer-time=400000 latency-time=40000
```

---

## SoftMaster exists but does nothing

Test directly:

```bash
speaker-test -D default -c 2
```

Then:

```bash
amixer set SoftMaster 20%
```

If no change:

- `softvol` not in playback path

---

## Mopidy not applying volume

Check runtime config:

```bash
mopidyctl config
```

Verify:

```ini
[audio]
mixer = alsamixer

[alsamixer]
control = SoftMaster
```

---

## Device busy

```text
Device or resource busy
```

Stop Mopidy:

```bash
sudo systemctl stop mopidy
```

---

## No SoftMaster after install

Restart ALSA usage:

```bash
speaker-test -D default -c 2
```

SoftMaster appears only after first use.

---

## Wrong sound card

Check:

```bash
aplay -l
```

Update:

```conf
slave.pcm "plughw:X,Y"
```

---

## Service fails

Check logs:

```bash
journalctl -u mopidy -n 50
```
