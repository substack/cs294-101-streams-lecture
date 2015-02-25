#!/bin/bash

# first do: npm install -g shp2json

curl -o alameda.zip \
  'https://data.acgov.org/api/geospatial/2m43-xsic?method=export&format=Original'
shp2json alameda.zip | gzip > alameda.json.gz
