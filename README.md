# 개발 컨벤션

c-nave organization 의 모든 저장소에 공통으로 적용되는 개발 규칙입니다.

이 저장소(`.github`)는 GitHub 이 특별 취급하는 저장소입니다.
여기에 둔 이슈·PR 템플릿은 **org 내 모든 저장소에서 자동으로 기본 템플릿**이 됩니다.
(저장소가 자체 템플릿을 가지고 있으면 그쪽이 우선합니다)

## 문서

| 문서 | 내용 |
|---|---|
| [브랜치 전략](docs/branch-strategy.md) | Git Flow 브랜치 종류, 네이밍, 릴리스·핫픽스 절차, 머지 전략, 브랜치 보호 규칙 |
| [커밋 컨벤션](docs/commit-convention.md) | Conventional Commits 포맷, type/scope 목록, 이슈 연결, 도구 설정 |
| [PR 가이드](docs/pull-request.md) | PR 제목·본문 작성, PR 크기, 리뷰 규칙, 머지 조건 |
| [이슈 가이드](docs/issue.md) | 이슈 작성법, 라벨 체계, 이슈-브랜치-PR 연결, 운영 규칙 |

## 저장소 구조

```
.github/
├── README.md                          이 문서
├── docs/                              컨벤션 문서
│   ├── branch-strategy.md
│   ├── commit-convention.md
│   ├── pull-request.md
│   └── issue.md
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md       org 전체 PR 기본 템플릿
│   └── ISSUE_TEMPLATE/
│       ├── config.yml
│       ├── bug.yml                    🐞 버그 리포트
│       ├── feature.yml                ✨ 기능 요청
│       └── task.yml                   🔧 작업
└── scripts/
    └── sync-labels.sh                 표준 라벨을 저장소에 일괄 적용
```

## 한눈에 보는 요약

```
이슈 #42 등록  →  develop 에서 feature/42-csv-export 분기
                    →  feat(export): CSV 내보내기 추가  (커밋)
                    →  PR (제목도 동일 형식, 본문에 Closes #42)
                    →  리뷰 1명 승인 + CI 통과
                    →  Squash merge → develop
                    →  릴리스 시 release/1.2.0 → main → 태그 v1.2.0 → develop 역병합
```

| 항목 | 규칙 |
|---|---|
| 기본 브랜치 | `develop` |
| 브랜치 이름 | `feature/42-csv-export` (type/이슈번호-영소문자-하이픈) |
| 커밋 메시지 | `feat(export): CSV 내보내기 추가` (type/scope 영어, 내용 한국어) |
| PR 제목 | 커밋 메시지와 동일 형식 |
| PR 크기 | 400줄 이내 목표 |
| 머지 방식 | feature→develop 은 Squash, release/hotfix→main 은 Merge commit |
| 버전 | SemVer, 태그에 `v` 접두사 (`v1.2.0`) |

## 새 저장소를 만들 때

```bash
REPO=c-nave/<new-repo>

# 1. 라벨 적용
bash scripts/sync-labels.sh $REPO --prune

# 2. develop 브랜치 생성 후 기본 브랜치로 지정
git switch -c develop && git push -u origin develop
gh api -X PATCH repos/$REPO -f default_branch=develop -F delete_branch_on_merge=true

# 3. 브랜치 보호 규칙 적용 (docs/branch-strategy.md 7장 참고)
```

## 적용 범위

- **필수**: 2인 이상이 참여하거나, 배포 산출물이 있는 저장소
- **권장**: 1인 실험용 저장소, PoC 저장소

기존 저장소는 다음 릴리스 사이클부터 순차 적용합니다.

## 규칙 변경

이 저장소에 이슈를 열고 PR 로 제안합니다.
합의되면 머지하고, 변경 사항은 팀 채널에 공지합니다.
