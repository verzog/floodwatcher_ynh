<?php
// Flood Watcher settings, written by the YunoHost package on install, on upgrade and whenever
// the settings page in the YunoHost admin is saved. Don't edit this file: changes here are lost.
// Put your own settings in __DATA_DIR__/config.local.php instead (same format; see
// lib/defaults.php for every setting). That file is kept on upgrades and included in backups.

declare(strict_types=1);

$settings = [
    'db' => [
        'host'     => 'localhost',
        'name'     => '__DB_NAME__',
        'user'     => '__DB_USER__',
        'password' => '__DB_PWD__',
    ],
    'public_data_dir' => '__DATA_DIR__/public',
    'var_dir'         => '__DATA_DIR__/var',
    'local_config'    => '__DATA_DIR__/config.local.php',
    'push' => [
        'enabled'  => filter_var('__PUSH_ENABLED__', FILTER_VALIDATE_BOOLEAN),
        'site_url' => 'https://__DOMAIN__',
        'subject'  => 'https://__DOMAIN__',
    ],
    'wu' => [
        'enabled' => filter_var('__COMMUNITY_RAIN__', FILTER_VALIDATE_BOOLEAN) && '__WU_API_KEY__' !== '',
        'api_key' => '__WU_API_KEY__',
    ],
];
// Your own QLDTraffic key, if set; otherwise the shared public key in lib/defaults.php is used.
if ('__QLDTRAFFIC_API_KEY__' !== '') {
    $settings['traffic']['api_key'] = '__QLDTRAFFIC_API_KEY__';
}
return $settings;
