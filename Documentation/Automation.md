# KeepingYouAwake Automation

## URL Scheme

KeepingYouAwake supports the `keepingyouawake:///` URL scheme to activate and deactive the app externally.

### activate

```
keepingyouawake:///activate
```

Activates and prevents sleep for the configured default duration.

#### activate?seconds=X

```
keepingyouawake:///activate?seconds=30
```

Activates and prevents sleep for exactly 30 seconds.

#### activate?minutes=X

```
keepingyouawake:///activate?minutes=5
```

Activates and prevents sleep for exactly 5 minutes.

#### activate?hours=X

```
keepingyouawake:///activate?hours=2
```

Activates and prevents sleep for exactly 2 hours.

#### activate?until=HH:MM

```
keepingyouawake:///activate?until=17:00
```

Activates and prevents sleep until the next 5:00 PM local time. The time uses the 24-hour clock; if it has already passed today, the timer runs until that time tomorrow.

#### activate?until=YYYY-MM-DDTHH:MM

```
keepingyouawake:///activate?until=2026-10-03T17:00
```

Activates and prevents sleep until that local date and time. A date in the past is ignored.

_Please note: the seconds, minutes, hours and until parameters cannot be combined at the moment._

### deactivate

```
keepingyouawake:///deactivate
```

Deactivates and allows the system to go to sleep.

### toggle

```
keepingyouawake:///toggle
```

Toggles the activation state between activated and deactivated.

## Command Line Usage

The URL scheme can be used together with the `open` command to control KeepingYouAwake from the command line.

```
open -g "keepingyouawake:///activate"
open -g "keepingyouawake:///activate?seconds=30"
open -g "keepingyouawake:///deactivate"
open -g "keepingyouawake:///toggle"
```
