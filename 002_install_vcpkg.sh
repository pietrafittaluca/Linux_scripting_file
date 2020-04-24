sudo apt install gcc -y
sudo apt install g++ -y
sudo apt install cmake -y

sudo apt-get install git

cd ~

git clone https://github.com/Microsoft/vcpkg.git

cd vcpkg

./bootstrap-vcpkg.sh

./vcpkg integrate install

./vcpkg install cjson
./vcpkg install curl

./vcpkg integrate bash
