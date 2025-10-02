# RapiDeck 개발 로그

## 2025-10-02 - 프로젝트 초기 설정

### 프로젝트 개요
- **프로젝트명**: RapiDeck (Rapid + Deck)
- **목적**: HTML 스타일 템플릿 기반 문서 자동 슬라이드 변환 웹 서비스
- **핵심 가치**: 빠른 슬라이드 제작

### 완료된 작업

#### 1. Rails 8 프로젝트 생성
```bash
rails new RapiDeck --css=tailwind --database=postgresql
```

**생성된 기본 구조**:
- Ruby 3.4.4
- Rails 8.0.2
- 기본 데이터베이스: PostgreSQL (이후 SQLite로 변경)
- CSS: Tailwind CSS 4
- JavaScript: Hotwire (Turbo + Stimulus)

**Rails 8 새 기능 포함**:
- Solid Cache (데이터베이스 기반 캐싱)
- Solid Queue (백그라운드 작업 처리)
- Solid Cable (WebSocket 실시간 통신)
- PWA 지원
- Kamal 배포 도구 내장

#### 2. 데이터베이스를 SQLite로 변경

**변경 이유**:
- 개발 및 프로덕션 환경 단순화
- 파일 기반 데이터베이스로 배포 간편화
- 초기 프로젝트에 적합한 경량 솔루션

**변경 파일**:

**Gemfile** (`/mnt/c/Users/mokka/Claude-project/RapiDeck/Gemfile`)
```ruby
# Before
gem "pg", "~> 1.1"

# After
gem "sqlite3", ">= 2.1"
```

**config/database.yml** (`/mnt/c/Users/mokka/Claude-project/RapiDeck/config/database.yml`)
```yaml
default: &default
  adapter: sqlite3
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: storage/development.sqlite3

test:
  <<: *default
  database: storage/test.sqlite3

production:
  primary: &primary_production
    <<: *default
    database: storage/production.sqlite3
  cache:
    <<: *primary_production
    database: storage/production_cache.sqlite3
    migrations_paths: db/cache_migrate
  queue:
    <<: *primary_production
    database: storage/production_queue.sqlite3
    migrations_paths: db/queue_migrate
  cable:
    <<: *primary_production
    database: storage/production_cable.sqlite3
    migrations_paths: db/cable_migrate
```

**의존성 설치**:
```bash
bundle install
# sqlite3 2.7.4 설치 완료
```

#### 3. Kamal + Digital Ocean 배포 설정

**config/deploy.yml** 주요 설정:

```yaml
service: rapideck
image: your-docker-username/rapideck

servers:
  web:
    - YOUR_DROPLET_IP  # Digital Ocean Droplet IP

proxy:
  ssl: true
  host: rapideck.example.com

registry:
  server: registry.digitalocean.com
  username: your-docker-username
  password:
    - KAMAL_REGISTRY_PASSWORD

volumes:
  - "rapideck_storage:/rails/storage"

builder:
  arch: amd64
```

**주요 특징**:
- Zero-downtime 배포
- Let's Encrypt SSL 자동 인증
- Docker 볼륨을 통한 SQLite 데이터 영구 저장
- Digital Ocean Container Registry 지원

**환경 변수 설정** (`.kamal/secrets`):
```bash
KAMAL_REGISTRY_PASSWORD=$KAMAL_REGISTRY_PASSWORD
RAILS_MASTER_KEY=$(cat config/master.key)
```

#### 4. 배포 문서 작성

**DEPLOYMENT.md** 생성 (`/mnt/c/Users/mokka/Claude-project/RapiDeck/DEPLOYMENT.md`)

**주요 내용**:
- Digital Ocean 계정 설정 가이드
- Droplet 생성 사양 (최소: 1 vCPU, 1GB RAM, 25GB Storage)
- Kamal 배포 프로세스
- SQLite 데이터베이스 백업 방법
- 트러블슈팅 가이드
- 비용 절감 팁

**배포 명령어**:
```bash
# 초기 배포
kamal server bootstrap
kamal setup

# 업데이트 배포
kamal deploy

# 롤백
kamal rollback
```

#### 5. 프로젝트 디렉토리 구조 설계

**추가 생성된 디렉토리**:
```bash
mkdir -p app/services app/components app/models/design_system
```

**디렉토리 용도**:
- `app/services/`: 비즈니스 로직 (DocumentParser, SlideGenerator, StyleApplier)
- `app/components/`: ViewComponent 기반 UI 컴포넌트
- `app/models/design_system/`: 디자인 시스템 관련 모델

#### 6. MCP 서버 최적화

