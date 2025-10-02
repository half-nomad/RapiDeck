# RapiDeck 개발 로그

## 2025-10-02

### 문서 재구성
- PRD.md v1.1.0 (기술 내용 제거, 개발 순서 변경)
- TRD.md 신규 생성 (기술 요구사항 및 구현 명세)
- PLAN.md v2.0.0 (핵심 기능 우선 순서로 재작성)
- CHANGELOG.md 간소화
- CLAUDE.md (Agent 템플릿 추가 예정)

### 기획 문서 작성
- docs/PRD.md v1.0.0 (제품 요구사항 13개 섹션)
- docs/DESIGN_GUIDELINES.md (디자인 시스템 10개 섹션)
- docs/SYSTEM_PROMPT.md (Gemini API 프롬프트)
- docs/PLAN.md v1.0.0 (초기 개발 로드맵)
- CLAUDE.md (작업 지침서)

### 프로젝트 초기 설정
- Rails 8.0.2 프로젝트 생성
- SQLite 설정 (Gemfile, config/database.yml)
- Kamal 배포 설정 (config/deploy.yml)
- 디렉토리 구조 (app/services, app/components, app/models/design_system)
- DEPLOYMENT.md 작성

### Git 초기화
- 첫 커밋 (6ea2356): 114개 파일, 5,391줄

---

## 2025-10-02 (오후)

### Week 1-2 핵심 기능 프로토타입 완료 ✅

#### 서비스 클래스 구현
- app/services/document_parser.rb
  - 30페이지 제한 로직 (CHARS_PER_PAGE = 500)
  - truncated?, warning_message 메서드
- app/services/gemini_client.rb
  - HTTParty로 Gemini API 연동
  - SYSTEM_PROMPT.md 자동 로드
  - 상세 에러 핸들링 (400, 403, 429, 5xx)
- app/services/slide_generator.rb
  - HTML 제목 자동 추출 (h1/title 태그)

#### 컨트롤러 및 라우트
- app/controllers/slides_controller.rb
  - new, create, show 액션 구현
  - 3개 서비스 클래스 조합
  - 세션 기반 임시 저장 (Week 4에서 DB로 전환 예정)
- config/routes.rb
  - root "slides#new"
  - resources :slides

#### 뷰 파일 (DESIGN_GUIDELINES 준수)
- app/views/slides/new.html.erb
  - 문서 입력 textarea (15줄)
  - API 키 입력 필드
  - Pretendard 폰트, Dark theme (#1e1e1e, #2d2d2d)
  - Cyan 하이라이트 (#22D3EE)
- app/views/slides/show.html.erb
  - iframe 슬라이드 미리보기 (16:9 비율)
  - HTML 다운로드 버튼 (Blob API)
  - HTML 코드 보기 (details/summary)

#### Gem 추가
- Gemfile: httparty 추가
- bundle install 완료

#### 개발 환경 설정
- app/controllers/application_controller.rb
  - 개발 환경에서 CSRF 보호 일시 비활성화 (Week 4에서 복원 예정)

---

**다음 작업**: Week 3 채팅 기반 수정 기능
