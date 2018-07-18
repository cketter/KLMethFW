
REM Clean up the results directory
rmdir /S /Q results
mkdir results

REM Synthesize the Example Design
rem Synthesize the VHDL Wrapper Files
echo 'Synthesizing the example design with XST';
xst -ifn xst.scr
copy pcs_pma_example_design.ngc .\results\

REM Copy the netlist generated by Coregen
echo 'Copy files from the netlist directory to the results directory'
copy ..\..\pcs_pma.ngc results

REM  Copy the constraints files generated by Coregen
echo 'Copy files from constraints directory to results directory'
copy ..\example_design\pcs_pma_example_design.ucf results\

cd results
echo 'Running ngdbuild'
ngdbuild pcs_pma_example_design

echo 'Running map'
map -ol high -timing pcs_pma_example_design -o mapped.ncd

echo 'Running par'
par -ol high -w mapped.ncd routed.ncd mapped.pcf

echo 'Running trce'
trce -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed.ncd routed mapped.pcf

echo 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -pcf mapped.pcf -sim -dir . -tm pcs_pma_example_design -w routed.ncd routed.vhd
