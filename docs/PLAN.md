# RapiDeck 개발 로드맵 & 체크리스트

**버전**: 1.0.0
**최종 업데이트**: 2025-10-02

---

## 📋 목차

1. [Phase 1: MVP (Beta)](#phase-1-mvp-beta---2개월)
2. [Phase 2: 템플릿 확장](#phase-2-템플릿-확장---3개월)
3. [Phase 3: 고급 기능](#phase-3-고급-기능---3개월)
4. [일일 체크리스트](#일일-체크리스트)

---

## Phase 1: MVP (Beta) - 2개월

### Week 1-2: 기본 인프라 및 인증 시스템

#### ✅ 완료된 작업
- [x] Rails 8 프로젝트 생성 (SQLite 설정)
- [x] Kamal 배포 설정 (Digital Ocean)
- [x] 디렉토리 구조 설계
- [x] **PRD 문서 작성** (docs/PRD.md) - 2025-10-02
  - [x] 프로젝트 비전 및 목표 정의
  - [x] 타겟 사용자 페르소나 작성
  - [x] 베타 버전 핵심 기능 명세 완료
  - [x] 기술 스택 및 시스템 아키텍처 설계
  - [x] 데이터 모델 설계
  - [x] 보안 및 개인정보 정책 수립
  - [x] 개발 로드맵 및 성공 지표 정의
- [x] **디자인 가이드라인 문서 작성** (docs/DESIGN_GUIDELINES.md) - 2025-10-02
  - [x] 샘플 HTML 파일 분석 완료
  - [x] 색상 팔레트 정의 (HEX 코드 포함)
  - [x] 타이포그래피 규칙 (Pretendard 폰트)
  - [x] 컴포넌트 라이브러리 문서화
  - [x] 레이아웃 패턴 정의
  - [x] Chart.js 스타일 가이드
  - [x] 콘텐츠 타입별 레이아웃 가이드
  - [x] 금지 사항 명시
- [x] **Gemini 시스템 프롬프트 작성** (docs/SYSTEM_PROMPT.md) - 2025-10-02
  - [x] 역할 및 컨텍스트 정의
  - [x] 2단계 워크플로우 설계 (기획안 분석 → 슬라이드 생성)
  - [x] 4가지 콘텐츠 타입 템플릿 작성
  - [x] 디자인 가이드라인 엄격 준수 지침 포함
  - [x] Chart.js 가이드라인 포함
  - [x] 에러 핸들링 및 사용자 인터랙션 가이드
- [x] **개발 로드맵 및 체크리스트 작성** (docs/PLAN.md) - 2025-10-02
  - [x] Phase 1-3 상세 일정 수립
  - [x] 주차별 작업 체크리스트
  - [x] 일일/주간 체크리스트
  - [x] 마일스톤 체크포인트
  - [x] 리스크 관리 계획
- [x] **Claude 작업 지침 문서 작성** (CLAUDE.md) - 2025-10-02
  - [x] 필수 참고 문서 목록 정리
  - [x] 절대 규칙 명시 (디자인 가이드라인 엄격 준수 등)
  - [x] 작업 플로우 정의
  - [x] 질문 기준 및 우선순위 설정
  - [x] 빠른 참조 테이블 작성

#### 🔲 진행 예정 작업
- [ ] Google OAuth 연동
  - [ ] `omniauth-google-oauth2` gem 설치
  - [ ] Google Cloud Console에서 OAuth 클라이언트 ID 발급
  - [ ] `config/initializers/omniauth.rb` 설정
  - [ ] `SessionsController` 구현
  - [ ] OAuth 콜백 라우트 설정

- [ ] Rails 자체 인증 시스템
  - [ ] User 모델 생성 (`has_secure_password`)
  - [ ] 회원가입/로그인 뷰 및 컨트롤러
  - [ ] 비밀번호 암호화

- [ ] API 키 관리
  - [ ] `attr_encrypted` gem 설치
  - [ ] User 모델에 `gemini_api_key` 암호화 필드 추가
  - [ ] 환경 설정 페이지 UI 구현
  - [ ] API 키 유효성 검증 (Gemini API 테스트 호출)

**체크리스트**:
```
□ Google OAuth 로그인 테스트 완료
□ Rails 자체 로그인 테스트 완료
□ API 키 암호화 저장 확인
□ 환경 설정 페이지 동작 확인
```

---

### Week 3-4: 문서 입력 및 Gemini 연동

#### DocumentParser 개발
- [ ] `app/services/document_parser.rb` 생성
  - [ ] 텍스트 입력 파싱
  - [ ] 마크다운 입력 파싱
  - [ ] 페이지 수 계산 로직 (30페이지 제한)
  - [ ] 초과 시 자동 잘라내기

#### GeminiClient 개발
- [ ] `app/services/gemini_client.rb` 생성
  - [ ] Gemini API HTTP 클라이언트 구현 (`HTTParty` 또는 `Faraday`)
  - [ ] 시스템 프롬프트 로드 (`docs/SYSTEM_PROMPT.md`)
  - [ ] 유저 프롬프트 전송
  - [ ] 응답 HTML 코드 파싱
  - [ ] 에러 핸들링 (API 실패, 타임아웃)

#### 채팅 인터페이스
- [ ] ChatSession 모델 생성
  - [ ] `session_id`, `context`, `user_id` 필드
  - [ ] ChatMessage 모델 (role, content)

- [ ] 채팅 UI 구현
  - [ ] Turbo Frames로 실시간 채팅
  - [ ] 메시지 입력창 (textarea + 전송 버튼)
  - [ ] 메시지 표시 (말풍선 스타일)
  - [ ] 스크롤 자동 하단 이동

**체크리스트**:
```
□ 30페이지 제한 동작 확인
□ Gemini API 호출 성공 테스트
□ 시스템 프롬프트 정상 로드
□ 채팅 메시지 저장 및 표시 확인
```

---

### Week 5-6: 슬라이드 생성 및 미리보기

#### SlideGenerator 개발
- [ ] `app/services/slide_generator.rb` 생성
  - [ ] Gemini 응답 HTML 검증
  - [ ] 디자인 가이드라인 준수 체크
  - [ ] Slide 모델에 저장
  - [ ] 썸네일 생성 (첫 번째 슬라이드 캡처)

#### Slide 모델 및 관리
- [ ] Slide 모델 생성
  - [ ] `title`, `content_type`, `html_code`, `thumbnail_url`, `pinned` 필드
  - [ ] Pin 제한 validation (최대 4개)
  - [ ] 자동 삭제 로직 (5개 초과 시)

- [ ] 대시보드 UI
  - [ ] 최근 5개 슬라이드 목록 (썸네일 + 제목 + 날짜)
  - [ ] Pin/Unpin 버튼
  - [ ] 삭제 버튼 (경고 모달)
  - [ ] "새 슬라이드 만들기" 버튼

#### 미리보기 구현
- [ ] 미리보기 페이지 (`/slides/:id/preview`)
  - [ ] iframe으로 HTML 렌더링
  - [ ] 16:9 비율 유지
  - [ ] 슬라이드 네비게이션 (이전/다음)
  - [ ] 수정/다운로드 버튼

**체크리스트**:
```
□ 슬라이드 생성 후 DB 저장 확인
□ Pin 기능 동작 테스트 (최대 4개 제한)
□ 5개 초과 시 자동 삭제 확인
□ 미리보기 정상 렌더링
```

---

### Week 7: 변환 기능 (PDF/PPT)

#### PDF 변환
- [ ] Grover gem 설치 (`gem 'grover'`)
  - [ ] Puppeteer/Chrome 의존성 설치 (Docker 이미지 업데이트)
  - [ ] `app/services/pdf_converter.rb` 생성
  - [ ] HTML → PDF 변환 로직
  - [ ] A4 또는 16:9 슬라이드 크기 설정

#### PPT 변환
- [ ] python-pptx 시스템 콜 방식
  - [ ] Python 및 python-pptx 설치 (Docker 이미지)
  - [ ] `app/services/ppt_converter.rb` 생성
  - [ ] HTML 파싱 → PPT 슬라이드 생성
  - [ ] 또는 스크린샷 기반 PPT 생성

#### 백그라운드 작업
- [ ] ConversionJob 모델 생성
  - [ ] `format`, `status`, `file_url`, `error_message` 필드

- [ ] Solid Queue 작업 등록
  - [ ] `ConvertToPdfJob` 생성
  - [ ] `ConvertToPptJob` 생성
  - [ ] 작업 완료 시 Turbo Streams로 UI 업데이트

#### 다운로드 UI
- [ ] 다운로드 옵션 버튼 (HTML/PDF/PPT)
  - [ ] HTML: 즉시 다운로드
  - [ ] PDF/PPT: 백그라운드 작업 시작 → 프로그레스 바 → 완료 후 다운로드 링크

**체크리스트**:
```
□ HTML 다운로드 동작 확인
□ PDF 변환 성공 테스트
□ PPT 변환 성공 테스트
□ 백그라운드 작업 완료 알림 확인
```

---

### Week 8: 테스트 및 배포

#### 통합 테스트
- [ ] E2E 테스트 작성 (Capybara 또는 Playwright)
  - [ ] 로그인 → 문서 입력 → 슬라이드 생성 → 다운로드 플로우
  - [ ] Pin 기능 테스트
  - [ ] 채팅 수정 기능 테스트

- [ ] 단위 테스트
  - [ ] DocumentParser 테스트
  - [ ] GeminiClient 테스트 (mock API)
  - [ ] SlideGenerator 테스트

#### 배포
- [ ] Kamal 배포 실행
  - [ ] Digital Ocean Droplet 준비
  - [ ] `kamal setup`
  - [ ] `kamal deploy`
  - [ ] SSL 인증서 자동 발급 확인

- [ ] 모니터링 설정
  - [ ] Rails 로그 확인 (`kamal app logs`)
  - [ ] 에러 추적 (Sentry 또는 Rollbar)

#### 베타 사용자 모집
- [ ] 랜딩 페이지 작성
- [ ] 온보딩 가이드 작성
- [ ] 베타 신청 폼 구현
- [ ] 10명 베타 테스터 모집

**체크리스트**:
```
□ 통합 테스트 모두 통과
□ 배포 성공 및 서비스 정상 작동
□ 베타 사용자 피드백 수집 시작
```

---

## Phase 2: 템플릿 확장 - 3개월

### Month 3: 템플릿 시스템 설계

- [ ] 템플릿 데이터 모델 설계
  - [ ] Template 모델 (name, html_template, thumbnail)
  - [ ] 사용자별 템플릿 선택 기능

- [ ] 템플릿 갤러리 UI
  - [ ] 그리드 레이아웃
  - [ ] 썸네일 미리보기
  - [ ] "선택" 버튼

**체크리스트**:
```
□ 템플릿 모델 설계 완료
□ 갤러리 UI 구현
□ 템플릿 선택 기능 동작 확인
```

---

### Month 4: 3-5개 템플릿 제작

- [ ] 템플릿 1: 비즈니스 제안서 (현재 dark theme)
- [ ] 템플릿 2: 기술 발표 (코드 하이라이팅)
- [ ] 템플릿 3: 교육/강의 (다이어그램 중심)
- [ ] 템플릿 4: 마케팅 리포트 (차트 중심)
- [ ] 템플릿 5: 뉴스레터 (카드 레이아웃)

**체크리스트**:
```
□ 각 템플릿 HTML 파일 작성
□ 디자인 가이드라인 문서 업데이트
□ Gemini 시스템 프롬프트 템플릿별 분기 처리
```

---

### Month 5: 사용자 커스텀 템플릿 업로드

- [ ] 템플릿 업로드 기능
  - [ ] HTML 파일 업로드 UI
  - [ ] 스타일 추출 및 검증
  - [ ] 사용자 전용 템플릿 저장

- [ ] 템플릿 관리
  - [ ] "내 템플릿" 목록
  - [ ] 수정/삭제 기능
  - [ ] 기본 템플릿으로 초기화 버튼

**체크리스트**:
```
□ HTML 업로드 기능 동작 확인
□ 커스텀 템플릿으로 슬라이드 생성 테스트
□ 템플릿 관리 페이지 구현 완료
```

---

## Phase 3: 고급 기능 - 3개월

### Month 6: 이미지 삽입 워크플로우

- [ ] 이미지 업로드 기능
  - [ ] ActiveStorage 설정
  - [ ] 이미지 업로드 UI (드래그 앤 드롭)
  - [ ] Gemini에게 이미지 URL 전달

- [ ] ZIP 파일 프로젝트 생성
  - [ ] `rubyzip` gem 설치
  - [ ] HTML + images/ 폴더 구조 생성
  - [ ] ZIP 파일 다운로드 기능

**체크리스트**:
```
□ 이미지 업로드 동작 확인
□ Gemini가 이미지 적절히 배치
□ ZIP 파일 다운로드 성공
```

---

### Month 7: 레퍼런스 기반 모드

- [ ] HTML 파일 분석 로직
  - [ ] 색상 추출 (CSS 파싱)
  - [ ] 폰트 추출
  - [ ] 레이아웃 패턴 분석

- [ ] 동적 시스템 프롬프트 생성
  - [ ] 추출된 스타일을 Gemini에게 전달
  - [ ] 사용자 HTML 기반 슬라이드 생성

**체크리스트**:
```
□ 사용자 HTML 파일 분석 성공
□ 추출된 스타일로 슬라이드 생성 확인
```

---

### Month 8: 협업 기능 (선택적)

- [ ] URL 공유 기능
  - [ ] 공개 링크 생성 (`/slides/:id/public`)
  - [ ] 읽기 전용 모드

- [ ] 버전 관리 (선택적)
  - [ ] SlideVersion 모델
  - [ ] 수정 이력 저장
  - [ ] 이전 버전 복원 기능

**체크리스트**:
```
□ 공개 링크 공유 기능 동작
□ 읽기 전용 모드 확인
□ (선택) 버전 관리 기능 구현
```

---

## 일일 체크리스트

### 개발 시작 전
```
□ docs/PRD.md 확인 (제품 요구사항)
□ docs/DESIGN_GUIDELINES.md 확인 (디자인 규칙)
□ docs/SYSTEM_PROMPT.md 확인 (Gemini 프롬프트)
□ CLAUDE.md 확인 (작업 지침)
□ 현재 Week 체크리스트 확인
```

### 개발 중
```
□ 변경 사항이 PRD와 일치하는지 확인
□ 디자인 가이드라인 준수 확인
□ 테스트 코드 작성
□ Git commit 메시지 명확히 작성
```

### 개발 완료 후
```
□ 로컬 테스트 완료
□ docs/PLAN.md 체크리스트 업데이트
□ docs/CHANGELOG.md 업데이트
□ PR 생성 (필요 시)
```

### 배포 전
```
□ 모든 테스트 통과 확인
□ 환경 변수 설정 확인 (.kamal/secrets)
□ 데이터베이스 마이그레이션 확인
□ 배포 문서 (DEPLOYMENT.md) 검토
```

---

## 주간 리뷰 체크리스트

### 매주 금요일
```
□ 이번 주 완료된 작업 목록 작성
□ 다음 주 우선순위 작업 선정
□ 블로커(장애물) 식별 및 해결 방안 논의
□ docs/CHANGELOG.md 업데이트
□ 팀원과 진행 상황 공유 (있을 경우)
```

---

## 마일스톤 체크포인트

### Milestone 1: 인증 시스템 완료 (Week 2 종료)
```
□ Google OAuth 로그인 동작
□ Rails 자체 로그인 동작
□ API 키 암호화 저장
□ 환경 설정 페이지 완성
```

### Milestone 2: 슬라이드 생성 완료 (Week 6 종료)
```
□ 문서 입력 → Gemini 호출 → 슬라이드 생성 플로우 동작
□ 채팅 수정 기능 동작
□ 미리보기 정상 표시
□ 대시보드 완성
```

### Milestone 3: 베타 출시 (Week 8 종료)
```
□ PDF/PPT 변환 동작
□ 통합 테스트 통과
□ 배포 완료
□ 베타 사용자 모집 시작
```

---

## 리스크 관리

### 높은 리스크
- **Gemini API 안정성**: API 장애 시 서비스 중단
  - 대응: 에러 핸들링 강화, 사용자에게 상태 명확히 전달

- **PDF/PPT 변환 품질**: Chart.js 등 복잡한 요소 변환 실패
  - 대응: 대안 제공 (HTML만 다운로드), 사용자 피드백 수집

### 중간 리스크
- **SQLite 확장성**: 사용자 증가 시 성능 저하
  - 대응: PostgreSQL 마이그레이션 계획 수립 (Phase 3)

### 낮은 리스크
- **디자인 가이드라인 위반**: Gemini가 규칙 무시
  - 대응: 시스템 프롬프트 개선, HTML 검증 로직 추가

---

**작성자**: Claude
**다음 업데이트 예정일**: 매주 금요일
