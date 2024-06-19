# Steps To Add a New Drive In Linux

## identify the drive

```shell
lsblk
sudo smartctl -a | grep -i model
```

WARNING /dev/sda designations can change at boot time

## partition

```shell
sudo parted /dev/sda mklabel gpt
sudo parted -a opt /dev/sda mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L partitionname /dev/sda1
```

## change the partition uuid to something silly

```shell
tune2fs -U d3adf00d-a933-4921-900b-d04ff0b53e21 /dev/sda1
```

## update fstab to auto mount
```shell
mkdir /mnt/deadfooddrive
vim /etc/fstab

UUID=d3adf00d-a933-4921-900b-d04ff0b53e21 /media/deadfooddrive/ ext4 defaults 0 2

sudo mount -a
```

## sources
[Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux)  
[Tecmint](https://tecmint.com/change-uuid-of-partition-in-linux)

