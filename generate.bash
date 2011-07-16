#!/usr/bin/env bash

# CLI interaction simulator
# Johan Sageryd 2011-07-16

# Simulates user interaction with a shell and stores both the command strings
# themselves and their output (both STDOUT and STDERR) to files.

# The output for each script will be stored in output/ in files with
# the same names as the input scripts.

# Lines prefixed with * (asterisk) are executed but neither the command strings
# nor the result of their execution is written to the output.

# Lines prefixed with # (hash) are ignored.


# Absolute path of this script
ROOT=$(cd $(dirname $0); pwd)

# Where the scripts are
SCRIPTDIR="$ROOT"/scripts

# Where to write the output files (this directory will be deleted and re-created)
OUTPUTDIR="$ROOT"/output

# Where to execute things (this directory will be deleted and re-created)
PLAYGROUND="$ROOT"/playground

# Decorate every executed line by prefixing with this
PREFIX='$ '

[ ! -d "$SCRIPTDIR" ] && { echo -e "Fatal error: There is no script dir ($SCRIPTDIR)"; exit 1; }

[ -d "$OUTPUTDIR" ] && rm -rf "$OUTPUTDIR" > /dev/null 2>&1
mkdir -p "$OUTPUTDIR" > /dev/null 2>&1

[ -d "$PLAYGROUND" ] && rm -rf "$PLAYGROUND" > /dev/null 2>&1
mkdir -p "$PLAYGROUND" > /dev/null 2>&1

pushd "$PLAYGROUND" > /dev/null 2>&1

for script in "$SCRIPTDIR"/*; do
  outputfile="$OUTPUTDIR"/$(basename "$script")
  while read line; do
    [ -z "$line" ] && continue
    [[ $line =~ ^\s*\# ]] && continue
    if [[ $line =~ ^\s*\* ]]; then
      eval ${line##'*'} > /dev/null 2>&1
    else
      echo "$PREFIX$line" >> $outputfile
      eval $line >> $outputfile 2>&1
    fi
  done < "$script"
done

popd > /dev/null 2>&1
