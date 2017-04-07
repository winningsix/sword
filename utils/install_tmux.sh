# Refer from https://gist.github.com/rothgar/cecfbd74597cc35a6018
# Install tmux on Centos release 6.5

# install deps
yum install gcc kernel-devel make ncurses-devel

# DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
curl -OL https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
tar -xvzf libevent-2.0.21-stable.tar.gz
cd libevent-2.0.21-stable
./configure --prefix=/usr/local
make
sudo make install

# DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
wget https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz
tar -xf tmux-2.2.tar.gz
cd tmux-2.2
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
make
make install

# pkill tmux
# close your terminal window (flushes cached tmux executable)
# open new shell and check tmux version
tmux -V

# cheetsheet is available at https://gist.githubusercontent.com/afair/3489752/raw/e7106ac93c8f9602d3843696692a87cfb43c2d21/tmux.cheat
