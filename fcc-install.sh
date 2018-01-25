#!/usr/bin/env bash

sudo echo
iss=$?
if [[ "$iss" -ne 0 ]]; then
  echo "This script must be run by sudo'er"
  exit 1
fi

if sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; then echo "apt in use, exiting..."; exit; fi

sudo apt-get update
sudo apt-get -y install castxml gfortran g++ curl cmake git python python-dev ipython doxygen
sudo apt-get -y install libhepmc-dev libfastjet-dev libfastjettools-dev libsiscone-dev libsiscone-spherical-dev libfastjetplugins-dev
sudo apt-get -y install libopenblas-base libopenblas-dev

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && sudo -H python get-pip.py && rm get-pip.py
sudo -H pip install pyyaml
sudo -H pip install numpy
sudo -H pip install scipy
sudo -H pip install dill
sudo -H pip install gitpython

mkdir FCC
export FCC=${PWD}/FCC

export FCCSW=/fccsw
sudo mkdir -p $FCCSW
sudo chown $USER:$USER $FCCSW

cd $FCC

wget https://root.cern.ch/download/root_v6.12.04.Linux-ubuntu16-x86_64-gcc5.4.tar.gz
tar zxf root_v6.12.04.Linux-ubuntu16-x86_64-gcc5.4.tar.gz -C $FCCSW && rm root_v6.12.04.Linux-ubuntu16-x86_64-gcc5.4.tar.gz

cd $FCC
git clone https://github.com/HEP-FCC/podio
git clone https://github.com/HEP-FCC/dag
git clone https://github.com/HEP-FCC/fcc-edm
git clone https://github.com/HEP-FCC/fcc-physics
git clone https://github.com/HEP-FCC/papas

cd $FCC
mkdir podio/build; mkdir fcc-edm/build; mkdir fcc-physics/build; mkdir dag/build; mkdir papas/build;

sudo git clone https://github.com/HEP-FCC/heppy.git $FCCSW/heppy/
#sudo cp $FCCSW/heppy/scripts/*.py $FCCSW/heppy/bin/
#sudo cp $FCCSW/heppy/scripts/heppy $FCCSW/heppy/bin/
#sudo chmod +x $FCCSW/heppy/bin/*.py
#sudo chmod +x $FCCSW/heppy/bin/heppy

echo export PYTHIA8_DIR=$FCCSW/pythia8 >> $FCCSW/setup.sh
echo export PYTHIA8DATA=$FCCSW/pythia8/data/ >> $FCCSW/setup.sh
echo export HEPMC_PREFIX=/usr/lib/ >> $FCCSW/setup.sh
echo export PYTHIA8_INCLUDE_DIR=$FCCSW/pythia8 >> $FCCSW/setup.sh
echo export PYTHIA8_LIBRARY=$FCCSW/pythia/lib/ >> $FCCSW/setup.sh

echo export FCCEDM=$FCCSW/fcc-edm/ >> $FCCSW/setup.sh
echo export PODIO=$FCCSW/podio/ >> $FCCSW/setup.sh
echo export FCCPHYSICS=$FCCSW/fcc-physics/ >> $FCCSW/setup.sh
echo export FCCDAG=$FCCSW/dag/ >> $FCCSW/setup.sh
echo export HEPPY=$FCCSW/heppy/ >> $FCCSW/setup.sh
echo export FCCPAPASCPP=$FCCSW/papas/ >> $FCCSW/setup.sh
echo export PYTHONPATH=$FCCSW/heppy/..:$PYTHONPATH >> $FCCSW/setup.sh
echo export PATH=$FCCSW/heppy/bin:$FCCSW/papas/bin:$PATH >> $FCCSW/setup.sh
echo export LD_LIBRARY_PATH=$FCCSW/papas/lib:$LD_LIBRARY_PATH >> $FCCSW/setup.sh

echo source $FCCSW/root/bin/thisroot.sh >> $FCCSW/setup.sh
echo source $FCCSW/init_fcc_stack.sh >> $FCCSW/setup.sh

curl https://raw.githubusercontent.com/HEP-FCC/fcc-spi/master/init_fcc_stack.sh -o $FCCSW/init_fcc_stack.sh
source $FCCSW/setup.sh

#cd $FCC
#wget http://hepmc.web.cern.ch/hepmc/releases/hepmc3.0.0.tgz
#tar zxf hepmc3.0.0.tgz && rm hepmc3.0.0.tgz
#cd hepmc3.0.0
#mkdir build; cd build
#cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/hepmc/ ..
#sudo make install

cd $FCC
wget http://home.thep.lu.se/~torbjorn/pythia8/pythia8230.tgz
tar zxf pythia8230.tgz && rm pythia8230.tgz
cd pythia8230
./configure --prefix=$PYTHIA8_DIR --with-hepmc2=$HEPMC_PREFIX --enable-shared
make -j 4 install
mkdir -p $PYTHIA8DATA
cp share/Pythia8/xmldoc/* $PYTHIA8DATA

cd $FCC/dag/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/dag/ ..
make -j4 install

cd $FCC/podio/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/podio/ ..
make -j4 install

cd $FCC/fcc-edm/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/fcc-edm/ ..
make -j4 install

cd $FCC/fcc-physics/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/fcc-physics/ ..
make -j4 install

cd $FCC/papas/build
cmake -DCMAKE_INSTALL_PREFIX=$FCCSW/papas/ ..
make -j4 install

# source /fccsw/setup.sh
# wget https://raw.githubusercontent.com/HEP-FCC/heppy/master/test/analysis_ee_ZH_cfg.py
# fcc-pythia8-generate /fccsw/fcc-physics/share/ee_ZH_Zmumu_Hbb.txt
# heppy -i analysis_ee_ZH_cfg.py -e 0
# example_simple ee_ZH_Zmumu_Hbb.root
