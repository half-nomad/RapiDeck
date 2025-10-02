# RapiDeck - Product Requirements Document (PRD)

**버전**: 1.0.0 (Beta)
**작성일**: 2025-10-02
**프로젝트명**: RapiDeck (Rapid + Deck)

---

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [비전 및 목표](#2-비전-및-목표)
3. [타겟 사용자](#3-타겟-사용자)
4. [핵심 기능](#4-핵심-기능)
5. [사용자 워크플로우](#5-사용자-워크플로우)
6. [기술 스택](#6-기술-스택)
7. [시스템 아키텍처](#7-시스템-아키텍처)
8. [데이터 모델](#8-데이터-모델)
9. [보안 및 개인정보](#9-보안-및-개인정보)
10. [개발 로드맵](#10-개발-로드맵)
11. [성공 지표](#11-성공-지표)

---

## 1. 프로젝트 개요

### 1.1 프로젝트 설명
**RapiDeck**은 AI를 활용하여 기획안, 제안서, 강의안 등의 문서를 일관성 있는 디자인의 HTML 슬라이드로 자동 변환하는 웹 서비스입니다.

### 1.2 핵심 가치 제안
- ⏱️ **속도**: 1시간 걸리던 슬라이드 제작을 10분으로 단축 (6배 향상)
- 🎨 **일관성**: 엄격한 디자인 시스템으로 전문적인 비주얼 보장
- 🤖 **AI 주도**: Gemini API가 문서 분석부터 슬라이드 생성까지 자동화
- 🚀 **완성도 우선**: 완벽보다는 빠른 완성에 초점

### 1.3 차별화 요소
- **레퍼런스 기반 디자인**: 사용자 제공 HTML 템플릿 스타일 엄격 준수
- **2단계 워크플로우**: 불완전한 기획안도 AI가 구조화 지원
- **다양한 콘텐츠 타입**: 강의안, 보고서, 제안서, 뉴스레터 자동 인식
- **서버 사이드 변환**: HTML, PDF, PPT 고품질 변환

---

## 2. 비전 및 목표

### 2.1 비전
> "누구나 10분 만에 전문가 수준의 슬라이드를 만드는 세상"

### 2.2 미션
비개발자도 쉽게 사용할 수 있는 AI 기반 슬라이드 자동화 도구 제공

### 2.3 목표
- **단기 목표 (Beta)**:
  - 1개 템플릿 기반 슬라이드 생성 검증
  - 사용자 피드백 수집 및 개선
  - HTML/PDF/PPT 변환 기능 안정화

- **중기 목표 (6개월)**:
  - 다양한 미리 제작된 템플릿 제공 (3-5개)
  - 사용자 커스텀 템플릿 업로드 기능
  - 이미지 삽입 워크플로우 구현

- **장기 목표 (1년)**:
  - 협업 기능 추가 (팀 공유, 댓글)
  - 템플릿 마켓플레이스 운영
  - Enterprise 플랜 출시

---

## 3. 타겟 사용자

### 3.1 주요 페르소나

#### 페르소나 1: 바쁜 마케터 (30대, 중소기업)
- **니즈**: 빠르게 제안서, 보고서 슬라이드 제작
- **페인포인트**: PowerPoint 디자인에 시간 낭비
- **목표**: 내용에 집중하고 싶음

#### 페르소나 2: 강사/교육자 (40대)
- **니즈**: 강의 슬라이드를 일관된 디자인으로 제작
- **페인포인트**: 슬라이드 디자인 전문 지식 부족
- **목표**: 학습자에게 전문적인 자료 제공

#### 페르소나 3: 스타트업 CEO (20-30대)
- **니즈**: 투자 제안서, IR 자료 빠른 제작
- **페인포인트**: 디자이너 고용 비용 부담
- **목표**: 최소 비용으로 퀄리티 높은 자료 제작

### 3.2 사용자 특성
- **기술 수준**: 비개발자, 중학생 수준의 일반 지식
- **목표**: 완벽보다는 완성도에 포커스
- **환경**: 주로 PC 사용, 모바일 브라우저 보조 지원

---

## 4. 핵심 기능

### 4.1 베타 버전 (MVP)

#### 4.1.1 문서 입력 및 분석
- **입력 방식**:
  - 텍스트 복사/붙여넣기
  - 마크다운 형식 업로드
- **문서 제한**: 최대 30페이지 (초과 시 자동 잘라내기 + 경고)
- **AI 분석**: Gemini가 콘텐츠 타입 자동 인식 (강의안/보고서/제안서/뉴스레터)

#### 4.1.2 2단계 슬라이드 생성 워크플로우
1. **문서 분석 단계**:
   - 입력 문서 구조 평가
   - 불완전 시 슬라이드 기획안 제안
   - 사용자 확인 대기

2. **슬라이드 생성 단계**:
   - 확정된 기획안 기반 HTML 코드 생성
   - 디자인 가이드라인 엄격 준수
   - 완성된 슬라이드 미리보기 제공

#### 4.1.3 채팅 기반 수정 기능
- **유저 프롬프트**: 추가 맥락 제공, 수정 요청
- **AI 반응**:
  - 전체 재생성 또는 부분 수정 (유연한 대응)
  - 수정 내용 설명 메시지 표시
- **대화 이력**: 세션 동안 채팅 기록 유지

#### 4.1.4 슬라이드 저장 및 관리
- **저장 정책**:
  - 사용자당 최대 5개 슬라이드 저장
  - Pin 기능: 5개 중 최대 4개 고정 (자동 삭제 방지)
  - 6번째 생성 시 Pin되지 않은 가장 오래된 슬라이드 삭제 (경고/확인 필수)
- **대시보드**:
  - 썸네일 미리보기
  - 제목, 생성일 표시
  - 재편집, 다운로드, 삭제 기능

#### 4.1.5 결과물 제공
- **미리보기**: 웹에서 슬라이드 확인 (16:9 비율)
- **다운로드 옵션**:
  - HTML 파일 (단일 파일)
  - PDF 변환 (서버 사이드, Headless Chrome)
  - PPT 변환 (서버 사이드, python-pptx 또는 스크린샷 기반)
- **복사 기능**: HTML 코드 클립보드 복사

#### 4.1.6 백그라운드 작업 처리
- **로딩 UX**: 프로그레스 바 + 단계별 상태 표시
- **비동기 처리**: Solid Queue로 Gemini API 호출 및 변환 작업 처리
- **실시간 업데이트**: Turbo Streams로 진행 상태 UI 반영
- **알림**: 작업 완료 시 알림 (다른 페이지 이동 가능)

#### 4.1.7 사용자 인증 및 API 관리
- **로그인 방식**:
  - Google OAuth
  - Rails 자체 회원가입/로그인
- **API 키 관리**:
  - 사용자가 Google AI Studio에서 Gemini API 키 직접 발급
  - 환경설정에서 API 키 입력 (암호화 저장)
  - RapiDeck은 가이드만 제공 (스크린샷/문서)

#### 4.1.8 에러 처리
- **Gemini API 실패**: "잠시 후 다시 시도해주세요" 알림
- **명확한 에러**: 구체적 메시지 표시 (예: "API 키가 유효하지 않습니다")
- **30페이지 초과**: "입력 문서가 30페이지를 초과했습니다. 처음 30페이지만 처리됩니다." 메시지 + 자동 처리

### 4.2 베타 이후 확장 기능

#### Phase 2: 템플릿 시스템 확장
- **1단계**: 여러 개의 미리 제작된 템플릿 제공 (3-5개)
  - 비즈니스용, 기술 발표용, 교육용 등
  - 갤러리 형태 미리보기 UI
- **2단계**: 사용자 커스텀 템플릿 업로드
  - 자신의 HTML 파일 업로드
  - 개인 전용 템플릿 저장

#### Phase 3: 고급 기능
- **이미지 삽입**:
  - 사용자 이미지 업로드
  - AI가 적절한 위치에 배치
  - ZIP 파일 프로젝트로 제공
- **레퍼런스 기반 모드**:
  - 사용자 제공 HTML 파일 분석
  - 스타일 자동 추출 및 적용
- **버전 관리**: 슬라이드 수정 이력 추적
- **공유 기능**: URL 공유 (읽기 전용)

---

## 5. 사용자 워크플로우

### 5.1 베타 버전 주요 플로우

```
[회원가입/로그인]
    ↓
[API 키 설정] (최초 1회)
    ↓
[문서 입력] (텍스트 또는 마크다운)
    ↓
[채팅창에서 추가 요청] (선택 사항)
    ↓
[Gemini 분석 시작]
    ↓
[불완전한 문서?]
    ├─ Yes → [기획안 제안] → [사용자 확인] → [수정 또는 승인]
    └─ No → [슬라이드 생성]
    ↓
[프로그레스 바 표시] (백그라운드 작업)
    ↓
[완료 알림]
    ↓
[미리보기 화면]
    ↓
[수정 필요?]
    ├─ Yes → [채팅으로 요청] → [AI 수정] → [미리보기]
    └─ No → [저장 또는 다운로드]
    ↓
[HTML/PDF/PPT 선택]
    ↓
[다운로드 완료]
```

### 5.2 대시보드 플로우
```
[로그인]
    ↓
[대시보드]
    ├─ 새 슬라이드 만들기 → [문서 입력 플로우]
    ├─ 최근 슬라이드 보기 (최대 5개)
    │   ├─ Pin된 슬라이드 (최대 4개)
    │   └─ 일반 슬라이드
    ├─ 슬라이드 클릭 → [미리보기/편집/다운로드]
    └─ 환경 설정 → [API 키 관리]
```

---

## 6. 기술 스택

### 6.1 Backend
- **Ruby**: 3.4.4
- **Rails**: 8.0.2
- **Database**: SQLite3 2.7.4
- **Background Jobs**: Solid Queue
- **WebSocket**: Solid Cable (실시간 진행 상태)
- **Caching**: Solid Cache

### 6.2 Frontend
- **CSS Framework**: Tailwind CSS 4
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **Module Bundler**: Importmap
- **Charts**: Chart.js (CDN)
- **Font**: Pretendard (CDN)

### 6.3 AI & External APIs
- **AI Model**: Gemini API (Google AI Studio)
- **PDF 변환**: Grover gem (Headless Chrome)
- **PPT 변환**: python-pptx (시스템 콜) 또는 스크린샷 기반

### 6.4 Infrastructure
- **Containerization**: Docker
- **Deployment**: Kamal
- **Hosting**: Digital Ocean
- **Web Server**: Puma
- **Proxy**: Kamal Proxy

### 6.5 Security
- **암호화**: Rails Encrypted Credentials, attr_encrypted gem
- **OAuth**: Google OAuth2
- **환경 변수**: Kamal Secrets

---

## 7. 시스템 아키텍처

### 7.1 전체 아키텍처
```
[사용자 브라우저]
    ↓ HTTPS
[Kamal Proxy (Traefik)]
    ↓
[Rails 8 Application]
    ├─ Turbo/Stimulus (UI)
    ├─ Solid Queue (백그라운드 작업)
    ├─ Solid Cable (WebSocket)
    └─ Solid Cache (캐싱)
    ↓
[SQLite Database]
    ├─ 사용자 정보 (암호화)
    ├─ 슬라이드 데이터
    └─ 작업 큐

[External Services]
    ├─ Gemini API (슬라이드 생성)
    ├─ Google OAuth (로그인)
    └─ Headless Chrome (PDF 변환)
```

### 7.2 핵심 모듈

#### 7.2.1 DocumentParser Service
- 입력 문서 분석
- 페이지 수 체크 (30페이지 제한)
- 텍스트/마크다운 파싱

#### 7.2.2 GeminiClient Service
- Gemini API 호출
- 시스템 프롬프트 + 유저 프롬프트 전송
- HTML 코드 응답 처리
- 에러 핸들링

#### 7.2.3 SlideGenerator Service
- 슬라이드 구조화
- 디자인 가이드라인 검증
- HTML 코드 저장

#### 7.2.4 ConversionService
- HTML → PDF (Grover)
- HTML → PPT (python-pptx)
- 백그라운드 작업 큐 관리

#### 7.2.5 ChatService
- 채팅 메시지 관리
- 컨텍스트 유지 (세션 기반)
- Gemini API 재호출

---

## 8. 데이터 모델

### 8.1 주요 모델

#### User (사용자)
```ruby
class User < ApplicationRecord
  # Authentication
  has_secure_password

  # OAuth
  has_many :oauth_providers

  # Gemini API Key (암호화)
  attr_encrypted :gemini_api_key

  # Associations
  has_many :slides, dependent: :destroy
  has_many :chat_sessions, dependent: :destroy
end
```

#### Slide (슬라이드)
```ruby
class Slide < ApplicationRecord
  belongs_to :user
  has_many :slide_versions, dependent: :destroy
  has_one :chat_session, dependent: :destroy

  # Fields
  # - title: string
  # - content_type: string (lecture/report/proposal/newsletter)
  # - html_code: text
  # - thumbnail_url: string
  # - pinned: boolean (default: false)
  # - created_at: datetime
  # - updated_at: datetime

  # Validations
  validates :title, presence: true
  validate :pin_limit

  # Scopes
  scope :pinned, -> { where(pinned: true) }
  scope :recent, -> { order(created_at: :desc).limit(5) }

  private

  def pin_limit
    if pinned && user.slides.pinned.count >= 4
      errors.add(:pinned, "최대 4개까지 고정할 수 있습니다.")
    end
  end
end
```

#### ChatSession (채팅 세션)
```ruby
class ChatSession < ApplicationRecord
  belongs_to :user
  belongs_to :slide, optional: true
  has_many :chat_messages, dependent: :destroy

  # Fields
  # - session_id: string (UUID)
  # - context: text (JSON 저장)
  # - created_at: datetime
end
```

#### ChatMessage (채팅 메시지)
```ruby
class ChatMessage < ApplicationRecord
  belongs_to :chat_session

  # Fields
  # - role: string (user/assistant)
  # - content: text
  # - created_at: datetime
end
```

#### ConversionJob (변환 작업)
```ruby
class ConversionJob < ApplicationRecord
  belongs_to :slide

  # Fields
  # - format: string (pdf/ppt)
  # - status: string (pending/processing/completed/failed)
  # - file_url: string
  # - error_message: text
  # - created_at: datetime
  # - updated_at: datetime
end
```

### 8.2 데이터 저장 정책
- **슬라이드 제한**: 사용자당 최대 5개
- **Pin 제한**: 5개 중 최대 4개
- **삭제 규칙**: Pin되지 않은 슬라이드 중 가장 오래된 것부터 자동 삭제 (경고 후)
- **채팅 세션**: 슬라이드당 1개 세션, 슬라이드 삭제 시 함께 삭제

---

## 9. 보안 및 개인정보

### 9.1 보안 정책
- **API 키 암호화**: `attr_encrypted` gem으로 DB 암호화 저장
- **사용자 정보 암호화**: 모든 개인정보 암호화
- **운영사 열람 불가**: 운영자도 개인정보 복호화 불가
- **HTTPS 필수**: Kamal Proxy에서 Let's Encrypt SSL 자동 인증

### 9.2 개인정보 처리 방침
- **데이터 소유권**:
  - 슬라이드 콘텐츠: 사용자 소유
  - 디자인 시스템: 운영사 소유
- **데이터 보관**: 사용자 계정 삭제 시 모든 데이터 즉시 삭제
- **제3자 제공**: Gemini API에 문서 내용 전송 (사용자 API 키 사용)
- **쿠키 사용**: 세션 관리용 필수 쿠키만 사용

### 9.3 서비스 약관 명시 사항
```
1. 사용자 데이터 소유권
   - 슬라이드 콘텐츠: 사용자 귀속
   - 디자인 시스템: RapiDeck 운영사 소유

2. 개인정보 보호
   - 운영사는 사용자 개인정보를 열람할 수 없습니다.
   - 모든 데이터는 암호화되어 저장됩니다.

3. Gemini API 사용
   - 사용자가 제공한 API 키로 Gemini API 호출
   - 입력 문서는 Google AI Studio로 전송됨 (Google 개인정보 처리방침 적용)

4. 책임 제한
   - RapiDeck은 생성된 슬라이드의 정확성을 보장하지 않습니다.
   - Gemini API 오류로 인한 손실에 대해 책임지지 않습니다.
```

---

## 10. 개발 로드맵

### Phase 1: MVP (Beta) - 2개월
- **Week 1-2**: 기본 인프라 및 인증
  - Rails 8 프로젝트 설정 완료 ✅
  - Google OAuth 연동
  - 사용자 모델 및 API 키 관리

- **Week 3-4**: 문서 입력 및 Gemini 연동
  - DocumentParser 개발
  - GeminiClient 개발
  - 채팅 인터페이스 구현

- **Week 5-6**: 슬라이드 생성 및 미리보기
  - SlideGenerator 개발
  - 디자인 가이드라인 적용
  - 미리보기 UI 구현

- **Week 7**: 변환 기능
  - PDF 변환 (Grover)
  - PPT 변환 (python-pptx)
  - 백그라운드 작업 처리

- **Week 8**: 테스트 및 배포
  - 통합 테스트
  - Kamal 배포
  - 베타 사용자 모집

### Phase 2: 템플릿 확장 - 3개월
- **Month 3**: 템플릿 시스템 설계
- **Month 4**: 3-5개 템플릿 제작
- **Month 5**: 사용자 커스텀 템플릿 업로드 기능

### Phase 3: 고급 기능 - 3개월
- **Month 6**: 이미지 삽입 워크플로우
- **Month 7**: 레퍼런스 기반 모드
- **Month 8**: 협업 기능 (선택적)

---

## 11. 성공 지표

### 11.1 핵심 지표 (KPI)
- **사용자 성장**:
  - 월간 활성 사용자 (MAU): 베타 목표 100명
  - 가입 전환율: 방문자 대비 20% 목표

- **제품 사용**:
  - 슬라이드 생성 완료율: 80% 이상
  - 평균 슬라이드 생성 시간: 10분 이내
  - 재방문율: 주 1회 이상 30% 목표

- **품질 지표**:
  - Gemini API 성공률: 95% 이상
  - PDF/PPT 변환 성공률: 90% 이상
  - 사용자 만족도: NPS 40 이상

### 11.2 사용자 피드백
- **정량 지표**:
  - 별점 평가: 4.0/5.0 이상
  - 추천 의향: 70% 이상

- **정성 피드백**:
  - 베타 사용자 인터뷰 (월 10명)
  - 기능 개선 요청 수집
  - 버그 리포트 대응 속도 (24시간 이내)

### 11.3 비즈니스 지표
- **베타 기간**: 무료 정책
- **향후 수익화**:
  - Freemium 모델 (월 5개 슬라이드 무료, 이후 유료)
  - Pro 플랜: 월 $9.99 (무제한 슬라이드)
  - Enterprise 플랜: 커스텀 견적

---

## 12. 제약 사항 및 가정

### 12.1 기술적 제약
- **Gemini API 의존성**: Google AI Studio 서비스 안정성에 의존
- **SQLite 확장성**: 대규모 트래픽 시 PostgreSQL 마이그레이션 필요
- **서버 사이드 변환**: PDF/PPT 변환 시 서버 리소스 사용량 증가

### 12.2 가정
- 사용자는 Gemini API 키를 직접 발급할 수 있음
- 입력 문서는 30페이지 이내로 작성 가능
- 사용자는 HTML 파일 다운로드 후 로컬에서 편집 가능

### 12.3 베타 기간 제한
- 템플릿 1개만 제공
- 이미지 삽입 미지원
- 협업 기능 미지원
- 무료 정책 (API 비용은 사용자 부담)

---

## 13. 부록

### 13.1 참조 문서
- [DESIGN_GUIDELINES.md](./DESIGN_GUIDELINES.md): 디자인 시스템 상세 가이드
- [SYSTEM_PROMPT.md](./SYSTEM_PROMPT.md): Gemini API 시스템 프롬프트
- [PLAN.md](./PLAN.md): 개발 로드맵 및 체크리스트
- [DEPLOYMENT.md](../DEPLOYMENT.md): Kamal 배포 가이드
- [CHANGELOG.md](./CHANGELOG.md): 개발 로그

### 13.2 외부 레퍼런스
- [Rails 8 공식 문서](https://guides.rubyonrails.org/)
- [Gemini API 문서](https://ai.google.dev/docs)
- [Tailwind CSS 문서](https://tailwindcss.com/docs)
- [Chart.js 문서](https://www.chartjs.org/docs/)

---

**작성자**: Claude + 사용자
**승인자**: TBD
**다음 검토 예정일**: 베타 출시 후 1개월
