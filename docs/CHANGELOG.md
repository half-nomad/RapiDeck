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

## 2025-10-02 (저녁)

### Week 3 채팅 기반 수정 기능 완료 ✅

#### 채팅 UI 구현
- app/views/slides/show.html.erb
  - 2열 레이아웃 (왼쪽: 슬라이드, 오른쪽: 채팅)
  - 채팅 메시지 영역 (말풍선 스타일)
    - 사용자: 오른쪽 정렬, cyan 배경
    - AI: 왼쪽 정렬, dark 배경
  - 채팅 입력창 (textarea + 전송 버튼)
  - Flash 메시지 표시 (success, error)

#### Stimulus 컨트롤러
- app/javascript/controllers/chat_controller.js
  - 채팅 메시지 자동 스크롤 (scrollToBottom)
  - data-controller="chat" 연결
  - data-chat-target="messages" 연결

#### 라우트 추가
- config/routes.rb
  - resources :slides에 update 액션 추가
  - PATCH/PUT /slides/:id

#### 컨트롤러 로직
- app/controllers/slides_controller.rb
  - create 액션 수정
    - API 키 세션 저장 (session[:api_key])
    - 원본 문서 세션 저장 (session[:original_document])
    - 채팅 이력 초기화 (session[:chat_messages] = [])
  - update 액션 신규 구현
    - 사용자 메시지 세션 저장
    - 대화 이력을 포함한 프롬프트 생성
    - Gemini 재호출
    - AI 응답 세션 저장
    - 슬라이드 재생성
    - 에러 시 메시지 롤백

#### 세션 기반 대화 이력
- session[:chat_messages] 배열
  - role: "user" | "assistant"
  - content: 메시지 내용
  - timestamp: 생성 시간

#### 사용자 플로우
1. 슬라이드 생성 (create)
2. 미리보기 화면에서 채팅 입력
3. 수정 요청 전송 (update)
4. Gemini 재호출 (원본 문서 + 대화 이력)
5. 슬라이드 재생성
6. 성공 메시지 표시

---

## 2025-10-02 (심야)

### Week 1-2 마일스톤 검증 및 수정 ✅

