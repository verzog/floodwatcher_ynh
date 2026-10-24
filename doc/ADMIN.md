### Settings

**Applications > Flood Watcher > Settings** (the "Flood Watcher settings" page) switches push
notifications and community rain on or off, and holds your Weather Underground and QLDTraffic
API keys. Changes apply from the collectors' next run.

Anything else (any setting in `__INSTALL_DIR__/lib/defaults.php`) goes in
`__DATA_DIR__/config.local.php`, which is kept on upgrades and included in backups:

```php
<?php
return [
    'potential' => [/* ... */],
];
```

Don't edit `__INSTALL_DIR__/config.php`: the package rewrites it.

### Where things are

| What | Where |
|---|---|
| Code and page files | `__INSTALL_DIR__` |
| Private data: state, push notification keys, history downloads | `__DATA_DIR__/var` |
| The dashboard's data files (served as /data/) | `__DATA_DIR__/public` |
| Collector log | `/var/log/__APP__/collector.log` |
| Schedule | `/etc/cron.d/__APP__` |

Keep `__DATA_DIR__/var/vapid.json` safe (it's in every backup). If it's lost, everyone's
notification sign-ups stop working and they have to sign up again.

### First hours after install

The collectors start within 10 minutes and the flood maps download within half an hour. Until
then the map is empty. Progress is in the collector log:

```bash
tail -f /var/log/__APP__/collector.log
```

### Flood history downloads (for prediction rules)

```bash
cd __INSTALL_DIR__
nohup sudo -u __APP__ php__PHP_VERSION__ bin/history_fetch.php lockyer > /tmp/history.out 2>&1 &
```

Files go in `__DATA_DIR__/var/history/`.
