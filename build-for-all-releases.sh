#!/bin/bash
# Build and upload for multiple Ubuntu releases

RELEASES="jammy focal"  # Add noble back if needed

for release in $RELEASES; do
    echo "Building for Ubuntu $release..."
    
    # Update changelog for this release
    dch -D $release -v "1.0.0~${release}1" "Release for $release"
    
    # Build source package
    dpkg-buildpackage -S -sa -us -uc
    
    # Sign it
    cd ..
    debsign -k BA72301B660FF2BA085A8E223C649BBDEAD38B47 appimage-autoinstaller_1.0.0~${release}1_source.changes
    
    # Upload to PPA
    dput ppa appimage-autoinstaller_1.0.0~${release}1_source.changes
    
    cd appimage-autoinstaller
    
    echo "✓ Uploaded for $release"
    echo ""
done

echo "All releases uploaded!"