**현재 활성화된 MCP 서버**:
- **Context7**: Rails/라이브러리 문서 검색
- **Browser MCP**: 브라우저 자동화 (테스트용)

**비활성화된 MCP 서버**:
- Notion API
- Firecrawl
- Apify Actors
- SQLite MCP
- Slack
- Naver Search
- Playwright

**관리 도구**:
- 스크립트: `/home/mokka/claude-mcp`
- 문서: `/home/mokka/claude-mcp-docs.md`
- 레지스트리: `/home/mokka/.claude-mcp-registry.json`

### 기술 스택 정리

#### Backend
- **Ruby**: 3.4.4
- **Rails**: 8.0.2
- **Database**: SQLite3 2.7.4

#### Frontend
- **CSS**: Tailwind CSS 4
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **Module Bundler**: Importmap

#### Infrastructure
- **Containerization**: Docker
- **Deployment**: Kamal
- **Hosting**: Digital Ocean
- **Web Server**: Puma
- **Proxy**: Kamal Proxy (Traefik 후속)

#### Rails 8 기능
- **Solid Cache**: 데이터베이스 기반 캐싱
- **Solid Queue**: 백그라운드 작업
- **Solid Cable**: WebSocket
- **PWA**: Progressive Web App

### 프로젝트 파일 현황

#### 설정 파일
- `Gemfile` - Ruby 의존성 관리
- `config/database.yml` - SQLite 설정
- `config/deploy.yml` - Kamal 배포 설정
- `.kamal/secrets` - 환경 변수 템플릿

#### 문서
- `DEPLOYMENT.md` - 배포 가이드 (완료)
- `docs/CHANGELOG.md` - 개발 로그 (본 문서)

#### 디렉토리
- `app/services/` - 비즈니스 로직 (생성됨, 비어있음)
- `app/components/` - UI 컴포넌트 (생성됨, 비어있음)
- `app/models/design_system/` - 디자인 시스템 모델 (생성됨, 비어있음)
- `storage/` - SQLite 데이터베이스 저장소

### 다음 단계 (미완료)

#### 기획 단계
- [ ] RapiDeck 핵심 기능 정의
- [ ] 입력 형식 결정 (Markdown, JSON, 텍스트 등)
- [ ] HTML 템플릿 레퍼런스 분석
- [ ] 시스템 아키텍처 설계
- [ ] 데이터 모델 설계

#### 개발 단계
- [ ] 템플릿 관리 시스템 개발
- [ ] 문서 파서 개발
- [ ] 슬라이드 생성 엔진 개발
- [ ] 실시간 미리보기 구현
- [ ] PDF/HTML 내보내기 기능

#### 문서화
- [ ] README.md 작성
- [ ] API 문서 작성
- [ ] 사용자 가이드 작성

### 보류된 결정사항

1. **입력 문서 형식**: Markdown vs JSON vs 텍스트 vs 파일 업로드
2. **템플릿 시스템**: 사용자가 직접 만들기 vs 기존 템플릿 사용
3. **협업 기능**: 단독 사용 vs 팀 협업
4. **내보내기 형식**: HTML, PDF, PPT 중 우선순위

### 참고사항

#### Context7을 통해 확인한 문서
- Rails 8 SQLite 설정 방법
- Kamal Digital Ocean 배포 가이드

#### 프로젝트 위치
```
/mnt/c/Users/mokka/Claude-project/RapiDeck
```

#### 개발 서버 실행 방법
```bash
cd /mnt/c/Users/mokka/Claude-project/RapiDeck
bin/dev  # Rails + Tailwind watch 동시 실행
```

### 이슈 및 해결

#### 이슈 1: PostgreSQL에서 SQLite로 변경
- **원인**: 초기 `rails new` 명령어에서 `--database=postgresql` 옵션 사용
- **해결**: Gemfile과 database.yml 수정 후 `bundle install`

#### 이슈 2: 프로젝트 문서화 시도 중단
- **원인**: 기획 단계 없이 문서부터 작성 시도
- **해결**: 기획 우선 진행으로 방향 전환

### 회고

#### 잘된 점
- Rails 8 최신 버전으로 프로젝트 시작
- Kamal 배포 도구 초기 설정 완료
- SQLite로 간단하고 효율적인 데이터베이스 구성
- 배포 문서 상세하게 작성

#### 개선할 점
- 기획 단계를 먼저 진행했어야 함
- 레퍼런스 HTML 템플릿 먼저 분석 필요
- 핵심 기능 우선순위 정의 필요

---

## 2025-10-02 - PRD 및 기획 문서 작성 완료

### 완료된 작업

