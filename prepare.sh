# prerequisites
sudo apt-get install -y curl git

# install docker
# curl -sSL https://get.docker.com/ | sh

# invalidate pt3(DVB) driver
echo "blacklist earth-pt3" >> /etc/modprobe.d/blacklist.conf

# install pt3 driver
cd
git clone https://github.com/m-tsudo/pt3.git pt3 && cd pt3
make && sudo make install

# install pcsc server
sudo apt-get install -y pcscd