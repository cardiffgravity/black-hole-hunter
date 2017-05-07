#!/usr/bin/env python

from ConfigParser import ConfigParser
import codecs
import json

#
# Define the list of localisations and expect files ofr each
#
locList = ['en', 'fr']
fileList = ['endgame', 'game', 'index', 'quotes', 'tutorial']

#
# Prepare monolithic dictionary of all localisation data
#
locs = {}

# Loop over localisations
for l in locList:
    locs[l] = {}

    # Loop over files in localisation l
    for n in fileList:
        locs[l][n] = {}

        # Load n from localisation l
        cp = ConfigParser()
        with codecs.open('loc/'+l+'/'+n+'.ini', 'r', 'utf-8') as f:
            cp.readfp(f)

        # Populate dictionary with parsed n
        for section in cp.sections():
            locs[l][n][section] = {}
            for k, v in cp.items(section):
                locs[l][n][section][k] = v

#
# Dump loc to file
#
with codecs.open('locs.json', 'w', 'utf-8') as f:
    json.dump(locs, f, ensure_ascii=False, indent=2)
