# !/bin/sh

echo "Do you want to install Pattern Completor Modeling"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) matlab -nodesktop -nosplash -batch "usetup;exit"; break;; 
		No ) exit
	esac
done

echo "Designated MATLAB MEX Directory"

cd thirdparty/QPBO-v1.32.src

make

echo "Installation Complete"