#### 7. 프로젝트 기획 및 요구사항 정의
**작업 시간**: 약 3시간
**작업 방식**: 사용자와 대화형으로 요구사항 수집 및 문서화

**Q&A 기반 요구사항 수집**:
- 핵심 문제 해결: 일관성 있는 디자인의 HTML+CSS+바닐라 JS 슬라이드 빠른 제작 (1시간 → 10분)
- 타겟 사용자: 완벽보다는 완성도에 포커스를 두는 슬라이드 제작자
- 입력 방식: 텍스트 복사/붙여넣기 + 마크다운 형식
- AI 역할: Gemini API가 실질적 작업 주도, RapiDeck은 UI 래퍼
- 사용자 관리: Google OAuth + Rails 자체 로그인, 개인 사용 (협업 기능 없음)
- 결과물: HTML, PDF, PPT (서버 사이드 변환)
- 저장 정책: 최대 5개 슬라이드, Pin 기능 4개
- 페이지 제한: 최대 30페이지 (베타 기간)

#### 8. 샘플 HTML 분석 및 디자인 시스템 구축
**파일**: `/mnt/c/Users/mokka/Downloads/dark_info_graphic_deck.html`

**분석 결과**:
- **슬라이드 크기**: 960px × 540px (16:9)
- **색상 팔레트**: Dark theme (#1e1e1e, #191919, #2d2d2d)
- **하이라이트**: Cyan (#22D3EE), Pink (#F472B6), Yellow (#FBBF24), Green (#34D399)
- **폰트**: Pretendard (CDN)
- **프레임워크**: Tailwind CSS + Chart.js
- **컴포넌트**: `.slide`, `.card`, `.flow-box`, `.flow-arrow`

**생성된 문서**: `docs/DESIGN_GUIDELINES.md`
- 10개 섹션으로 구성된 완전한 디자인 시스템 가이드라인
- 색상, 타이포그래피, 컴포넌트 라이브러리 엄격 정의
- 콘텐츠 타입별 레이아웃 패턴 (강의안/보고서/제안서/뉴스레터)
- 금지 사항 명시 (색상 변경, 폰트 변경, 슬라이드 크기 변경 등)

#### 9. Gemini API 시스템 프롬프트 작성
**파일**: `docs/SYSTEM_PROMPT.md`

**기존 프롬프트 분석**:
- 사용자 제공 교육용 슬라이드 시스템 프롬프트 분석
- 마크다운 출력 기준 → HTML 직접 생성으로 변경 필요 확인

**RapiDeck용 프롬프트 수정**:
- **목적 1**: 불완전한 기획안 시 슬라이드 기획안 먼저 제안 (2단계 워크플로우)
- **목적 2**: 다양한 콘텐츠 타입 지원 (강의안, 보고서, 제안서, 뉴스레터)
- **엄격한 디자인 가이드라인 준수**: 샘플 HTML 스타일 절대 준수
- **출력 형식**: 완성된 HTML 코드 (<!DOCTYPE html>부터 </html>까지)

**프롬프트 구성**:
- Role, Context, Workflow (3단계)
- Design Guidelines 엄격 준수 지침
- Content Type Templates (4가지)
- Chart.js Guidelines
- 제약사항 (MUST DO / MUST NOT DO)
- 사용자 인터랙션 가이드라인
- 에러 핸들링

#### 10. 제품 요구사항 문서 (PRD) 작성
**파일**: `docs/PRD.md`

**문서 구성** (13개 섹션):
1. 프로젝트 개요
2. 비전 및 목표 (1시간 → 10분, 6배 향상)
3. 타겟 사용자 (3개 페르소나)
4. 핵심 기능 (베타 버전 8개 기능 + Phase 2-3 확장)
5. 사용자 워크플로우 (플로우차트)
6. 기술 스택 (Rails 8 + Gemini API)
7. 시스템 아키텍처 (5개 핵심 서비스)
8. 데이터 모델 (User, Slide, ChatSession 등)
9. 보안 및 개인정보 (암호화, 소유권, 서비스 약관)
10. 개발 로드맵 (Phase 1-3, 8개월)
11. 성공 지표 (KPI, 사용자 피드백)
12. 제약 사항 및 가정
13. 부록 (참조 문서)

**핵심 기능 정의**:
- 문서 입력 (텍스트/마크다운, 최대 30페이지)
- 2단계 워크플로우 (기획안 분석 → 슬라이드 생성)
- 채팅 기반 수정 (유연한 전체/부분 수정)
- 슬라이드 저장 및 관리 (최대 5개, Pin 4개)
- 결과물 제공 (HTML/PDF/PPT, 서버 사이드 변환)
- 백그라운드 작업 (Solid Queue + Turbo Streams)
- API 키 관리 (사용자 직접 발급, 암호화 저장)

#### 11. 개발 로드맵 및 체크리스트 작성
**파일**: `docs/PLAN.md`

**로드맵 구성**:
- **Phase 1 (2개월)**: MVP 베타 버전
  - Week 1-2: 인증 시스템
  - Week 3-4: 문서 입력 및 Gemini 연동
  - Week 5-6: 슬라이드 생성 및 미리보기
  - Week 7: 변환 기능 (PDF/PPT)
  - Week 8: 테스트 및 배포

- **Phase 2 (3개월)**: 템플릿 확장
  - Month 3: 템플릿 시스템 설계
  - Month 4: 3-5개 템플릿 제작
  - Month 5: 사용자 커스텀 템플릿 업로드

- **Phase 3 (3개월)**: 고급 기능
  - Month 6: 이미지 삽입 워크플로우
  - Month 7: 레퍼런스 기반 모드
  - Month 8: 협업 기능 (선택적)

**체크리스트**:
- 일일 체크리스트 (개발 시작 전/중/후)
- 주간 리뷰 체크리스트 (매주 금요일)
- 마일스톤 체크포인트 (3개)
- 리스크 관리 (높음/중간/낮음)

#### 12. Claude 작업 지침 문서 작성
**파일**: `CLAUDE.md` (프로젝트 루트)

**구성**:
- 필수 참고 문서 목록 (PRD, DESIGN_GUIDELINES, SYSTEM_PROMPT, PLAN)
- 절대 규칙 (디자인 가이드라인 엄격 준수, PRD 기준 준수, 작업 전 체크리스트 확인)
- 작업 플로우 (시작 전 → 개발 중 → 완료 후)
- 주요 개발 가이드 (Gemini 연동, 디자인, 데이터 모델)
- 질문 기준 (즉시 질문 / 확인 후 진행)
- 문서 업데이트 규칙
- 우선순위 (높음/중간/낮음)
- 배포 전 체크리스트
- 빠른 참조 테이블

### 생성된 문서 목록
1. `docs/PRD.md` - 제품 요구사항 문서 (13개 섹션, 완전한 제품 정의서)
2. `docs/DESIGN_GUIDELINES.md` - 디자인 시스템 가이드라인 (10개 섹션, 엄격한 규칙)
3. `docs/SYSTEM_PROMPT.md` - Gemini API 시스템 프롬프트 (2단계 워크플로우, 4개 콘텐츠 타입)
4. `docs/PLAN.md` - 개발 로드맵 & 체크리스트 (Phase 1-3, 8개월 일정)
5. `CLAUDE.md` - Claude 작업 지침서 (필수 참조 문서, 절대 규칙, 작업 플로우)

### 기술적 결정사항

#### 시스템 아키텍처
- **AI 역할**: Gemini가 실질적 슬라이드 제작 주도
- **RapiDeck 역할**: UI 래퍼 (입력창, 채팅창, 결과 표시)
- **워크플로우**: 2단계 (기획안 분석 → 사용자 확인 → 슬라이드 생성)
- **변환 방식**: 서버 사이드 (Headless Chrome, python-pptx)

#### 데이터 정책
- **저장 제한**: 사용자당 최대 5개 슬라이드
- **Pin 기능**: 5개 중 최대 4개 고정 가능
- **자동 삭제**: Pin되지 않은 가장 오래된 슬라이드 (경고 후 삭제)
- **페이지 제한**: 30페이지 초과 시 자동 잘라내기 + 경고

#### 보안 정책
- **API 키**: 사용자 직접 발급 (Google AI Studio), 암호화 저장
- **개인정보**: 모든 정보 암호화, 운영사 열람 불가
- **소유권**: 콘텐츠는 사용자, 디자인은 운영사

### 다음 단계

#### Week 1-2 작업 (진행 예정)
- [ ] Google OAuth 연동
- [ ] Rails 자체 인증 시스템
- [ ] API 키 관리 (암호화 저장)
- [ ] Git 초기화 및 첫 커밋

#### 기획 단계 완료
- [x] RapiDeck 핵심 기능 정의
- [x] 입력 형식 결정 (텍스트, 마크다운)
- [x] HTML 템플릿 레퍼런스 분석
- [x] 시스템 아키텍처 설계
- [x] 데이터 모델 설계

---

**작업 시간**: 약 3시간
**작업자**: Claude + 사용자
**다음 작업**: Git 초기화 및 Week 1-2 개발 시작 (인증 시스템)
