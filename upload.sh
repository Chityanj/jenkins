cd ros
set -e
    a=()
    devices_dir=$(pwd)/vendor/revengeos/official_devices
    if [ ! -f "$(pwd)/changelog.txt" ]; then
        echo "Create changelog.txt folder in build directory"
        echo "Aborting..."
        return 0
    fi
    
    target_device=$DEVICE
    out_dir=$(pwd)/out/target/product/$target_device/
    zipvar=$out_dir/RevengeOS-*.zip
    version=${a[1]}
    size=$(stat -c%s "$zipvar")
    md5=$(md5sum "$zipvar")
    echo "Uploading build to ODSN"
    scp $zipvar chityanj@storage.osdn.net:/storage/groups/r/re/revengeos/$target_device
    echo "Generating json"
    python3 $(pwd)/vendor/revengeos/build/tools/generatejson.py $target_device $zipvar $version $size $md5
    if [ -d "$devices_dir/$target_device" ]; then
        mv $(pwd)/device.json $devices_dir/$target_device
        mv $(pwd)/changelog.txt $devices_dir/$target_device
    else
        mkdir devices_dir/$target_device
        mv $(pwd)/device.json $devices_dir/$target_device
        mv $(pwd)/changelog.txt $devices_dir/$target_device
    fi
    echo "Pushing to Official devices"
    cd $devices_dir
    git add $target_device && git commit -m "Update $target_device"
    git pull --rebase https://github.com/RevengeOS-Devices/official_devices.git
    git push https://github.com/RevengeOS-Devices/official_devices.git HEAD:r10.0
)}
