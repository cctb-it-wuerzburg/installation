#!/bin/bash

sudo su root -c "printf '[SeatDefaults]\nallow-guest=false\n' > /etc/lightdm/lightdm.conf.d/99-disallow-guest.conf"
