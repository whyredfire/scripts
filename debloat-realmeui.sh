#!/bin/bash

# List of package names to uninstall
packagesToUninstall=(
    android.autoinstalls.config.oppo
    com.coloros.activation
    com.coloros.assistantscreen
    com.coloros.healthcheck
    com.coloros.securepay
    com.debug.loggerui
    com.facebook.appmanager
    com.facebook.services
    com.facebook.system
    com.finshell.fin
    com.glance.internet
    com.google.android.feedback
    com.google.android.onetimeinitializer
    com.google.android.setupwizard
    com.heytap.cloud
    com.heytap.music
    com.heytap.pictorial
    com.heytap.usercenter
    com.oplus.account
    com.oplus.logkit
    com.oplus.ocloud
    com.oplus.omoji
    com.oplus.onet
    com.oplus.pay
    com.oplus.statistics.rom
    com.oplus.synergy
    com.oplus.themestore
    com.oppo.quicksearchbox
    com.redteamobile.roaming
    com.tencent.soter.soterserver
    com.android.email.partnerprovider
)

packagesToUninstallGlobally=(
    com.finshell.fin
    com.heytap.browser
    com.heytap.pictorial
)

# Loop through the list and uninstall each package
for package in "${packagesToUninstall[@]}"; do
    echo "Uninstalling package: $package"
    adb shell pm uninstall -k --user 0 "$package"
done

for package in "${packagesToUninstallGlobally[@]}"; do
    echo "Uninstalling package: $package"
    adb shell pm uninstall -k "$package"
done

echo "Uninstallation complete"
