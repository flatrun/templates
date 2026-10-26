#!/usr/bin/env bash
set -u
status=0
for compose in */docker-compose.yml; do
  dir=${compose%/docker-compose.yml}
  logo=$(sed -n 's/^logo:[[:space:]]*//p' "$dir/metadata.yml" 2>/dev/null | tr -d "\"'")
  case "$logo" in
    "") echo "$dir: metadata.yml names no logo"; status=1; continue ;;
    http://?* | https://?*) ;;
    *:*)
      if [[ ! $logo =~ ^[a-z0-9]+(-[a-z0-9]+)*:[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
        echo "$dir: logo \"$logo\" must be an icon id such as logos:postgresql, a link, or a file"; status=1
      fi ;;
    /* | *..*) echo "$dir: logo \"$logo\" must be a file in the template's directory"; status=1; continue ;;
    *.svg | *.png | *.webp)
      if [ ! -f "$dir/$logo" ]; then
        echo "$dir: $logo is missing"; status=1
      elif [ "$(wc -c <"$dir/$logo")" -gt 524288 ]; then
        echo "$dir: $logo is larger than 512 KB"; status=1
      fi ;;
    *) echo "$dir: logo \"$logo\" must be SVG, PNG or WebP"; status=1; continue ;;
  esac
  if grep -q '^icon:' "$dir/metadata.yml"; then
    echo "$dir: icon is no longer read; logo replaces it"; status=1
  fi
done
exit $status
