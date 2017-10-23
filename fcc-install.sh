#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y install castxml gfortran g++ curl cmake git python python-dev ipython
sudo apt-get -y install libhepmc-dev libfastjet-dev libfastjettools-dev libsiscone-dev libsiscone-spherical-dev libfastjetplugins-dev

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && sudo -H python get-pip.py
sudo -H pip install pyyaml
sudo -H pip install numpy
sudo -H pip install scipy
sudo -H pip install dill

mkdir FCC
export FCC=${PWD}/FCC

export FCCSW=/fccsw
sudo mkdir -p $FCCSW
sudo chown $USER:$USER $FCCSW

cd $FCC
wget https://root.cern.ch/download/root_v6.10.08.Linux-ubuntu16-x86_64-gcc5.4.tar.gz
tar zxvf root_v6.10.08.Linux-ubuntu16-x86_64-gcc5.4.tar.gz -C $FCCSW && rm root_v6.10.08.Linux-ubuntu16-x86_64-gcc5.4.tar.gz

cd $FCC
git clone https://github.com/HEP-FCC/podio
git clone https://github.com/HEP-FCC/dag
git clone https://github.com/HEP-FCC/fcc-edm
git clone https://github.com/HEP-FCC/fcc-physics


cd $FCC 
mkdir podio/build; mkdir fcc-edm/build; mkdir fcc-physics/build; mkdir dag/build

echo export PYTHIA8_DIR=/usr/lib/ >> $FCCSW/setup.sh
echo export PYTHIA8DATA=/usr/share/pythia8-data/xmldoc/ >> $FCCSW/setup.sh
echo export HEPMC_PREFIX=/usr/lib/ >> $FCCSW/setup.sh
echo export PYTHIA8_INCLUDE_DIR=/usr/include/Pythia8 >> $FCCSW/setup.sh
echo export PYTHIA8_LIBRARY=/usr/lib/x86_64-linux-gnu >> $FCCSW/setup.sh

echo export FCCEDM=$FCCSW >> $FCCSW/setup.sh
echo export PODIO=$FCCSW >> $FCCSW/setup.sh
echo export FCCPHYSICS=$FCCSW >> $FCCSW/setup.sh

echo source $FCCSW/root/bin/thisroot.sh >> $FCCSW/setup.sh
echo source $FCCSW/init_fcc_stack.sh >> $FCCSW/setup.sh

curl https://raw.githubusercontent.com/HEP-FCC/fcc-spi/master/init_fcc_stack.sh -o $FCCSW/init_fcc_stack.sh
source $FCCSW/setup.sh


cd $FCC
wget http://home.thep.lu.se/~torbjorn/pythia8/pythia8230.tgz
tar zxvf pythia8230.tgz && rm pythia8230.tgz
cd pythia8230
./configure --prefix=$PYTHIA8_DIR --with-hepmc2=$HEPMC_PREFIX --enable-shared
sudo make -j 4 install
sudo mkdir -p $PYTHIA8DATA
sudo cp share/Pythia8/xmldoc/* $PYTHIA8DATA

cd $FCC/dag/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/ ..
make -j4 install

cd $FCC/podio/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/ ..
make -j4 install

cd $FCC/fcc-edm/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/ ..
make -j4 install

cd $FCC/fcc-physics/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/ ..
make -j4 install


# source /fccsw/setup.sh
# git clone https://github.com/HEP-FCC/heppy.git
# cd heppy/
# source ./init.sh
# wget https://raw.githubusercontent.com/HEP-FCC/heppy/master/test/analysis_ee_ZH_cfg.py
# fcc-pythia8-generate /fccsw/share/ee_ZH_Zmumu_Hbb.txt
# heppy -i analysis_ee_ZH_cfg.py -e 0
