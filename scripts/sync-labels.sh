#!/usr/bin/env bash
# 표준 라벨 체계를 저장소에 적용합니다.
#
#   bash scripts/sync-labels.sh <org>/<repo>
#
# 이미 있는 라벨은 색/설명만 갱신하고, 없으면 새로 만듭니다.
# 저장소에 남아 있는 다른 라벨은 지우지 않습니다. (--prune 옵션으로 정리 가능)
#
# 라벨 정의: docs/issue.md

set -euo pipefail

REPO="${1:-}"
PRUNE="${2:-}"

if [[ -z "$REPO" ]]; then
  echo "usage: $0 <org>/<repo> [--prune]" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh CLI 가 필요합니다. https://cli.github.com" >&2
  exit 1
fi

# name|color|description
LABELS=(
  "type: bug|d73a4a|의도한 대로 동작하지 않음"
  "type: feature|0e8a16|새 기능 · 개선"
  "type: refactor|1d76db|동작 변화 없는 구조 개선"
  "type: docs|0075ca|문서"
  "type: chore|cfd3d7|빌드 · 설정 · 의존성"
  "type: question|d876e3|질문 · 논의"

  "P0: urgent|b60205|서비스 중단 · 데이터 손실. 즉시 대응"
  "P1: high|d93f0b|핵심 기능 불가. 이번 스프린트"
  "P2: normal|fbca04|불편하나 우회 가능. 다음 릴리스"
  "P3: low|c2e0c6|있으면 좋음"

  "status: blocked|000000|다른 작업 · 외부 응답 대기"
  "status: need-info|fef2c0|작성자에게 추가 정보 요청함"
  "status: wontfix|ffffff|의도된 동작이거나 고치지 않기로 결정"
  "status: duplicate|cfd3d7|중복 이슈"

  "good first issue|7057ff|신규 합류자가 시작하기 좋은 작업"
)

echo "==> $REPO 에 라벨 적용"

for entry in "${LABELS[@]}"; do
  IFS='|' read -r name color desc <<< "$entry"
  if gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" 2>/dev/null; then
    echo "  + $name"
  else
    gh label edit "$name" --repo "$REPO" --color "$color" --description "$desc" >/dev/null
    echo "  = $name"
  fi
done

# GitHub 기본 라벨 중 우리 체계와 겹치거나 안 쓰는 것 제거
if [[ "$PRUNE" == "--prune" ]]; then
  echo "==> 기본 라벨 정리"
  for name in "bug" "enhancement" "documentation" "duplicate" "question" "wontfix" "invalid" "help wanted"; do
    if gh label delete "$name" --repo "$REPO" --yes 2>/dev/null; then
      echo "  - $name"
    fi
  done
fi

echo "완료. https://github.com/$REPO/labels"
