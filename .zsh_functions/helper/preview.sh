#!/usr/bin/env bash

file_mime=$(file --dereference --mime "$1")
[[ "${file_mime}" =~ binary ]] \
  && echo "${file_mime}" \
  && exit 0
bat --color=always --paging=never --plain --number "$1"
