## Set up ssh access to an AWS instance with a .pem key

Create a user

```
sudo adduser --disabled-password andrew
sudo su andrew
cd ~
mkdir .ssh
chmod 700 .ssh
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
emacs .ssh/authorized_keys
```

Then paste in the public key from the .pem file, obtained via

```
ssh-keygen -y -f /path/to/my_key.pem
```

Now login as andrew using

```
ssh andrew@alton-brown
```
