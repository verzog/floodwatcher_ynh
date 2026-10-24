# Moving Flood Watcher from My Webapp to this app

For a site already running Flood Watcher in YunoHost's My Webapp (code in
`/var/www/my_webapp/seqflood`). It keeps the readings, push notification sign-ups (and the keys
they depend on), history downloads, flood maps and saved state. Run everything as root.

Do this **after** any history download has finished (`pgrep -af history_fetch` prints nothing):
the download writes into the old folder.

The plan: install the new app on a temporary subdomain with notifications switched off, copy the
data across, check it, then remove My Webapp and move the new app onto the real domain.

## 1. Back up the old site

```bash
yunohost backup create --apps my_webapp
```

## 2. Install the app on a temporary subdomain

```bash
yunohost domain add floodtest.thefeaturecreep.noho.st
yunohost domain cert install floodtest.thefeaturecreep.noho.st
yunohost app install https://github.com/verzog/floodwatcher_ynh \
    -a "domain=floodtest.thefeaturecreep.noho.st&init_main_permission=visitors"
```

Straight away, in the web admin: **Applications > Flood Watcher > Settings**, switch **Push
notifications** off and save. (Both sites would otherwise send the same notifications while you
test.) Put your Weather Underground key in, and switch community rain on, on the same page.

## 3. Stop the old collectors

```bash
mv /etc/cron.d/seqflood /root/seqflood.cron.disabled
```

The old site stays up but stops updating. Wait a minute for any running collector to finish:
`pgrep -af seqflood/bin` should print nothing.

## 4. Copy the data

```bash
# Database tables (replaces the new app's empty ones).
mysqldump my_webapp sensors readings collector_runs push_subscriptions wu_stations \
    | mysql floodwatcher

# Private data: push keys (vapid.json), state, history downloads. Not the old locks or log.
rsync -a --exclude='*.lock' --exclude='collector.log' \
    /var/www/my_webapp/seqflood/var/ /home/yunohost.app/floodwatcher/var/

# The dashboard's data files, flood maps included (saves re-downloading them).
rsync -a /var/www/my_webapp/www/data/ /home/yunohost.app/floodwatcher/public/

# Owners: private data for the app alone; public data readable by the web server.
chown -R floodwatcher:floodwatcher /home/yunohost.app/floodwatcher/var
chmod -R u=rwX,go= /home/yunohost.app/floodwatcher/var
chown -R floodwatcher:www-data /home/yunohost.app/floodwatcher/public
chmod -R u=rwX,g=rX,o= /home/yunohost.app/floodwatcher/public

# Bring the database up to date and rebuild the dashboard data.
sudo -u floodwatcher php8.3 /var/www/floodwatcher/bin/migrate.php
sudo -u floodwatcher php8.3 /var/www/floodwatcher/bin/build_json.php
```

If your old `config.php` had settings other than the database and the Weather Underground key,
copy them into `/home/yunohost.app/floodwatcher/config.local.php` (same format: a PHP file that
returns an array), then `chown floodwatcher:floodwatcher` and `chmod 600` it.

## 5. Check the new site

Open `https://floodtest.thefeaturecreep.noho.st`: gauges, rain, alerts, flood maps, road
closures, and a gauge's "Flood event upstream" bar. Watch the log for the next collector runs:

```bash
tail -f /var/log/floodwatcher/collector.log
```

## 6. Switch over

```bash
yunohost app remove my_webapp      # Its backup from step 1 stays available.
yunohost app change-url floodwatcher -d floodwatcher.thefeaturecreep.noho.st -p /
yunohost domain remove floodtest.thefeaturecreep.noho.st
```

Then in **Settings**, switch **Push notifications** back on. Sign-ups keep working: same address,
same keys. Use "Send test" on your own phone to confirm.

## If something goes wrong

Before step 6 the old site is untouched: put the cron file back
(`mv /root/seqflood.cron.disabled /etc/cron.d/seqflood`) and remove the new app. After step 6,
restore the backup from step 1 (`yunohost backup list`, then `yunohost backup restore <name>`)
once the new app is moved off the domain or removed.
