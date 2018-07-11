#!/bin/bash
# Add all microsoft / google office binary files to annex

GITDIR=${1}
PATTERNS='*.docx *.doc *.ppt *.pptx *.xls *.xlsx *.gdoc *.gsheet'

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "Requires input GITDIR: ${0##*/} GITDIR"
fi

if [ ! -d "${GITDIR}" ]; then
	echo "error: ${GITDIR} doesn't exist"
	exit
fi

# loop across patterns and add them to annex
for PATTERN in ${PATTERNS}; do
	./retronnex.sh ${PATTERN} ${GITDIR}
done