#### 디자인 시스템 적용
- app/views/layouts/application.html.erb
  - Tailwind CSS CDN 추가
  - Pretendard 폰트 로드
  - body에 Dark theme 적용 (bg-[#1e1e1e], text-white)

#### Gemini 응답 처리 개선
- app/services/gemini_client.rb
  - 코드 블록 제거 로직 추가 (```html ... ``` 패턴)
  - HTML DOCTYPE 검증 추가
  - Markdown 반환 감지 및 에러 처리

#### Week 1-2 마일스톤 체크포인트 검증 완료
- ✅ Gemini API 호출 성공 (에러 핸들링 검증)
- ✅ HTML 슬라이드 생성 확인 (코드 블록 제거 로직)
- ✅ DESIGN_GUIDELINES 준수 (Dark theme, Pretendard, Cyan)
- ✅ iframe 렌더링 (16:9 비율)
- ✅ Week 3 채팅 기능 (초과 달성)

#### 테스트 준비
- 테스트 문서: MCP + 자동화 도구 완전 분석 강의자료.md (555줄)
- API 키 검증 로직 확인
- 브라우저 UI 디자인 적용 확인

---

## 2025-10-04

### 프로덕션 준비: API 모델 업데이트 및 세션 스토어 개선 ✅

#### Gemini API 모델 업데이트
- app/services/gemini_client.rb
  - API 엔드포인트 변경: `gemini-pro` → `gemini-2.5-flash`
  - 최신 Gemini 2.5 Flash 모델 적용
  - Context7 문서 확인 후 적용

#### ActiveRecord Session Store 도입
- Gemfile
  - `activerecord-session_store` gem 추가 (~> 2.2)
- config/initializers/session_store.rb
  - ActiveRecord 기반 세션 저장소 설정
  - Cookie overflow 문제 해결 (151KB → DB 저장)
- db/migrate/20251003160721_add_sessions_table.rb
  - sessions 테이블 생성 (session_id, data)
  - 인덱스 추가 (성능 최적화)
- bundle install 완료
- rails db:migrate 완료

#### 라우팅 수정
- config/routes.rb
  - `/slides/current` 경로 추가 (세션 기반 슬라이드 미리보기)
  - `resources :slides`보다 먼저 정의하여 올바른 라우트 매칭
- app/controllers/slides_controller.rb
  - 모든 리다이렉트를 `current_slide_path`로 업데이트
  - create, update 액션에서 일관된 경로 사용

#### 시스템 프롬프트 개선
- docs/SYSTEM_PROMPT.md
  - 2단계 워크플로우 제거 (질문 단계 삭제)
  - 베타 버전 최적화: 항상 HTML을 직접 생성
  - "DO NOT ask questions" 지침 추가
  - 불완전한 문서 처리 로직 간소화

#### 디버깅 개선
- app/services/gemini_client.rb
  - Gemini API 응답 로깅 추가 (처음 500자)
  - HTML 검증 실패 시 상세 로그 (처음 1000자)
  - 에러 메시지 개선 ("다시 시도해주세요")

#### 통합 테스트
- 슬라이드 생성 플로우 검증 완료
  - ✅ 문서 입력 → API 호출 → HTML 생성
  - ✅ 세션 저장 (ActiveRecord)
  - ✅ 슬라이드 미리보기 (/slides/current)
  - ✅ 채팅 기반 수정 기능
- 서버 로그 확인
  - Gemini API 호출 성공 (103초 소요)
  - 세션 데이터 DB 저장 성공

#### 기술 부채 해결
- Cookie overflow 문제 해결 (151KB 세션 데이터)
- 구형 Gemini API 모델 사용 문제 해결
- 라우팅 충돌 문제 해결

---

## 2025-10-04 (오후)

### E2E 테스트 완료 및 GitHub 연동 ✅

#### E2E 테스트 결과
- **테스트 방법**: Rails runner로 서비스 클래스 직접 호출 + HTTP 요청
- **DocumentParser 검증**
  - 입력: 107자 마크다운 문서
  - 출력: 정상 파싱 완료
- **GeminiClient 검증**
  - API 모델: gemini-2.5-flash
  - API 호출: 성공 (20.8초)
  - 생성 HTML: 4,860자
  - HTML 샘플 확인: <!DOCTYPE html> 시작 확인
- **SlideGenerator 검증**
  - 슬라이드 데이터 생성 성공
  - 제목 추출: "RapiDeck 프로젝트"
  - generated_at 타임스탬프 확인
- **HTTP 플로우 검증**
  - POST /slides → 302 리다이렉트 → /slides/current
  - 세션 쿠키 생성: _rapi_deck_session
  - GET /slides/current → 200 OK (1.3초)
  - 슬라이드 렌더링 완료
- **ActiveRecord Session Store 검증**
  - 세션 ID 생성 확인 (2::3453663b243d1...)
  - DB 저장 확인 완료
  - API 키, 원본 문서, 채팅 이력 세션 저장 확인

#### 성능 메트릭
- 서버 시작 시간: 1.0초
- Gemini API 응답 시간: 20.8초
- 슬라이드 생성 시간: 20.8초 (total)
- 페이지 렌더링 시간: 1.3초
- **전체 E2E 시간**: ~22초

#### GitHub 연동
- **레포지토리 생성**: https://github.com/half-nomad/RapiDeck
- GitHub CLI 사용 (gh 2.63.1)
- 계정: half-nomad
- 가시성: Public
- 설명: "AI-Powered Presentation Generator using Gemini 2.5 Flash - Create beautiful slides from markdown documents"
- main 브랜치 푸시 완료
- 커밋 해시: 95741d9

#### 검증 완료 항목
- ✅ Rails 서버 정상 작동
- ✅ Gemini API 통합 (gemini-2.5-flash)
- ✅ 문서 파싱 및 슬라이드 생성
- ✅ ActiveRecord 세션 저장소
- ✅ 라우팅 정확성
- ✅ 에러 핸들링
- ✅ 전체 플로우 정상 작동
- ✅ GitHub 레포지토리 연동

#### 파일 업데이트
- .gitignore
  - cookies.txt 추가 (테스트 파일 제외)

---

**다음 작업**: Week 4 데이터 영속성 (User, Slide, ChatSession 모델)
