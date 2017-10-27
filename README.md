# fcc-install

`source /fccsw/setup.sh`

tested with: 
* ubuntu-16.04.3-desktop-amd64
* ubuntu-16.04.3-server-amd64
* linuxmint-18.2-mate-64bit
* linuxmint-18.2-cinnamon-64bit

# sw
* root 6.10.08
* pythia 8.230
* podio
* dag
* fcc-edm
* fcc-physics
* heppy
* papas

# example
```shell
source /fccsw/setup.sh
wget https://raw.githubusercontent.com/HEP-FCC/heppy/master/test/analysis_ee_ZH_cfg.py
fcc-pythia8-generate /fccsw/fcc-physics/share/ee_ZH_Zmumu_Hbb.txt
heppy -i analysis_ee_ZH_cfg.py -e 0
example_simple ee_ZH_Zmumu_Hbb.root
```
