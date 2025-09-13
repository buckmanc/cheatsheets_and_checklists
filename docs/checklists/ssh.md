# SSH

1. [your router](http://192.168.1.1): assign a static server ip
1. server: install openssh
    - Ubuntu: `sudo apt install openssh`
    - Termux: `pkg install openssh`
1. server: start ssh daemon
    - Ubuntu: `sudo systemctl restart ssh`
    - Termux: `sshd`
1. server: verify password auth is on
    - Ubuntu: `/etc/ssh/sshd_config`
    - Termux `$PREFIX/etc/ssh/sshd_config`
    -
        ```
        PasswordAuthentication yes
        ```
1. client: create an ssh key pair
    - `ssh-keygen -C "your.email@example.com"`
1. client: add server to config
    - `~/.ssh/config`
    -
        ```
        host enterprise
            user picard
            hostname 192.168.1.1701
            port 22
        ```
     - termux uses port 8022 by default
1. client: copy public key to server
    - `ssh-copy-id enterprise`
    - enter your password when prompted
1. client: test success
    - `ssh enterprise`
1. server: disable password auth
    - Ubuntu: `/etc/ssh/sshd_config`
    - Termux: `$PREFIX/etc/ssh/sshd_config`
    -
        ```
        PasswordAuthentication no
        ```
1. server: restart ssh daemon
    - Ubuntu: `sudo systemctl restart ssh`
    - Termux: `pkill sshd && sshd`
1. profit

## TODO

- fix code block bullet formatting

references: [Linuxize](https://linuxize.com/post/how-to-setup-passwordless-ssh-login) and [Termux Wiki](https://wiki.termux.com/wiki/Remote_Access)
