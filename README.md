# Flood Watcher for YunoHost

[Flood Watcher](https://github.com/verzog/floodwatcher) is a community flood dashboard for the
Brisbane River catchment in South East Queensland: river levels, rainfall, BoM flood warnings,
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

1. In the code repository: bump `version.php`, commit, push, then tag it (`git tag v0.17.1 &&
   git push origin v0.17.1`) and wait for the checks to pass.
2. Here: `./tools/bump.sh 0.17.1` (points `manifest.toml` at the new tag and fills in its
   checksum), check the result, commit and push.
3. On the server: the upgrade command above.

## Licence

Packaging scripts: GPL-3.0-or-later. Flood Watcher itself: GPL-3.0-or-later.
