#!/bin/bash
#
# Simple bash script to merge CLO tags to kernel
#
# Usage:
#       ./merge_caf_tag.sh $TAG
#

TAG=$1

if [ -z ${TAG+x} ]; then
    echo "Pass a valid argument"
fi

# qcacld-3.0
function merge_qcacld() {
    echo "Merging qcacld-3.0"
    if ! git remote add qcacld-3.0 https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/qcacld-3.0; then
        git remote rm qcacld-3.0
        git remote add qcacld-3.0 https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/qcacld-3.0
    fi

    git fetch qcacld-3.0 $TAG

    if ! git merge -X subtree=drivers/staging/qcacld-3.0 FETCH_HEAD --log; then
        echo "Merge failed!" && exit 1
    else
        echo "Merged qcacld-3.0 tag sucessfully!"
    fi
}

# fw-api
function merge_fw_api() {
    echo "Merging fw-api"
    if ! git remote add fw-api https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/fw-api; then
        git remote rm fw-api
        git remote add fw-api https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/fw-api
    fi

    git fetch fw-api $TAG

    if ! git merge -X subtree=drivers/staging/fw-api FETCH_HEAD --log; then
        echo "Merge failed!" && exit 1
    else
        echo "Merged fw-api tag sucessfully!"
    fi
}

# qca-wifi-host-cmn
function merge_qca_wifi_host_cmn() {
    echo "Merging qca-wifi-host-cmn"
    if ! git remote add qca-wifi-host-cmn https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/qca-wifi-host-cmn; then
        git remote rm qca-wifi-host-cmn
        git remote add qca-wifi-host-cmn https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/qca-wifi-host-cmn
    fi

    git fetch qca-wifi-host-cmn $TAG

    if ! git merge -X subtree=drivers/staging/qca-wifi-host-cmn FETCH_HEAD --log; then
        echo "Merge failed!" && exit 1
    else
        echo "Merged qca-wifi-host-cmn tag sucessfully!"
    fi
}

# techpack
function merge_techpack() {
    echo "Merging techpack"
    if ! git remote add techpack https://git.codelinaro.org/clo/la/platform/vendor/opensource/audio-kernel; then
        git remote rm techpack
        git remote add techpack https://git.codelinaro.org/clo/la/platform/vendor/opensource/audio-kernel
    fi

    git fetch techpack $TAG

    if ! git merge -X subtree=techpack/audio FETCH_HEAD --log; then
        echo "Merge failed!" && exit 1
    else
        echo "Merged techpack tag sucessfully!"
    fi
}

# initialize script
merge_qcacld
merge_fw_api
merge_qca_wifi_host_cmn
merge_techpack
