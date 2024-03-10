# Build / Run
```
docker build -t divisora/cubicle-openbox .
docker run --name divisora_cubicle-openbox -d -p 5000:5000 divisora/cubicle-openbox:latest
```


https://askubuntu.com/questions/111803/enable-ecryptfs-for-all-new-users-even-those-authenticating-through-kerberos-an

https://wiki.gentoo.org/wiki/ECryptfs

# /etc/security/ecryptfs
#!/bin/bash

home=`eval echo ~$PAM_USER`
ecryptfs=/home/.ecryptfs/$PAM_USER/.ecryptfs

read password

if [ -d $ecryptfs ];  then
    # ecryptfs is set
    echo "Ecryptfs is already configured"
    exit 0
elif [ `id -u` == 0 ]; then
    # Setup ecryptfs and make home
    umask 077
    mkdir -p $home
    group=`id -gn $PAM_USER`
    chown $PAM_USER:$group $home

    ecryptfs-setup-private -u $PAM_USER -l "$password" -b --nopwcheck
    exit 0
else
    # NOT ROOT
    echo "Cannot login with 'su' for the first time"
    exit 1
fi

# sudo chmod a+rx /etc/security/ecryptfs

# /usr/share/pam-configs/ecryptfs-nonlocal:
Name: Enable EcryptFS for users from remote directories such as LDAP.
Default: no
Priority: 0
Conflicts: ecryptfs-utils
Auth-Type: Additional
Auth-Final:
    required    pam_exec.so expose_authtok /etc/security/ecryptfs
    optional    pam_ecryptfs.so unwrap
Session-Type: Additional
Session-Final:
    optional    pam_ecryptfs.so unwrap
    optional    pam_exec.so seteuid /etc/security/mkhome
Password-Type: Additional
Password-Final:
    optional    pam_ecryptfs.so

# pam-auth-update





# Userid-guide
https://www.joyfulbikeshedding.com/blog/2021-03-15-docker-and-the-host-filesystem-owner-matching-problem.html