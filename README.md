# Flood Watcher for YunoHost

[Flood Watcher](https://github.com/verzog/floodwatcher) is a community flood dashboard for
Queensland catchments, starting with the Brisbane River and the Mary River: river levels, rainfall, BoM flood warnings,
gauge alerts, predictive flood alerts, flood maps, road closures and push notifications.

This repository is the YunoHost package. See [doc/DESCRIPTION.md](doc/DESCRIPTION.md) for what it
does and [doc/ADMIN.md](doc/ADMIN.md) for running it.

## Install

The app needs a domain or subdomain of its own.

```bash
sudo yunohost app install https://github.com/verzog/floodwatcher_ynh
```

## Upgrade

```bash
sudo yunohost app upgrade floodwatcher -u https://github.com/verzog/floodwatcher_ynh
```

## Releasing a new version (maintainer notes)

1. In the code repository: bump `version.php`, commit and push, then publish a GitHub release
   with the matching tag (e.g. `v0.17.3`) and wait for the checks to pass.
2. This package follows by itself: every 15 minutes the "Update to the latest release" workflow
   checks for a newer release and points `manifest.toml` at it (version, download address and
   checksum). To do it straight away: Actions tab, "Update to the latest release",
   "Run workflow". By hand: `./tools/bump.sh 0.17.3`, then commit and push.
3. On the server: the upgrade command above.

## Licence

Packaging scripts: GPL-3.0-or-later. Flood Watcher itself: GPL-3.0-or-later.
