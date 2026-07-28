# 커밋 컨벤션 (Conventional Commits)

[Conventional Commits 1.0.0](https://www.conventionalcommits.org/ko/v1.0.0/) 을 따릅니다.

> **왜 규칙을 정하는가**
> 커밋 메시지는 "지금 코드가 왜 이렇게 됐는지"를 알 수 있는 유일한 기록입니다.
> 6개월 뒤 버그가 터졌을 때 `git log --grep` / `git bisect` 로 원인을 좁혀야 하는데,
> "수정", "ㅇㅇ", "asdf" 같은 메시지가 섞여 있으면 그 순간 히스토리는 쓸모가 없어집니다.
> 부수적으로 태그 사이 커밋을 긁어 릴리스 노트를 자동 생성할 수 있게 됩니다.

---

## 1. 기본 포맷

```
<type>(<scope>): <subject>

<body>

<footer>
```

가장 흔한 형태는 한 줄짜리입니다.

```
feat(export): CSV 내보내기 추가
fix(chart): 항목 정렬 시 좌표 뒤집힘 수정
docs: 브랜치 전략 문서 추가
```

**한 줄 요약 규칙**

| 항목 | 규칙 |
|---|---|
| 언어 | **한국어**. type/scope 만 영어 |
| 길이 | 50자 이내 (넘으면 body 로 분리) |
| 마침표 | 끝에 `.` 붙이지 않음 |
| 시제 | "~함/~추가/~수정" 처럼 **명사형 종결** |
| 내용 | **무엇을 왜** 바꿨는지. "어떻게" 는 코드가 이미 말해준다 |

> 한국어를 쓰는 이유: 팀 전원이 한국어 사용자이고, 커밋 메시지는 코드가 아니라 설명입니다.
> 영어로 쓰다 보면 문장이 짧아지면서 정작 필요한 맥락이 빠집니다.
> 반대로 **코드 주석과 식별자는 영어**를 씁니다.

---

## 2. type 목록

| type | 언제 | 버전 영향 |
|---|---|---|
| `feat` | 새 기능 추가 | MINOR |
| `fix` | 버그 수정 | PATCH |
| `refactor` | 동작 변화 없는 구조 개선 | - |
| `perf` | 성능 개선 | PATCH |
| `test` | 테스트 추가·수정 | - |
| `docs` | 문서만 수정 | - |
| `style` | 포맷·세미콜론·공백 등 코드 의미에 영향 없는 변경 | - |
| `build` | 빌드 시스템·의존성 변경 (gradle, poetry, npm, go.mod) | - |
| `ci` | CI 설정 변경 (GitHub Actions, 배포 스크립트) | - |
| `chore` | 위 어디에도 안 들어가는 잡무 (버전 올리기, .gitignore 등) | - |
| `revert` | 이전 커밋 되돌리기 | - |

**헷갈리기 쉬운 구분**

- `fix` vs `refactor`: **동작이 바뀌면** `fix`, 안 바뀌면 `refactor`
- `style` vs `refactor`: 포매터가 자동으로 할 수 있으면 `style`, 사람이 판단해야 하면 `refactor`
- `chore` vs `build`: 의존성·빌드 설정이면 `build`, 그 외 잡무면 `chore`
- `perf` vs `refactor`: 성능 수치가 목적이면 `perf`, 가독성이 목적이면 `refactor`

---

## 3. scope

변경이 영향을 준 **모듈·컴포넌트 이름**을 넣습니다. 소문자 영어.

- 저장소마다 scope 목록을 `CONTRIBUTING.md` 나 `commitlint.config.js` 에 명시해 둡니다.
- 전체를 건드리거나 딱히 지정할 게 없으면 **생략**합니다. 억지로 만들지 마세요.
- 두 개 이상이면 콤마로 나열하되, 3개를 넘으면 커밋을 쪼개는 걸 먼저 고민합니다.

```
feat(auth): 리프레시 토큰 재발급 추가
fix(api,core): 시간대 파싱 불일치 수정
chore: EditorConfig 추가
```

**scope 는 저장소 구조를 그대로 반영합니다.**

| 저장소 성격 | scope 예 |
|---|---|
| 백엔드 API 서버 | `api`, `auth`, `db`, `batch`, `alarm`, `config` |
| Electron 데스크탑 앱 | `main`, `renderer`, `ipc`, `chart`, `settings`, `installer` |
| 모노레포 | 패키지 디렉토리명 그대로 (`core`, `ui`, `server`, `common`) |

---

## 4. body

**언제 쓰나**: 요약 한 줄로 "왜"가 설명되지 않을 때. 아래 경우는 body 를 쓰세요.

- 버그 수정 → **재현 조건과 원인**
- 성능 개선 → **개선 전/후 수치**
- 비직관적인 선택 → **왜 그 방법을 택했는지, 뭘 검토하고 버렸는지**

**규칙**

- 요약과 body 사이에 빈 줄 1개
- 한 줄 72자 이내
- 목록은 `- ` 사용

```
fix(client): 외부 연동 응답 타임아웃을 3초로 연장

상대 서버가 부하 구간에서 응답이 1.5초까지 늦어지는 것을 운영 로그로 확인.
기존 1초 타임아웃으로는 재시도가 반복되며 커넥션 풀이 고갈돼 요청이 밀렸다.

- 타임아웃 1s -> 3s
- 재시도 3회 -> 2회 (총 대기 시간이 늘어나는 것을 상쇄)
- 타임아웃 값을 설정 파일로 분리해 운영 중 조정 가능하게 함

Refs #142
```

---

## 5. footer

### 이슈 연결

| 키워드 | 효과 |
|---|---|
| `Closes #12` | 머지 시 이슈 **자동 종료** |
| `Fixes #12` | 위와 동일 (버그 이슈에 사용) |
| `Refs #12` | 참조만. 이슈는 열린 채로 유지 |

- 여러 개면 `Closes #12, #15` 또는 줄바꿈으로 나열합니다.
- 다른 저장소 이슈는 `Closes <org>/<repo>#12` 형식으로 씁니다.

> **주의**: `Closes` 는 **기본 브랜치로 머지될 때만** 이슈를 닫습니다.
> 기본 브랜치가 `develop` 이면 `develop` 머지 시점에 닫힙니다.

### 하위 호환이 깨지는 변경

`type` 뒤에 `!` 를 붙이고, footer 에 `BREAKING CHANGE:` 로 무엇이 깨지는지 씁니다.

```
feat(api)!: 목록 조회 응답을 배열에서 객체로 변경

BREAKING CHANGE: GET /items 응답이 [] 에서 {items: [], total: n} 으로 바뀝니다.
클라이언트는 0.8.0 이상으로 함께 올려야 합니다.

Closes #201
```

### 공동 작업자

페어 프로그래밍이나 남의 브랜치를 이어받았을 때:

```
Co-authored-by: 홍길동 <gildong@example.com>
```

---

## 6. 좋은 예 / 나쁜 예

| 나쁨 | 좋음 | 왜 |
|---|---|---|
| `수정` | `fix(chart): 좌표 위경도 순서 뒤바뀜 수정` | 무엇을 고쳤는지 알 수 없음 |
| `버그 픽스함` | `fix(client): 재연결 시 소켓 핸들 누수 수정` | type 만 있고 내용이 없음 |
| `feat: 이것저것 추가` | 커밋을 기능 단위로 분리 | 한 커밋에 여러 관심사가 섞임 |
| `feat: add item filter` | `feat(ui): 목록 필터 추가` | 언어 규칙 위반, scope 누락 |
| `fix: 타임아웃 늘림` | `fix(client): 응답 타임아웃 3초로 연장` + body | 왜 늘렸는지 6개월 뒤 알 수 없음 |
| `chore: wip` | 커밋하지 말고 작업 계속 | wip 커밋은 push 전에 정리 |

---

## 7. 커밋을 쪼개는 기준

**한 커밋 = 하나의 논리적 변경.** 아래 신호가 보이면 쪼개세요.

- 커밋 메시지에 "그리고", "및", "+" 가 들어감
- 되돌리고 싶은 부분만 골라 revert 할 수 없음
- 리뷰어가 diff 를 한 화면에서 이해할 수 없음

포맷팅 변경과 로직 변경은 **반드시 분리**합니다.
포매터가 200줄을 건드린 커밋에 실제 로직 3줄이 숨어 있으면 리뷰가 불가능합니다.

```bash
git add -p          # 변경분을 조각 단위로 골라 스테이징
git commit -m "style(ui): Prettier 적용"
git add .
git commit -m "feat(ui): 목록 필터 추가"
```

---

## 8. 머지 시 커밋 메시지

브랜치 전략상 `feature/*` → `develop` 은 **Squash and merge** 입니다.
squash 되면 브랜치 안의 개별 커밋 메시지는 body 로 접히고, **PR 제목이 최종 커밋 요약**이 됩니다.

→ **PR 제목도 커밋 컨벤션을 그대로 따릅니다.**

```
PR 제목: feat(export): CSV 내보내기 추가
```

GitHub 이 자동으로 붙이는 PR 번호는 그대로 둡니다.
최종 커밋은 `feat(export): CSV 내보내기 추가 (#42)` 가 됩니다.

---

## 9. 도구 설정

### 커밋 템플릿 (모든 언어 공통)

저장소 루트에 `.gitmessage.txt` 를 두고 각자 로컬에서 등록합니다.

```bash
git config commit.template .gitmessage.txt
```

```
# <type>(<scope>): <subject>  ← 50자 이내, 마침표 없음
#
# type: feat fix refactor perf test docs style build ci chore revert
#
# <body>  ← 왜 이 변경이 필요한지. 72자에서 줄바꿈
#
# <footer>
# Closes #이슈번호
# BREAKING CHANGE: <설명>
```

### commitlint (Node 기반 저장소)

```bash
npm i -D @commitlint/cli @commitlint/config-conventional husky
npx husky init
echo 'npx --no -- commitlint --edit "$1"' > .husky/commit-msg
```

```js
// commitlint.config.js
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'scope-enum': [2, 'always', ['main', 'renderer', 'ipc', 'chart', 'settings']],
    'subject-case': [0],        // 한국어 subject 를 쓰므로 대소문자 검사 해제
    'header-max-length': [2, 'always', 72],
  },
}
```

### PR 제목 검사 (언어 무관 — 권장)

Squash merge 를 쓰므로 **PR 제목만 검사해도 `develop` 히스토리는 지켜집니다.**
Python/Go/Java 저장소는 로컬 훅 대신 이 방법을 권장합니다. 훅과 달리 우회가 불가능합니다.

```yaml
# .github/workflows/pr-title.yml
name: PR Title Lint
on:
  pull_request:
    types: [opened, edited, synchronize]

permissions:
  pull-requests: read

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: amannn/action-semantic-pull-request@v5
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          types: |
            feat
            fix
            refactor
            perf
            test
            docs
            style
            build
            ci
            chore
            revert
          requireScope: false
          subjectPattern: ^(?![A-Z]).+$
```

---

## 10. 잘못 쓴 커밋 고치기

```bash
# 아직 push 안 한 마지막 커밋 메시지 수정
git commit --amend

# 아직 push 안 한 최근 3개 정리 (합치기/메시지 수정)
git rebase -i HEAD~3

# 이미 push 했지만 나 혼자 쓰는 feature 브랜치인 경우
git push --force-with-lease
```

> `main`, `develop` 에 올라간 커밋 메시지는 **고치지 않습니다.**
> 히스토리를 다시 쓰면 다른 사람의 로컬 저장소가 깨집니다.
> 잘못된 내용이면 새 커밋으로 바로잡거나 PR 에 코멘트를 남기세요.

---

## 11. 관련 문서

- [브랜치 전략](branch-strategy.md)
- [PR 가이드](pull-request.md)
- [이슈 가이드](issue.md)
