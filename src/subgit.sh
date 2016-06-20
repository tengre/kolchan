#!/bin/bash

. bashlyk

[[ -n "$1" ]] || eval $(udfOnError throw iErrorEmptyOrMissingArgument)

subgit import --authors-file ~/src/authors --svn-url file:///opt/dat/svn/${1} /opt/dat/git/${1}.git
