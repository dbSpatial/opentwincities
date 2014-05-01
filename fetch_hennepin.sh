#!/bin/bash
define(){ IFS='\n' read -r -d '' ${1} || true; }
url=http://gis-stage.co.hennepin.mn.us/publicgisdata/
define filelist<<'EOD'
hennepin_county_tax_property_base.zip
hennepin_county_gis_addresses.zip
hennepin_county_boundary.zip
hennepin_county_street_centerline.zip
hennepin_county_street_aliases.zip
hennepin_county_municipal_bdry.zip
hennepin_county_commissioner_dist.zip
hennepin_county_2ft_contours.zip
EOD

for file in $filelist; do
  wget ${url}${file}
  unzip $file
  rm $file
  for f in `find . -name  *.gdb | xargs basename`; do
    fn=`basename $f .gdb`
    ogr2ogr ${fn}.shp $f
    zip ${fn}.shp.zip ${fn}.shp ${fn}.dbf ${fn}.shx ${fn}.prj
    rm ${fn}.shp ${fn}.dbf ${fn}.shx ${fn}.prj
    ogr2ogr -f geojson ${fn}.geojson $f
    zip ${fn}.geojson.zip ${fn}.geojson
    rm ${fn}.geojson
    rm -fr $f
  done
done
