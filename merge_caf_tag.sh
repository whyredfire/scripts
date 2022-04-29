# Script for merging caf tag
# Copyright (C) 2021-22 Karan Parashar.

echo -e "Paste the desirable caf tag"
read TAG

echo -e ""

# qcald-3.0
echo -e "Merging qcacld-3.0"
git remote add qcacld-3.0 https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/qcacld-3.0
git fetch qcacld-3.0 $TAG
git merge -X subtree=drivers/staging/qcacld-3.0 FETCH_HEAD

echo -e ""

# fw-api
echo -e "Merging fw-api"
git remote add fw-api https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/fw-api
git fetch fw-api $TAG
git merge -X subtree=drivers/staging/fw-api FETCH_HEAD

echo -e ""

# qca-wifi-host-cmn
echo -e "Merging qca-wifi-host-cmn"
git remote add qca-wifi-host-cmn https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/qca-wifi-host-cmn
git fetch qca-wifi-host-cmn $TAG
git merge -X subtree=drivers/staging/qca-wifi-host-cmn FETCH_HEAD

# techpack
echo -e "Merging techpack"
git remote add teckpack https://git.codelinaro.org/clo/la/platform/vendor/opensource/audio-kernel
git fetch techpack $TAG
git merge -X subtree=techpack/audio FETCH_HEAD
