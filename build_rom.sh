mkdir ros
cd ros

    repo init -u https://github.com/RevengeOS/android_manifest -b r10.0
    SYNC_START=$(date +"%s")
            cd .repo/manifests
            git reset --hard
            cd ../..
            cd .repo/repo
            git reset --hard
            cd ../..
        rm -rf .repo/local_manifest.xml
        rm -rf private_manifest
        git clone https://github.com/RevengeOS/private_manifest.git private_manifest
        cp private_manifest/private.xml .repo/local_manifest.xml
        rm -rf private_manifest
        repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags --depth=1

    SYNC_END=$(date +"%s")
    SYNC_DIFF=$((SYNC_END - SYNC_START))
    echo "Sync completed successfully in $((SYNC_DIFF / 60)) minute(s) and $((SYNC_DIFF % 60)) seconds"
    echo "Build Started"
export USE_CCACHE=1
export REVENGEOS_BUILDTYPE=OFFICIAL
rm -rf out/target/product/$DEVICE
. build/envsetup.sh
lunch revengeos_$DEVICE-user
mka bacon

export finalzip_path=$(ls "$outdir"/*2020*.zip | tail -n -1)
if [ -e "$finalzip_path" ]; then
        echo "Build completed successfully in $((BUILD_DIFF / 60)) minute(s) and $((BUILD_DIFF % 60)) seconds"
        exit 1
else
        echo "Build failed in $((BUILD_DIFF / 60)) minute(s) and $((BUILD_DIFF % 60)) seconds"
        exit 1
fi        