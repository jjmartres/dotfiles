function pixinsight_ramdisk
    # Default configuration
    set -l DEFAULT_SIZE 8
    set -l DEFAULT_NAME RamDisk

    # Help
    if test (count $argv) -eq 0; or contains -- $argv[1] -h --help help
        echo "Usage: pixinsight_ramdisk [create|mount|c] [size_GB] [name]"
        echo "       pixinsight_ramdisk [delete|unmount|eject|d] [name]"
        echo "       pixinsight_ramdisk [status|list|s]"
        echo ""
        echo "Examples:"
        echo "  pixinsight_ramdisk create          # Create 8GB ramdisk named 'RamDisk'"
        echo "  pixinsight_ramdisk c 4 MyRam       # Create 4GB ramdisk named 'MyRam'"
        echo "  pixinsight_ramdisk delete          # Delete 'RamDisk' ramdisk"
        echo "  pixinsight_ramdisk d MyRam         # Delete 'MyRam' ramdisk"
        echo "  pixinsight_ramdisk status          # Show mounted ramdisks"
        return 0
    end

    switch $argv[1]
        case create mount c
            # Parameters
            set -l size $DEFAULT_SIZE
            set -l name $DEFAULT_NAME

            if test (count $argv) -ge 2
                set size $argv[2]
            end

            if test (count $argv) -ge 3
                set name $argv[3]
            end

            # Check if ramdisk already exists
            if test -d "/Volumes/$name"
                echo "❌ Ramdisk '$name' already exists"
                return 1
            end

            # Calculate size in sectors (size_GB * 1024 * 1024 * 1024 / 512)
            set -l sectors (math "$size * 2097152")

            echo "🚀 Creating ramdisk '$name' of {$size}GB..."

            # Create ramdisk
            set -l disk_device (hdiutil attach -nomount ram://$sectors 2>/dev/null)

            if test $status -ne 0
                echo "❌ Error creating ramdisk"
                return 1
            end

            # Format ramdisk
            if diskutil erasevolume HFS+ "$name" $disk_device >/dev/null 2>&1
                echo "✅ Ramdisk '$name' created successfully!"
                echo "📁 Mounted at: /Volumes/$name"
                echo "💾 Size: {$size}GB"
            else
                echo "❌ Error during formatting"
                # Cleanup on error
                hdiutil detach $disk_device >/dev/null 2>&1
                return 1
            end

        case delete unmount eject d
            # Name of ramdisk to delete
            set -l name $DEFAULT_NAME

            if test (count $argv) -ge 2
                set name $argv[2]
            end

            # Check if ramdisk exists
            if not test -d "/Volumes/$name"
                echo "❌ Ramdisk '$name' does not exist"
                return 1
            end

            echo "🗑️  Deleting ramdisk '$name'..."

            # Delete ramdisk
            if diskutil eject "$name" >/dev/null 2>&1
                echo "✅ Ramdisk '$name' deleted successfully!"
            else
                echo "❌ Error during deletion"
                return 1
            end

        case status list s
            echo "📊 Active ramdisks:"
            echo ""

            # List mounted ramdisks using a more reliable method
            set -l ramdisks_found 0

            # Method 1: Check mounted volumes and verify if they are RAM disks
            for volume in /Volumes/*
                if test -d "$volume"
                    set -l volume_name (basename "$volume")
                    # Get the device for this volume
                    set -l device (df "$volume" 2>/dev/null | tail -n 1 | awk '{print $1}')
                    if test -n "$device"
                        # Check if this device is a RAM disk
                        set -l disk_info (diskutil info "$device" 2>/dev/null)
                        if echo "$disk_info" | grep -qi "ram.*disk\|virtual.*disk"
                            set ramdisks_found 1
                            set -l size (echo "$disk_info" | grep "Total Size" | cut -d: -f2 | string trim)
                            if test -z "$size"
                                set size (echo "$disk_info" | grep "Disk Size" | cut -d: -f2 | string trim)
                            end

                            echo "🔸 $volume_name"
                            echo "   Size: $size"
                            echo "   Mount point: $volume"
                            echo "   Device: $device"
                            echo ""
                        end
                    end
                end
            end

            # Method 2: Alternative check using diskutil list
            if test $ramdisks_found -eq 0
                for line in (diskutil list | grep -i "ram\|virtual")
                    if echo "$line" | grep -q /dev/disk
                        set ramdisks_found 1
                        set -l device (echo "$line" | grep -o "/dev/disk[0-9]*")
                        set -l disk_info (diskutil info "$device" 2>/dev/null)
                        set -l volume_name (echo "$disk_info" | grep "Volume Name" | cut -d: -f2 | string trim)
                        set -l size (echo "$disk_info" | grep "Total Size" | cut -d: -f2 | string trim)
                        set -l mount_point (echo "$disk_info" | grep "Mount Point" | cut -d: -f2 | string trim)

                        if test -n "$volume_name"
                            echo "🔸 $volume_name"
                            echo "   Size: $size"
                            echo "   Mount point: $mount_point"
                            echo "   Device: $device"
                            echo ""
                        end
                    end
                end
            end

            if test $ramdisks_found -eq 0
                echo "No ramdisk found"
            end

        case '*'
            echo "❌ Unknown command: $argv[1]"
            echo "Use 'pixinsight_ramdisk help' to see help"
            return 1
    end
end
