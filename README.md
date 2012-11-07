CLI interaction simulator
=========================

Simulates user interaction with a shell and stores both the command strings
themselves and their output (STDOUT and STDERR) to files.

Usage
------------------
1. Create stuff in scripts/ (a ready-to-run example is already there)
2. `./generate.bash`

Example
------------------
### Input
    * export GIT_AUTHOR_NAME='Mickey Mouse'
    * export GIT_AUTHOR_EMAIL='mickey@mouse.com'
    * export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
    * export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
    * export GIT_AUTHOR_DATE=2005-01-01T10:00:00Z
    * export GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE
    mkdir repo && cd repo
    git init
    echo "Hello" > foo
    git add foo
    git commit -m 'Initial commit'
    git log

### Output
    mickey@home:~ $ mkdir repo && cd repo
    mickey@home:~/repo $ git init
    Initialized empty Git repository in /private/tmp/playground/repo/.git/
    mickey@home:~/repo [master] $ echo "Hello" > foo
    mickey@home:~/repo [master] $ git add foo
    mickey@home:~/repo [master] $ git commit -m 'Initial commit'
    [master (root-commit) 20552df] Initial commit
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 foo
    mickey@home:~/repo [master] $ git log
    commit 20552dff54dbe8e02f7f673bc32a37210fac5b0f
    Author: Mickey Mouse <mickey@mouse.com>
    Date:   Sat Jan 1 10:00:00 2005 +0000

        Initial commit
    mickey@home:~/repo [master] $

Disclaimer
------------------
I take no responsibility for this program should it cause any harm.
