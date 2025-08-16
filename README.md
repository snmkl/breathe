# Breathe - macOS Menu Bar App

A simple macOS menu bar application that displays an animated breathing circle to guide mindful breathing using the 4-7-8 pattern.

## Features

- **Animated breathing guide**: Visual circle animation following the 4-7-8 breathing pattern
- **Reminder chime**: Optional audio reminder every 15 minutes to prompt mindful breathing
- **Mute control**: Click the menu bar item to toggle the chime on/off (muted by default)

## Usage

### Build and Run
```bash
make run
```

### Install to Applications (and add to login items)
```bash
make install
```

### Uninstall from Applications (and remove from login items)
```bash
make uninstall
```

### Clean
```bash
make clean
```

The `make install` command automatically adds the app to login items so it starts when you log in.
