#!/usr/bin/env bash
##
## Usage:
## - Stapler.sh notarize <username>
## - Stapler.sh staple <version_number>
##
## Fighting Notarization Issues:
## https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution/resolving_common_notarization_issues?language=objc
##
set -e

COMMAND="${1}"

function notarize {
    local account="${1}"
    echo "Notarizing KeepingYouAwake.app using ${account}..."
    xcrun altool \
        --type osx \
        --file dist/KeepingYouAwake-*.zip \
        --primary-bundle-id info.marcel-dierkes.KeepingYouAwake \
        --notarize-app \
        --username "${account}"
}

if [[ "${COMMAND}" == "notarize" ]]; then
    notarize ${2}
fi

# function info {
#     local request_id="${1}"
#     local account="${2}"
#     echo "Getting Notarization Info for ${request_id} using ${account}..."
#     xcrun altool \
#         –-notarization-info ${request_id} \
#         --username "${account}"
# }

# if [[ "${COMMAND}" == "info" ]]; then
#     info ${2} ${3}
# fi

function staple {
    xcrun stapler staple -v dist/KeepingYouAwake.app
    spctl -a -vv dist/KeepingYouAwake.app
}

# Takes the app version as parameter
function repack {
    local version="${1}"
    ditto -c -k --sequesterRsrc --keepParent dist/KeepingYouAwake.app dist/KeepingYouAwake-${version}.zip
}

if [[ "${COMMAND}" == "staple" ]]; then
    staple
    repack ${2}
fi
