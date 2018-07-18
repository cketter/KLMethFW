
 
 
 




#!/bin/sh

# Clean up the results directory
rm -rf results
mkdir results

#Synthesize the Wrapper Files

echo 'Synthesizing example design with XST';
xst -ifn xst.scr
cp blkmem_pedcalc_tmp_exdes.ngc ./results/


# Copy the netlist generated by Coregen
echo 'Copying files from the netlist directory to the results directory'
cp ../../blkmem_pedcalc_tmp.ngc results/

#  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
cp ../example_design/blkmem_pedcalc_tmp_exdes.ucf results/

cd results

echo 'Running ngdbuild'
ngdbuild -p xc6slx150t-fgg676-3 blkmem_pedcalc_tmp_exdes

echo 'Running map'
map blkmem_pedcalc_tmp_exdes -o mapped.ncd -pr i

echo 'Running par'
par mapped.ncd routed.ncd

echo 'Running trce'
trce -e 10 routed.ncd mapped.pcf -o routed

echo 'Running design through bitgen'
bitgen -w routed

echo 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -sim -tm blkmem_pedcalc_tmp_exdes -pcf mapped.pcf -w routed.ncd routed.vhd
