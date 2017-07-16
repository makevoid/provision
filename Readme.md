# Server Provisioning script

Ruby Script/Task to provision a remote Ubuntu 17.04 Server / VM.

### Usage

    ruby vm_provision.rb <SERVER_IP>

This will setup the machine with Ruby (2.3 from package), nodejs (8, from binaries), nginx, passenger, pm2 and setup a `www` user.

You need to have ssh root access to the machine.
