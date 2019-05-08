#!/bin/bash
#
# This script prepares the README for use in the docs site. The main thing it does is remove the title and replace it
# with a frontmatter.
#

function create_artifact {
  local -r target_file="$1"
  local -r target_dir="$(dirname $target_file)"

  mkdir -p "$target_dir"
  cp ./README.md "$target_file"
}

function replace_header {
  local -r infile="$1"

  local -r frontmatter='---\
title: "Gruntwork IaC Library Catalog"\
date: __DATE__\
tags: ["terraform"]\
---'

  sed -i'' -e "1 s/^.*$/$frontmatter/g" "$infile"
  sed -i'' -e "s/__DATE__/$(date +%Y-%m-%d)/g" "$infile"
}

function build_for_docssite {
  local -r target_file="$1"

  create_artifact "$target_file"
  replace_header "$target_file"

}

build_for_docssite ./generated/library-catalog/index.md
