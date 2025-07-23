#!/bin/bash

# List of package names to uninstall
packagesToUninstall=(
    com.android.email.partnerprovider
    com.android.traceur
    com.coloros.securepay
    com.facebook.appmanager
    com.facebook.services
    com.facebook.system
    com.glance.internet
    com.google.android.apps.nbu.files
    com.google.android.feedback
    com.google.android.onetimeinitializer
    com.google.android.partnersetup
    com.google.android.printservice.recommendation
    com.heytap.browser
    com.heytap.cloud
    com.heytap.market
    com.heytap.mcs
    com.heytap.pictorial
    com.microsoft.appmanager
    com.oplus.crashbox
    com.oplus.lfeh
    com.oplus.logkit
    com.oplus.statistics.rom
    com.oplus.wifibackuprestore
    com.oppo.quicksearchbox
    com.redteamobile.roaming
    com.tencent.soter.soterserver
    com.wapi.wapicertmanage
)

# Loop through the list and uninstall each package
for package in "${packagesToUninstall[@]}"; do
    echo "Uninstalling package: $package"
    adb shell pm uninstall -k --user 0 "$package"
done

echo "Uninstallation complete"
