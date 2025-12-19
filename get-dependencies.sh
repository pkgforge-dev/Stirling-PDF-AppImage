#!/bin/sh

set -eu

ARCH=$(uname -m)
DEB_LINK="https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/Stirling-PDF-linux-$ARCH.deb"

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm webkit2gtk-4.1

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

echo "Getting app..."
echo "---------------------------------------------------------------"
if ! wget --retry-connrefused --tries=30 "$DEB_LINK" -O /tmp/app.deb 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

ar xvf /tmp/app.deb
tar -xvf ./data.tar.gz
rm -f ./*.gz
mv -v ./usr ./AppDir
mv -v ./AppDir/share/applications/Stirling-PDF.desktop            ./AppDir
mv -v ./AppDir/share/icons/hicolor/192x192/apps/stirling-pdf.png  ./AppDir/.DirIcon
mv -v ./AppDir/share/icons/hicolor/192x192/apps/stirling-pdf.png  ./AppDir

awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
