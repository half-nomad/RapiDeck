# Claude 작업 지침서

> RapiDeck 프로젝트 작업 시 필수 참고 문서

---

## 📌 필수 참고 문서

1. **[docs/PRD.md](docs/PRD.md)** - 제품 요구사항 (무엇을, 왜)
2. **[docs/TRD.md](docs/TRD.md)** - 기술 요구사항 (어떻게 구현)
3. **[docs/DESIGN_GUIDELINES.md](docs/DESIGN_GUIDELINES.md)** - 디자인 규칙 (엄격 준수)
4. **[docs/SYSTEM_PROMPT.md](docs/SYSTEM_PROMPT.md)** - Gemini 프롬프트
5. **[docs/PLAN.md](docs/PLAN.md)** - 개발 로드맵 & 체크리스트

---

## 🤖 Agent 호출 시 필수

**Agent는 CLAUDE.md를 자동으로 읽지 못하므로 프롬프트에 명시:**

```
**[필수 참고 문서]**
1. docs/TRD.md - 기술 스택, 시스템 아키텍처
2. docs/PRD.md - 제품 요구사항
3. docs/DESIGN_GUIDELINES.md - (UI 작업 시 필수)
4. docs/SYSTEM_PROMPT.md - (Gemini 연동 시 필수)

**[작업 내용]**
[구체적 지시사항]

**[제약 사항]**
- 디자인 가이드라인 엄격 준수
- PRD 범위 내에서만 작업
- 불명확한 부분은 즉시 질문
```

---

## 🚨 절대 규칙

### 1. 디자인 가이드라인 엄격 준수
- **변경 금지**: 색상, 폰트, 슬라이드 크기 절대 변경 불가
- **확인 필수**: 새로운 UI 추가 시 `docs/DESIGN_GUIDELINES.md` 확인
- **질문 필수**: 가이드라인과 충돌 시 사용자에게 먼저 질문

### 2. PRD 기준 준수
- 모든 기능은 `docs/PRD.md`에 명시된 범위 내에서 개발
- PRD에 없는 기능 추가 시 **반드시 사용자 승인** 필수
- 불명확한 요구사항은 **가정하지 말고 질문**

### 3. 작업 전 체크리스트 확인
- `docs/PLAN.md`의 해당 주차 체크리스트 확인
- 완료 여부 업데이트 필수
- 블로커 발견 시 즉시 보고

---

## 📂 프로젝트 구조

```
RapiDeck/
├── app/services/          # 비즈니스 로직
├── app/components/        # ViewComponent
├── docs/                  # 모든 문서
└── CLAUDE.md              # 본 문서
```

---

## ⚡ 빠른 참조

| 작업 | 참조 문서 | 섹션 |
|------|-----------|------|
| 새 기능 추가 | PRD.md | 4. 핵심 기능 |
| 기술 구현 | TRD.md | 5. 서비스 클래스 |
| 데이터 모델 | TRD.md | 4. 데이터 모델 |
| UI 디자인 | DESIGN_GUIDELINES.md | 전체 |
| Gemini 연동 | SYSTEM_PROMPT.md | 전체 |
| 일정 확인 | PLAN.md | 해당 Week |
| 배포 | DEPLOYMENT.md | 전체 |

---

**최종 업데이트**: 2025-10-02
