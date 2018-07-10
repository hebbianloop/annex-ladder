#!/bin/bash
# Retroactively annex files by pattern

# parse inputs
PATTERN=${1}
GITDIR=${2}

if [ ! -d "${GITDIR}" ]; then
	echo "error: ${GITDIR} doesn't exist"
	exit
fi

# defaults
CWD=$(pwd)
BLUE='\033[1;34m' && NC='\033[0m' 

# move to git dir
if [ ! "${CWD}" = "${GITDIR}" ]; then
	cd ${GITDIR}
fi

# check git has annex first
if ! git annex info; then
	exit
fi

# look in repository for files matching pattern
FILES=$(find "${GITDIR}"/  \( ! -regex '.*/\..*' \) -type f -name ${PATTERN} | tr -s \n)

if [ ! "${FILES}" ]; then
	echo "No Files Found with pattern ${PATTERN} in ${GITDIR}"
	exit
else
	echo -e "${BLUE}Found $(echo "${FILES}" | wc -l) files matching ${PATTERN}${NC}"
	echo "${FILES}" | sed "s|${GITDIR}./||g" | nl
	echo -e "\n Removing from git and adding to annex"
	# remove files from git and annex them
	git filter-branch --tree-filter 'for '${FILES}';do if [ -f "$FILE" ] && [ ! -L "$FILE" ];then git rm --cached "$FILE";git annex add "$FILE";ln -sf `readlink "$FILE"|sed -e "s:^../../::"` "$FILE";fi;done' --tag-name-filter cat -- --all	
fi

