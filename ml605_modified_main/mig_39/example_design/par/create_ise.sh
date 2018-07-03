
./rem_files.sh

coregen -b makeproj.bat
coregen -p . -b icon5_cg.xco
coregen -p . -b ila384_8_cg.xco
coregen -p . -b vio_async_in256_cg.xco
coregen -p . -b vio_sync_out32_cg.xco

xtclsh set_ise_prop.tcl

