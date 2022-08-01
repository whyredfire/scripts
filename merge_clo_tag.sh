#!/bin/bash
#
# Simple bash script to merge CLO tags to kernel
#
# Usage:
#       ./merge_clo_tag.sh $TAG
#

TAG=$1

if [ -z ${TAG+x} ]; then
    echo "Pass a valid argument"
fi

if [[ $2 = "-i" || $2 = "--initial" ]]; then
    INITIAL_MERGE=true
    echo "Initial merge"
fi

# Merge TAG function
function merge() {
    echo "Merging qcacld-3.0"
    if ! git remote add $REMOTE https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/$REMOTE; then
        git remote rm $REMOTE
        git remote add $REMOTE https://git.codelinaro.org/clo/la/platform/vendor/qcom-opensource/wlan/$REMOTE
    fi

    git fetch $REMOTE $TAG

    if [[ ${INITIAL_MERGE} = true ]]; then
        git merge -s ours --no-commit --allow-unrelated-histories FETCH_HEAD
        git read-tree --prefix=drivers/staging/$MERGE_PATH -u FETCH_HEAD
        git commit -m "$REMOTE: Merge tag '$TAG'"
        echo "Merged $REMOTE tag succesfully!"
    else
        if ! git merge -X subtree=drivers/staging/$MERGE_PATH FETCH_HEAD --log; then
            echo "Merge failed!" && exit 1
        else
            echo "Merged $REMOTE tag sucessfully!"
        fi
    fi
}

# qcacld-3.0
function qcacld() {
    REMOTE = qcacld-3.0
    MERGE_PATH = drivers/staging/qcacld-3.0
    merge
}

# fw-api
function fw_api() {
    REMOTE = fw-api
    MERGE_PATH = drivers/staging/fw-api
    merge
}

# qca-wifi-host-cmn
function qca_wifi_host_cmn() {
    REMOTE = qca-wifi-host-cmn
    MERGE_PATH = drivers/staging/qca-wifi-host-cmn
    merge
}

# techpack
function techpack() {
    REMOTE = audio-kernel
    MERGE_PATH = techpack/audio
    merge
}

# initialize script
qcacld
fw-api
qca_wifi_host_cmn
techpack