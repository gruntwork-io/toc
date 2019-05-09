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
origin: "https:\/\/github.com\/gruntwork-io\/toc\/blob\/master\/README.md"\
tags: ["terraform"]\
---'

  sed -i'' -e "1 s/^.*$/$frontmatter/g" "$infile"
  sed -i'' -e "s/__DATE__/$(get_last_commit_date)/g" "$infile"
}

function get_last_commit_date {
  # We use python to get the date of the last commit in the format YYYY-MM-DD. This works by getting the timestamp of
  # the last commit using `git log -1`, and then converting to the desired output format.
  python -c "import time; print(time.strftime('%Y-%m-%d', time.localtime($(git log -1 --format="%at"))))"
}

function clean_outfolder {
  local -r target_file="$1"
  local -r target_dir="$(dirname $target_file)"
  local -r abs_target_dir="$(realpath $target_dir)"

  # Remove anything that is not markdown
  find "$abs_target_dir" -type f -not -name "*.md" -delete
}

function build_for_docssite {
  local -r target_file="$1"

  create_artifact "$target_file"
  replace_header "$target_file"
  clean_outfolder "$target_file"
}

build_for_docssite ./generated/introduction/library-catalog/index.md
