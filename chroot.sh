#!/bin/bash

echo "======== setting root password ========"
passwd root

echo "======== adding wheel to sudoers ========"
echo "%wheel ALL=(ALL:ALL) ALL" | tee /etc/sudoers.d/10-wheel >/dev/null
chmod 440 /etc/sudoers.d/10-wheel
visudo -c

echo "======== adding user and running main script ========"

useradd -mG wheel faction

echo "======== setting faction password ========"
passwd faction

cp /root/chroot/main.sh /home/faction/main.sh
cp -r /root/chroot/assets /home/faction/assets
chown faction:faction -R /home/faction/

su - faction -c "cd ~ && chmod +x ./main.sh &&./main.sh"