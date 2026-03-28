# Buffer

## Parameters

| Setting      | Meaning           | Unit |
| ------------ | ----------------- | ---- |
| buffer_time  | Mopidy queue      | ms   |
| buffer-time  | ALSA total buffer | µs   |
| latency-time | ALSA period size  | µs   |

## Current setup

```ini
buffer_time = 300
buffer-time = 300000
latency-time = 30000
```

- total buffer: 300 ms
- period: 30 ms
- periods: 10

## Behavior

- larger buffer → more stable, slower response
- smaller buffer → faster, risk of crackling

## Reference values

| buffer | result                    |
| ------ | ------------------------- |
| 100 ms | fast, unstable on Pi Zero |
| 200 ms | fast, stable              |
| 300 ms | safe baseline             |

## Test

```bash
speaker-test -D default -c 2 -b 300000 -p 30000
```

Change volume:

```bash
amixer set SoftMaster 20%
amixer set SoftMaster 80%
```

## Tuning

Faster:

```ini
buffer_time = 200
buffer-time = 200000
latency-time = 20000
```

Safer:

```ini
buffer_time = 400
buffer-time = 400000
latency-time = 40000
```
