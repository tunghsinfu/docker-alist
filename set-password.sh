#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! docker compose version >/dev/null 2>&1; then
  echo "需要 Docker Compose V2（docker compose）。" >&2
  exit 1
fi

if [[ $# -gt 1 ]]; then
  echo "用法: $0 [NEW_PASSWORD]" >&2
  exit 1
fi

if [[ $# -eq 1 ]]; then
  password=$1
elif [[ -n ${ALIST_PASSWORD:-} ]]; then
  password=$ALIST_PASSWORD
else
  read -r -s -p "請輸入新管理員密碼: " password
  echo
  read -r -s -p "請再輸入一次: " confirmation
  echo
  if [[ $password != "$confirmation" ]]; then
    echo "兩次輸入的密碼不相同。" >&2
    exit 1
  fi
fi

if [[ -z $password ]]; then
  echo "密碼不可為空。" >&2
  exit 1
fi

docker compose exec -T alist ./alist admin set "$password"
