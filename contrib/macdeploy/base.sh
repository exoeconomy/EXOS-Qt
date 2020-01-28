#!/usr/bin/env bash

RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
function info {
    printf "\r💬 ${BLUE}INFO:${NC}  ${1}\n"
}
function fail {
    printf "\r🗯 ${RED}ERROR:${NC} ${1}\n"
    exit 1
}
function warn {
    printf "\r⚠️  ${YELLOW}WARNING:${NC}  ${1}\n"
}

function DoCodeSignMaybe { # ARGS: infoName fileOrDirName codesignIdentity
    infoName="$1"
    file="$2"
    identity="$3"
    deep=""
    if [ -z "$identity" ]; then
        # we are ok with them not passing anything; master script calls us unconditionally even if no identity is specified
        return
    fi
    if [ -d "$file" ]; then
        deep="--deep"
    fi
    if [ -z "$infoName" ] || [ -z "$file" ] || [ -z "$identity" ] || [ ! -e "$file" ]; then
        fail "Argument error to internal function DoCodeSignMaybe()"
    fi
    info "Code signing ${infoName}..."
    codesign -f -v $deep -s "$identity" "$file" || fail "Could not code sign ${infoName}"
}

function CreatePKG() {   # ARGS: PACKAGE_NAME VERSION PKG_BACKGROUND IDENTIFIER APPLE_DEV_INSTALLER_CERT DEV_INSTALLER_CERT
    PACKAGE_NAME="$1"
    VERSION="$2"
    PKG_ICON="$3"
    IDENTIFIER="$4"
    APPLE_DEV_INSTALLER_CERT="$5"
    DEV_INSTALLER_CERT="$6"

    # set up app name, version number, and icon for the pkg file
    PKG_ICON="src/qt/res/icons/${PKG_ICON}" 
    VOL_NAME="${PACKAGE_NAME}-${VERSION}"
    PKG_TMP="dist/${PACKAGE_NAME}.pkg"
    PKG_FINAL="dist/${VOL_NAME}.pkg"    

    mkdir -p dist/build && cp -r dist/${PACKAGE_NAME}.app $_
    pkgbuild --analyze --root dist/build dist/components.plist
    plutil -replace BundleIsRelocatable -bool false dist/components.plist

    pkgbuild --root "dist/build" \
      --component-plist "dist/components.plist" \
      --version ${VERSION} \
      --identifier ${IDENTIFIER} \
      --install-location "/Applications" \
      "${PKG_TMP}"
    
    if [ -z "$DEV_INSTALLER_CERT" ]; then
        productbuild --distribution "contrib/macdeploy/distribution.xml" \
        --package-path "dist" \
        --resources "contrib/macdeploy" \
        "${PKG_FINAL}"
    else
        productbuild --distribution "contrib/macdeploy/distribution.xml" \
        --package-path "dist" \
        --resources "contrib/macdeploy" \
        --sign "$APPLE_DEV_INSTALLER_CERT$DEV_INSTALLER_CERT" \
        "${PKG_FINAL}"
    fi
    
    echo "read 'icns' (-16455) \"${PKG_ICON}\";" > dist/tmpicns.rsrc
    Rez -a dist/tmpicns.rsrc -o ${PKG_FINAL}
    SetFile -a C ${PKG_FINAL}

    rm -rf dist/tmpicns.rsrc dist/components.plist dist/build ${PKG_TMP}
}
