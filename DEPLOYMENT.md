# RapiDeck 배포 가이드 (Digital Ocean + Kamal)

## 사전 요구사항

### 1. Digital Ocean 계정 설정
- [Digital Ocean 계정 생성](https://www.digitalocean.com/)
- Personal Access Token 생성 (Settings > API > Generate New Token)
- Container Registry 생성 (optional, Docker Hub 사용 가능)

### 2. Droplet 생성
```bash
# 최소 사양 권장
- CPU: 1 vCPU
- RAM: 1 GB
- Storage: 25 GB
- OS: Ubuntu 22.04 LTS
```

### 3. 로컬 환경 설정
```bash
# SSH 키 등록
ssh-copy-id root@YOUR_DROPLET_IP

# Docker 설치 확인
docker --version

# Kamal 설치 확인 (Rails 8에 포함됨)
bundle exec kamal version
```

## 배포 설정

### 1. config/deploy.yml 수정
```yaml
# 필수 수정 항목
service: rapideck
image: your-docker-username/rapideck
servers:
  web:
    - YOUR_DROPLET_IP  # Digital Ocean Droplet IP로 교체
proxy:
  host: rapideck.example.com  # 실제 도메인으로 교체

# Docker Hub 사용 시
registry:
  username: your-docker-username
  password:
    - KAMAL_REGISTRY_PASSWORD

# Digital Ocean Container Registry 사용 시
registry:
  server: registry.digitalocean.com
  username: your-docker-username
  password:
    - KAMAL_REGISTRY_PASSWORD
```

### 2. 환경 변수 설정
```bash
# Docker Registry 인증 정보 (Docker Hub 또는 Digital Ocean)
export KAMAL_REGISTRY_PASSWORD="your_token_or_password"

# 확인
echo $KAMAL_REGISTRY_PASSWORD
```

### 3. Rails Master Key 확인
```bash
# config/master.key 파일이 존재하는지 확인
cat config/master.key

# 없다면 생성
bin/rails credentials:edit
```

## 배포 프로세스

### 초기 배포

```bash
# 1. 서버에 Docker 설치 (자동)
kamal server bootstrap

# 2. 전체 설정 및 배포
kamal setup

# 3. 애플리케이션 배포
kamal deploy
```

### 업데이트 배포

```bash
# 코드 변경 후 재배포
kamal deploy

# 특정 버전 배포
kamal deploy --version=v1.0.0
```

## 배포 후 관리

### 애플리케이션 상태 확인
```bash
# 컨테이너 상태 확인
kamal app details

# 로그 확인
kamal app logs
kamal app logs -f  # 실시간 로그

# 콘솔 접속
kamal app exec --interactive --reuse "bin/rails console"

# 서버 접속
kamal app exec --interactive --reuse "bash"
```

### 데이터베이스 관리
```bash
# 마이그레이션 실행
kamal app exec "bin/rails db:migrate"

# 데이터베이스 콘솔
kamal app exec --interactive --reuse "bin/rails dbconsole"

# 시드 데이터 로드
kamal app exec "bin/rails db:seed"
```

### 롤백
```bash
# 이전 버전으로 롤백
kamal rollback
```

## SQLite 데이터베이스 백업

⚠️ **중요**: SQLite는 파일 기반 데이터베이스이므로 정기적인 백업이 필수입니다.

### 수동 백업
```bash
# 서버에서 데이터베이스 파일 다운로드
scp root@YOUR_DROPLET_IP:/var/lib/docker/volumes/rapideck_storage/_data/*.sqlite3 ./backups/

# Docker 볼륨 백업
kamal app exec "tar -czf /tmp/db_backup.tar.gz /rails/storage/*.sqlite3"
scp root@YOUR_DROPLET_IP:/tmp/db_backup.tar.gz ./backups/
```

### 자동 백업 (추천)
Digital Ocean Droplet Backups 활성화:
1. Droplet 설정에서 "Enable Backups" 선택
2. 주간 자동 스냅샷 생성

또는 Digital Ocean Volumes 사용:
```yaml
# config/deploy.yml에 추가
volumes:
  - "/mnt/rapideck_volume:/rails/storage"
```

## SSL/TLS 인증서 (Let's Encrypt)

Kamal은 자동으로 Let's Encrypt 인증서를 발급합니다:

```yaml
# config/deploy.yml
proxy:
  ssl: true
  host: rapideck.yourdomain.com
```

**요구사항**:
- 도메인이 Droplet IP를 가리켜야 함
- 포트 80, 443 오픈 필요

## 트러블슈팅

### Docker 권한 오류
```bash
# 서버에서 실행
sudo usermod -aG docker $USER
```

### 배포 실패 시
```bash
# 상세 로그 확인
kamal deploy --verbose

# 컨테이너 재시작
kamal app restart
```

### 데이터베이스 연결 오류
```bash
# 볼륨 마운트 확인
kamal app details

# 데이터베이스 권한 확인
kamal app exec "ls -la /rails/storage"
```

## 성능 최적화

### 1. WEB_CONCURRENCY 설정
```yaml
# config/deploy.yml
env:
  clear:
    WEB_CONCURRENCY: 2  # CPU 코어 수에 맞춰 조정
```

### 2. Solid Queue 분리
트래픽 증가 시 별도 서버로 분리:
```yaml
servers:
  web:
    - DROPLET_IP_1
  job:
    hosts:
      - DROPLET_IP_2
    cmd: bin/jobs
```

## 비용 절감 팁

1. **Droplet 사이즈**: 초기에는 $6/월 Basic Droplet으로 시작
2. **Container Registry**: 초기에는 Docker Hub 무료 플랜 사용
3. **Backups**: Snapshot 대신 볼륨 백업 스크립트 활용
4. **모니터링**: Digital Ocean 기본 모니터링 활용 (무료)

## 다음 단계

- [ ] 도메인 연결 및 DNS 설정
- [ ] 모니터링 설정 (Digital Ocean Monitoring)
- [ ] 정기 백업 자동화
- [ ] CI/CD 파이프라인 구축 (GitHub Actions)
- [ ] 로드 밸런서 추가 (트래픽 증가 시)
