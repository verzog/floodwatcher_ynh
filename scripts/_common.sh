#!/bin/bash

#=================================================
# COMMON VARIABLES AND FUNCTIONS
#=================================================

# Settings on the admin settings page (config_panel.toml), with their defaults.
_fw_default_settings() {
    ynh_app_setting_set_default --key=push_enabled --value=1
    ynh_app_setting_set_default --key=community_rain --value=0
    ynh_app_setting_set_default --key=wu_api_key --value=""
    ynh_app_setting_set_default --key=qldtraffic_api_key --value=""
}

# Write config.php from conf/config.php (database, folders, settings page values).
# Readable only by the app: it holds the database password and API keys.
_fw_write_config() {
    ynh_config_add --template="config.php" --destination="$install_dir/config.php"
    chown "$app:$app" "$install_dir/config.php"
    chmod 600 "$install_dir/config.php"
}

# Folders and their owners. The web server (www-data) reads the page files and the public
# data; the private data (state, push keys, history) is for the app alone.
_fw_set_permissions() {
    mkdir -p "$data_dir/var" "$data_dir/public" "/var/log/$app"

    chown -R "$app:www-data" "$install_dir"
    chmod -R u=rwX,g=rX,o= "$install_dir"
    chmod 600 "$install_dir/config.php"

    chown "$app:www-data" "$data_dir"
    chmod 750 "$data_dir"
    chown -R "$app:www-data" "$data_dir/public"
    chmod -R u=rwX,g=rX,o= "$data_dir/public"
    chown -R "$app:$app" "$data_dir/var"
    chmod -R u=rwX,go= "$data_dir/var"
    if [ -f "$data_dir/config.local.php" ]; then
        chown "$app:$app" "$data_dir/config.local.php"
        chmod 600 "$data_dir/config.local.php"
    fi

    chown -R "$app:$app" "/var/log/$app"
    chmod 750 "/var/log/$app"
}

# The collectors' schedule.
_fw_add_cron() {
    ynh_config_add --template="cron" --destination="/etc/cron.d/$app"
    chown root:root "/etc/cron.d/$app"
    chmod 644 "/etc/cron.d/$app"
}

# Run one of the app's command-line scripts as the app user.
_fw_php() {
    ynh_exec_as_app "php$php_version" "$install_dir/bin/$1" "${@:2}"
}

# Database tables, the council sensor list, and the push notification keys. All safe to repeat.
_fw_setup_data() {
    _fw_php migrate.php
    _fw_php import_sensors.php
    _fw_php push_setup.php
}
