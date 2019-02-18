#!/usr/bin/env python

from ConfigParser import ConfigParser
import codecs
import json

#
# Define the list of localisations and expect files ofr each
#
locList = ['cy', 'de', 'en', 'es', 'fr', 'it', 'ro', 'zh']
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

for n in fileList:
	sections = []
	entries = {}
	
	# loop through localisations and find all sections and entries within them
	for l in locList:
		for section in locs[l][n].keys():
			if not section in sections:
				sections.append(section)
				entries[section] = []
				for entry in locs[l][n][section].keys():
					entries[section].append(entry)
			else:
				for entry in locs[l][n][section].keys():
					if not entry in entries[section]:
						entries[section].append(entry)
	
	# loop through localisations and add english entry as default or empty if no english entry
	for l in locList:
		for section in sections:
			if not section in locs[l][n].keys():
				print 'file = {0: <15}, section = {1: <15}{3}is missing from {2}'.format(n, section, l, ' '*25)
				locs[l][n][section] = {}
				for entry in entries[section]:
					try:
						locs[l][n][section][entry] = locs['en'][n][section][entry]
					except:
						locs[l][n][section][entry] = ''
			else:
				for entry in entries[section]:
					if not entry in locs[l][n][section].keys():
						print 'file = {0: <15}, section = {1: <15}, entry = {2: <15}is missing from {3}'.format(n, section, entry, l)
						try:
							locs[l][n][section][entry] = locs['en'][n][section][entry]
						except:
							locs[l][n][section][entry] = ''

#
# Dump loc to file
#
with codecs.open('locs.json', 'w', 'utf-8') as f:
    json.dump(locs, f, ensure_ascii=False, indent=2)
