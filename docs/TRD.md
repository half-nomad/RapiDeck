# RapiDeck - Technical Requirements Document (TRD)

**버전**: 1.0.0
**작성일**: 2025-10-02
**프로젝트명**: RapiDeck (Rapid + Deck)

---

## 목차

1. [기술 스택](#1-기술-스택)
2. [개발 환경 설정](#2-개발-환경-설정)
3. [시스템 아키텍처](#3-시스템-아키텍처)
4. [데이터 모델](#4-데이터-모델)
5. [핵심 서비스 클래스](#5-핵심-서비스-클래스)
6. [API 명세](#6-api-명세)
7. [보안 구현](#7-보안-구현)
8. [배포 아키텍처](#8-배포-아키텍처)

---

## 1. 기술 스택

### 1.1 Backend
- **Ruby**: 3.4.4
- **Rails**: 8.0.2
- **Database**: SQLite3 2.7.4
- **Background Jobs**: Solid Queue
- **WebSocket**: Solid Cable (실시간 진행 상태)
- **Caching**: Solid Cache

### 1.2 Frontend
- **CSS Framework**: Tailwind CSS 4
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **Module Bundler**: Importmap
- **Charts**: Chart.js (CDN)
- **Font**: Pretendard (CDN)

### 1.3 AI & External APIs
- **AI Model**: Gemini API (Google AI Studio)
- **HTTP Client**: HTTParty 또는 Faraday
- **PDF 변환**: Grover gem (Headless Chrome)
- **PPT 변환**: python-pptx (시스템 콜) 또는 스크린샷 기반

### 1.4 Infrastructure
- **Containerization**: Docker
- **Deployment**: Kamal
- **Hosting**: Digital Ocean Droplet
- **Web Server**: Puma
- **Proxy**: Kamal Proxy (Traefik 후속)
- **SSL**: Let's Encrypt (자동 발급)

### 1.5 Security
- **암호화**: attr_encrypted gem
- **Credentials**: Rails Encrypted Credentials
- **OAuth**: omniauth-google-oauth2 gem
- **환경 변수**: Kamal Secrets

---

## 2. 개발 환경 설정

### 2.1 로컬 설정

#### 필수 설치
```bash
# Ruby 버전 확인
ruby -v  # 3.4.4 필요

# 프로젝트 클론 및 의존성 설치
cd /path/to/RapiDeck
bundle install

# 데이터베이스 설정
bin/rails db:create
bin/rails db:migrate

# 개발 서버 실행 (Rails + Tailwind watch)
bin/dev
```

#### 환경 변수 설정
```bash
# config/master.key (자동 생성됨, Git 제외)
# 로컬에서는 기본값 사용

# .env.development (로컬 테스트용)
GEMINI_API_KEY=your_test_api_key_here
```

### 2.2 프로덕션 환경 설정

#### Kamal Secrets
`.kamal/secrets` 파일 생성:
```bash
KAMAL_REGISTRY_PASSWORD=$KAMAL_REGISTRY_PASSWORD
RAILS_MASTER_KEY=$(cat config/master.key)
```

#### 환경 변수 (Rails Credentials)
```bash
# config/credentials.yml.enc 편집
bin/rails credentials:edit

# 추가할 내용:
encryption_key: <32바이트 랜덤 키>
```

---

## 3. 시스템 아키텍처

### 3.1 전체 아키텍처 다이어그램

```
[사용자 브라우저]
    ↓ HTTPS
[Kamal Proxy]
    ├─ SSL 인증서 (Let's Encrypt)
    └─ 포트 포워딩 (80 → 443)
    ↓
[Rails 8 Application (Docker Container)]
    ├─ Puma Web Server
    ├─ Turbo/Stimulus (실시간 UI)
    ├─ Solid Queue (백그라운드 작업)
    ├─ Solid Cable (WebSocket)
    └─ Solid Cache (캐싱)
    ↓
[SQLite Database (Docker Volume)]
    ├─ storage/production.sqlite3 (메인 DB)
    ├─ storage/production_queue.sqlite3 (작업 큐)
    ├─ storage/production_cache.sqlite3 (캐시)
    └─ storage/production_cable.sqlite3 (WebSocket)

[External Services]
    ├─ Gemini API (Google AI Studio)
    ├─ Google OAuth (로그인)
    └─ Headless Chrome (Docker 내부, PDF 변환)
```

### 3.2 요청 흐름

#### 슬라이드 생성 플로우
```
1. [User] 문서 입력 + 채팅 메시지 전송
   ↓
2. [SlidesController#create]
   ↓ Turbo Stream 응답 (프로그레스 바 표시)
   ↓
3. [Solid Queue] GenerateSlideJob 실행
   ↓
4. [DocumentParser] 문서 분석 (30페이지 제한)
   ↓
5. [GeminiClient] API 호출
   - System Prompt (docs/SYSTEM_PROMPT.md)
   - User Prompt (문서 + 채팅 메시지)
   ↓
6. [Gemini API] HTML 코드 생성
   ↓
7. [SlideGenerator] HTML 저장 + 썸네일 생성
   ↓
8. [Solid Cable] WebSocket으로 완료 알림
   ↓
9. [User] 미리보기 페이지로 리다이렉트
```

#### PDF 변환 플로우
```
1. [User] PDF 다운로드 클릭
   ↓
2. [ConversionController#create]
   ↓ ConversionJob 모델 생성 (status: pending)
   ↓
3. [Solid Queue] ConvertToPdfJob 실행
   ↓
4. [Grover] Headless Chrome으로 HTML → PDF
   ↓
5. [ActiveStorage] PDF 파일 저장
   ↓
6. [Turbo Streams] 다운로드 링크 UI 업데이트
   ↓
7. [User] 다운로드
```

### 3.3 데이터베이스 아키텍처

#### SQLite 멀티 데이터베이스 전략
```yaml
# config/database.yml
production:
  primary:
    database: storage/production.sqlite3  # 메인 데이터
  cache:
    database: storage/production_cache.sqlite3  # Solid Cache
    migrations_paths: db/cache_migrate
  queue:
    database: storage/production_queue.sqlite3  # Solid Queue
    migrations_paths: db/queue_migrate
  cable:
    database: storage/production_cable.sqlite3  # Solid Cable
    migrations_paths: db/cable_migrate
```

---

## 4. 데이터 모델

### 4.1 User (사용자)

#### 스키마
```ruby
# db/migrate/xxxxx_create_users.rb
create_table :users do |t|
  t.string :email, null: false
  t.string :name
  t.string :password_digest  # has_secure_password

  # OAuth
  t.string :google_uid
  t.string :provider  # 'google' or 'password'

  # Gemini API Key (암호화)
  t.string :encrypted_gemini_api_key
  t.string :encrypted_gemini_api_key_iv

  t.timestamps
end

add_index :users, :email, unique: true
add_index :users, :google_uid, unique: true
```

#### 모델 코드
```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_secure_password validations: false

  # API 키 암호화
  attr_encrypted :gemini_api_key,
                 key: Rails.application.credentials.encryption_key

  # Associations
  has_many :slides, dependent: :destroy
  has_many :chat_sessions, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: :password_digest_changed?

  # OAuth 로그인
  def self.from_omniauth(auth)
    where(provider: auth.provider, google_uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
    end
  end
end
```

---

### 4.2 Slide (슬라이드)

#### 스키마
```ruby
# db/migrate/xxxxx_create_slides.rb
create_table :slides do |t|
  t.references :user, null: false, foreign_key: true
  t.string :title, null: false
  t.string :content_type  # lecture, report, proposal, newsletter
  t.text :html_code, null: false
  t.string :thumbnail_url
  t.boolean :pinned, default: false

  t.timestamps
end

add_index :slides, [:user_id, :created_at]
add_index :slides, [:user_id, :pinned]
```

#### 모델 코드
```ruby
# app/models/slide.rb
class Slide < ApplicationRecord
  belongs_to :user
  has_one :chat_session, dependent: :destroy
  has_many :conversion_jobs, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :html_code, presence: true
  validate :pin_limit, if: :pinned?
  validate :user_slide_limit, on: :create

  # Scopes
  scope :pinned, -> { where(pinned: true) }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  after_create :auto_delete_old_slides

  private

  def pin_limit
    if pinned && user.slides.pinned.where.not(id: id).count >= 4
      errors.add(:pinned, "최대 4개까지 Pin할 수 있습니다.")
    end
  end

  def user_slide_limit
    if user.slides.count >= 5
      errors.add(:base, "슬라이드는 최대 5개까지 저장할 수 있습니다.")
    end
  end

  def auto_delete_old_slides
    return if user.slides.count <= 5

    # Pin되지 않은 가장 오래된 슬라이드 삭제
    user.slides.where(pinned: false).order(created_at: :asc).first&.destroy
  end
end
```

---

### 4.3 ChatSession & ChatMessage

#### 스키마
```ruby
# db/migrate/xxxxx_create_chat_sessions.rb
create_table :chat_sessions do |t|
  t.references :user, null: false, foreign_key: true
  t.references :slide, foreign_key: true
  t.string :session_id, null: false
  t.text :context  # JSON 저장

  t.timestamps
end

add_index :chat_sessions, :session_id, unique: true

# db/migrate/xxxxx_create_chat_messages.rb
create_table :chat_messages do |t|
  t.references :chat_session, null: false, foreign_key: true
  t.string :role, null: false  # 'user' or 'assistant'
  t.text :content, null: false

  t.timestamps
end

add_index :chat_messages, [:chat_session_id, :created_at]
```

#### 모델 코드
```ruby
# app/models/chat_session.rb
class ChatSession < ApplicationRecord
  belongs_to :user
  belongs_to :slide, optional: true
  has_many :chat_messages, dependent: :destroy

  before_create :generate_session_id

  private

  def generate_session_id
    self.session_id ||= SecureRandom.uuid
  end
end

# app/models/chat_message.rb
class ChatMessage < ApplicationRecord
  belongs_to :chat_session

  validates :role, inclusion: { in: %w[user assistant] }
  validates :content, presence: true
end
```

---

### 4.4 ConversionJob

#### 스키마
```ruby
# db/migrate/xxxxx_create_conversion_jobs.rb
create_table :conversion_jobs do |t|
  t.references :slide, null: false, foreign_key: true
  t.string :format, null: false  # 'pdf' or 'ppt'
  t.string :status, default: 'pending'  # pending, processing, completed, failed
  t.string :file_url
  t.text :error_message

  t.timestamps
end

add_index :conversion_jobs, [:slide_id, :format]
add_index :conversion_jobs, :status
```

#### 모델 코드
```ruby
# app/models/conversion_job.rb
class ConversionJob < ApplicationRecord
  belongs_to :slide

  validates :format, inclusion: { in: %w[pdf ppt] }
  validates :status, inclusion: { in: %w[pending processing completed failed] }

  # ActiveStorage 파일 첨부
  has_one_attached :file

  def complete!(file_path)
    self.file.attach(io: File.open(file_path), filename: "#{slide.title}.#{format}")
    update!(status: 'completed', file_url: file.url)
  end

  def fail!(error)
    update!(status: 'failed', error_message: error.message)
  end
end
```

---

## 5. 핵심 서비스 클래스

### 5.1 DocumentParser

```ruby
# app/services/document_parser.rb
class DocumentParser
  MAX_PAGES = 30
  CHARS_PER_PAGE = 500  # 대략적인 기준

  def initialize(document_text)
    @document_text = document_text
  end

  def parse
    {
      content: truncated_content,
      page_count: estimated_page_count,
      truncated: truncated?
    }
  end

  private

  def truncated_content
    max_chars = MAX_PAGES * CHARS_PER_PAGE
    @document_text[0...max_chars]
  end

  def estimated_page_count
    (@document_text.length / CHARS_PER_PAGE.to_f).ceil
  end

  def truncated?
    estimated_page_count > MAX_PAGES
  end
end
```

---

### 5.2 GeminiClient

```ruby
# app/services/gemini_client.rb
require 'httparty'

class GeminiClient
  include HTTParty
  base_uri 'https://generativelanguage.googleapis.com'

  def initialize(api_key)
    @api_key = api_key
  end

  def generate_slide(user_prompt)
    response = self.class.post(
      "/v1beta/models/gemini-pro:generateContent?key=#{@api_key}",
      headers: { 'Content-Type' => 'application/json' },
      body: {
        contents: [
          {
            parts: [
              { text: system_prompt },
              { text: user_prompt }
            ]
          }
        ]
      }.to_json
    )

    if response.success?
      extract_html(response.parsed_response)
    else
      raise GeminiApiError, response.body
    end
  end

  private

  def system_prompt
    @system_prompt ||= File.read(
      Rails.root.join('docs', 'SYSTEM_PROMPT.md')
    )
  end

  def extract_html(response_data)
    # Gemini 응답에서 HTML 코드 추출
    response_data.dig('candidates', 0, 'content', 'parts', 0, 'text')
  end
end

class GeminiApiError < StandardError; end
```

---

### 5.3 SlideGenerator

```ruby
# app/services/slide_generator.rb
class SlideGenerator
  def initialize(user:, html_code:, title:, content_type:)
    @user = user
    @html_code = html_code
    @title = title
    @content_type = content_type
  end

  def generate
    slide = @user.slides.create!(
      title: @title,
      content_type: @content_type,
      html_code: @html_code
    )

    generate_thumbnail(slide)
    slide
  end

  private

  def generate_thumbnail(slide)
    # Grover로 첫 슬라이드 스크린샷 생성
    # 추후 구현
  end
end
```

---

### 5.4 ConversionService

```ruby
# app/services/conversion_service.rb
class ConversionService
  def initialize(slide)
    @slide = slide
  end

  def to_pdf
    require 'grover'

    pdf = Grover.new(@slide.html_code).to_pdf
    temp_file = Tempfile.new(['slide', '.pdf'])
    temp_file.binmode
    temp_file.write(pdf)
    temp_file.close

    temp_file.path
  end

  def to_ppt
    # python-pptx 시스템 콜 또는 스크린샷 기반
    # 추후 구현
    raise NotImplementedError
  end
end
```

---

## 6. API 명세

### 6.1 Gemini API 호출

#### Endpoint
```
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent
```

#### Headers
```json
{
  "Content-Type": "application/json"
}
```

#### Request Body
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "<SYSTEM_PROMPT.md 전체 내용>"
        },
        {
          "text": "<사용자 문서 + 채팅 메시지>"
        }
      ]
    }
  ]
}
```

#### Response
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "<!DOCTYPE html>\n<html>...</html>"
          }
        ]
      }
    }
  ]
}
```

#### 에러 핸들링
```ruby
begin
  html = gemini_client.generate_slide(user_prompt)
rescue GeminiApiError => e
  # 사용자에게 명확한 메시지 표시
  flash[:error] = "슬라이드 생성 실패: #{e.message}"
end
```

---

## 7. 보안 구현

### 7.1 attr_encrypted 사용법

#### Gemfile
```ruby
gem 'attr_encrypted'
```

#### 암호화 키 생성
```bash
# Rails Credentials에 추가
bin/rails credentials:edit

# 추가할 내용:
encryption_key: <32바이트 랜덤 키>
```

#### User 모델 적용
```ruby
class User < ApplicationRecord
  attr_encrypted :gemini_api_key,
                 key: Rails.application.credentials.encryption_key,
                 algorithm: 'aes-256-gcm'
end
```

#### 사용 예시
```ruby
# 암호화 저장
user.gemini_api_key = "AIzaSy..."
user.save

# 복호화 읽기 (자동)
api_key = user.gemini_api_key  # "AIzaSy..."

# DB에는 암호화된 값 저장
user.encrypted_gemini_api_key  # "랜덤 암호화 문자열"
```

---

### 7.2 OAuth 구현 (Google)

#### Gemfile
```ruby
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
```

#### 설정
```ruby
# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google[:client_id],
           Rails.application.credentials.google[:client_secret],
           {
             scope: 'email,profile',
             prompt: 'select_account'
           }
end
```

#### 라우트
```ruby
# config/routes.rb
get '/auth/google_oauth2/callback', to: 'sessions#create'
```

#### 컨트롤러
```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to dashboard_path
  end
end
```

---

### 7.3 HTTPS 설정 (Kamal Proxy)

#### config/deploy.yml
```yaml
proxy:
  ssl: true
  host: rapideck.com

# Let's Encrypt 자동 인증
# Kamal Proxy가 자동으로 처리
```

---

## 8. 배포 아키텍처

### 8.1 Docker 구성

#### Dockerfile
```dockerfile
# 기본 Rails 8 Dockerfile 사용
FROM ruby:3.4.4-alpine

# Grover 의존성 (Puppeteer/Chrome)
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver

ENV CHROME_BIN=/usr/bin/chromium-browser

WORKDIR /rails
COPY . .

RUN bundle install
RUN bin/rails assets:precompile

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
```

---

### 8.2 Kamal 배포

#### config/deploy.yml
```yaml
service: rapideck
image: yourusername/rapideck

servers:
  web:
    - YOUR_DROPLET_IP

proxy:
  ssl: true
  host: rapideck.com

volumes:
  - "rapideck_storage:/rails/storage"

builder:
  arch: amd64
```

#### 배포 명령어
```bash
# 초기 배포
kamal server bootstrap
kamal setup
kamal deploy

# 업데이트 배포
kamal deploy

# 롤백
kamal rollback

# 로그 확인
kamal app logs
```

---

### 8.3 SQLite 백업 전략

#### 자동 백업 스크립트
```bash
# Digital Ocean Volume에 백업
0 2 * * * docker exec rapideck-web sqlite3 /rails/storage/production.sqlite3 ".backup /rails/storage/backups/$(date +\%Y\%m\%d).sqlite3"
```

#### 복구 방법
```bash
# 백업 파일 복사
docker cp backup.sqlite3 rapideck-web:/rails/storage/production.sqlite3

# 재시작
kamal app restart
```

---

## 부록

### A. 참조 문서
- [PRD.md](./PRD.md): 제품 요구사항
- [DESIGN_GUIDELINES.md](./DESIGN_GUIDELINES.md): 디자인 가이드라인
- [SYSTEM_PROMPT.md](./SYSTEM_PROMPT.md): Gemini 시스템 프롬프트
- [PLAN.md](./PLAN.md): 개발 로드맵
- [DEPLOYMENT.md](../DEPLOYMENT.md): 배포 상세 가이드

### B. 외부 레퍼런스
- [Rails 8 공식 문서](https://guides.rubyonrails.org/)
- [Gemini API 문서](https://ai.google.dev/docs)
- [attr_encrypted GitHub](https://github.com/attr-encrypted/attr_encrypted)
- [Kamal 문서](https://kamal-deploy.org/)
- [Grover GitHub](https://github.com/Studiosity/grover)

---

**작성자**: Claude
**최종 업데이트**: 2025-10-02
**버전**: 1.0.0
