# ptime
> a basic 🍅 timer

## Table of Contents
- [Quick-Start](#quick-start)
    - [Install](#install)
    - [Usage](#usage)
        - [Configure timer](#configure-timer)
- [`ptime` Features](#ptime-features)
- [`ptime` Limitations](#ptime-limitations)
- [Rationale](#rationale)
- [Pomodoro Technique TL; DR](#pomodoro-techinque-tl-dr)
- [License](#license)

## Quick-Start
### Install
- Clone the repo
- `cd` to the folder
- Source the script with `source ptime.sh`

Now, if you call `ptime`, you should see something like
```
ptime: missing required arguments.
ptime - a basic 🍅 timer (v.0.0.1)

usage: ptime [options] [start]
options:
  -h                show this help message and exit
  -f TIME           set focus time to TIME minutes, default is 25
  -s TIME           set short break time to TIME minutes, default is 5
  -l TIME           set long break time to TIME minutes, default is 15
  -c N_UNITS        set pomodoro cycle to N_UNITS 🍅 units, default is 4

by @tennets (GitHub)
```

### Usage
- Start the timer for a cycle with `ptime start`.
- Display help message with `ptime -h`.

#### Configure timer
Optional flags configure the timer.
- To set custom focus time to `TIME` minutes, use the `-f` flag:
    ```bash
    ptime -f TIME
    ```
- To set custom short break time to `TIME` minutes, use the `-s` flag:
    ```bash
    ptime -s TIME
    ```
- To set custom long break to `TIME` minutes, use the `-l` flag:
    ```bash
    ptime -l TIME
    ```
- To set a custom number of 🍅 units before the long break to `N_UNITS`, use the `-c` flag:
    ```bash
    ptime -c N_UNITS
    ```
## `ptime` Features
- Set focus time
- Set short break time
- Set long break time
- Set a cycle length in 🍅 units

## `ptime` Limitations
- Tested by using it not via actual tests
- Work on macOS, but should work also on Linux machines
- Does not support Windows machine
## Rationale
`ptime` is for those (like me) using the terminal for coding or interacting with a [POSIX-oriented OS](https://en.wikipedia.org/wiki/POSIX)( (like Linux and macOS).
However, `ptime` is also for those who want to use the terminal more (like me). 
`ptime` is a fun learning project that helped me learn more about shell scripting.
Moreover, I use it every day.
Using `ptime` for time tracking is less distracting than online pomodoro timers.

`ptime` runs a pomodoro cycle. 
It starts the first focus phase, followed by the first short break, then the second focus phase, and so on until four 🍅 are completed and tracks the time for the long break.
Note that each phase follows the previous without interruptions.

## Pomodoro Techinque TL; DR
Refer to [this document](http://friend.ucsd.edu/reasonableexpectations/downloads/Cirillo%20--%20Pomodoro%20Technique.pdf) for a detailed introduction to the technique.
Here's a breakdown of the method
1. Decide the task you want to do
2. Set the __FOCUS__ timer, typically 25 minutes.
3. Work on the task (one 🍅)
4. When the focus time is up, take a __SHORT BREAK__, typically 5 minutes.
5. Go back to Step 2 and repeat until you complete four pomodoros
6. After completing a __POMODORO CYCLE__, take a __LONG BREAK__, usually 15 to 30 minutes.
7. After the long break, repeat from Step 2.

## License
[MIT Licence](LICENCE)