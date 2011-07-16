#!/usr/bin/env bash --login

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

# The prompt to use, syntax is similar to bash PS1.
# Possible special characters are as follows:
#
#  \h  the hostname (read from $P_HOST defined below)
#  \u  the user (read from $P_USER defined below)
#  \w  the working directory relative to $PLAYGROUND
#  \n  newline
#
# In addition, after substitution the string will be evaluated
# in order to expand any variables or command calls.
# Any leading or trailing spaces must be escaped.
PROMPT='\u@\h:~\w$(__git_ps1 " [%s]") \$\ '

# Constants that can be used in $PROMPT
P_USER='mickey'
P_HOST='home'

expandprompt(){
  cwd=$(pwd)
  cwd=${cwd##$PLAYGROUND/}
  cwd=${cwd##$PLAYGROUND}
  [ ! -z $cwd ] && cwd=/"$cwd"
  p="$1"
  p="${p//\\u/$P_USER}"
  p="${p//\\h/$P_HOST}"
  p="${p//\\n/$(printf '\n\r')}"
  p="${p//\\w/$cwd}"
  p=$(eval echo "$p")
  echo "$p"
}

[ ! -d "$SCRIPTDIR" ] && { echo "Fatal error: There is no script dir ($SCRIPTDIR)"; exit 1; }

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
      p=$(expandprompt "$PROMPT")
      echo "$p$line" >> $outputfile
      eval $line >> $outputfile 2>&1
    fi
  done < "$script"
done

popd > /dev/null 2>&1
