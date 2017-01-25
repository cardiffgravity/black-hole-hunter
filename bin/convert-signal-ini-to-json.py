#!/usr/bin/env python

from ConfigParser import ConfigParser
import codecs
import json

#
# Define the list of localisations and expect files ofr each
#
locList = ['cy', 'de', 'en', 'es', 'fr', 'it', 'ro']
fileList = ['endgame', 'game', 'index', 'quotes', 'tutorial']

#
# Prepare monolithic dictionary of all signals info meta data
#
infos = {}
for i in range(1, 85):
    key = "info{0:d}".format(i)
    infos[key] = {}

    # Load n from localisation l
    cp = ConfigParser()
    infoPath = "signalBank/sigbank{0:d}/info.ini".format(i)
    with codecs.open(infoPath, 'r', 'utf-8') as f:
        cp.readfp(f)

    # Populate dictionary with parsed n
    infos[key]['system'] = cp.get('main', 'system')
    infos[key]['mass1'] = cp.get('main', 'mass1')
    infos[key]['mass2'] = cp.get('main', 'mass2')
    infos[key]['inclination'] = cp.get('main', 'inclination')

#
# Dump loc to file
#
with codecs.open('signalBank.json', 'w', 'utf-8') as f:
    json.dump(infos, f, ensure_ascii=False, indent=2)
