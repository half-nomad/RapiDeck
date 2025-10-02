# RapiDeck 디자인 시스템 가이드라인

> **⚠️ 엄격 준수 필수**: 이 문서의 모든 스타일 규칙은 Gemini가 슬라이드 생성 시 절대적으로 따라야 합니다.

---

## 1. 슬라이드 기본 규격

### 크기 (고정)
```css
width: 960px;
height: 540px;
aspect-ratio: 16:9;
```

### 기본 구조
```html
<div class="slide">
  <header>...</header>
  <main>...</main>
</div>
```

---

## 2. 색상 팔레트 (Color Palette)

### 배경 색상
| 용도 | HEX | Tailwind | 사용 위치 |
|------|-----|----------|-----------|
| 전체 페이지 배경 | `#1e1e1e` | `bg-[#1e1e1e]` | `<body>` |
| 슬라이드 배경 | `#191919` | `bg-[#191919]` | `.slide` |
| 카드 배경 | `#2d2d2d` (50% 투명) | `bg-[#2d2d2d]/50` | `.card` |
| 플로우 박스 배경 | `#1e1e1e` | `bg-[#1e1e1e]` | `.flow-box` |

### 텍스트 색상
| 용도 | HEX | Tailwind |
|------|-----|----------|
| 주요 텍스트 | `#E0E0E0` | `text-[#E0E0E0]` |
| 제목 (강조) | `#FFFFFF` | `text-white` |
| 보조 텍스트 | `#9CA3AF` | `text-gray-400` |
| 플로우 화살표 | `#6b7280` | `text-gray-500` |

### 테두리 색상
| 용도 | HEX | Tailwind |
|------|-----|----------|
| 기본 테두리 | `#4a4a4a` | `border-[#4a4a4a]` |

### 하이라이트 색상 (의미별 사용)
| 용도 | HEX | Tailwind | 사용 맥락 |
|------|-----|----------|-----------|
| Cyan | `#22D3EE` | `text-[#22D3EE]` | AI/MCP/기술/혁신 |
| Pink/Red | `#F472B6` | `text-[#F472B6]` | 문제/제한/주의 |
| Yellow | `#FBBF24` | `text-[#FBBF24]` | 자동화 도구/워크플로우 |
| Green | `#34D399` | `text-[#34D399]` | 하이브리드/성공/완료 |

---

## 3. 타이포그래피 (Typography)

### 폰트 패밀리
```css
font-family: 'Pretendard', sans-serif;
```

**CDN 로드 (필수)**:
```html
<link rel="stylesheet" as="style" crossorigin
  href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
```

### 텍스트 크기 및 용도

| 용도 | Tailwind 클래스 | 크기 | Font Weight |
|------|----------------|------|-------------|
| 메인 타이틀 (슬라이드 1) | `text-6xl` | 3.75rem (60px) | `font-extrabold` |
| 슬라이드 제목 | `text-3xl` | 1.875rem (30px) | `font-bold` |
| 슬라이드 부제목 | `text-2xl` | 1.5rem (24px) | `font-bold` |
| 소제목 | `text-xl` | 1.25rem (20px) | `font-bold` |
| 보조 설명 (헤더) | `text-lg` | 1.125rem (18px) | `font-normal` |
| 본문 텍스트 | `text-base` | 1rem (16px) | `font-normal` |
| 작은 텍스트 | `text-sm` | 0.875rem (14px) | `font-normal` |
| 아주 작은 텍스트 | `text-xs` | 0.75rem (12px) | `font-normal` |

---

## 4. 컴포넌트 라이브러리

### 4.1 Slide (슬라이드)
```css
.slide {
  width: 960px;
  height: 540px;
  background-color: #191919;
  color: #E0E0E0;
  display: flex;
  flex-direction: column;
  padding: 2.5rem 4rem; /* 40px 64px */
  border-radius: 0.5rem;
  box-shadow: 0 10px 30px rgba(0,0,0,0.5);
  margin-bottom: 2rem;
}
```

**Tailwind 버전**:
```html
<div class="slide w-[960px] h-[540px] bg-[#191919] text-[#E0E0E0]
     flex flex-col p-10 px-16 rounded-lg shadow-2xl mb-8">
  <!-- 슬라이드 내용 -->
</div>
```

### 4.2 Card (카드)
```css
.card {
  background-color: #2d2d2d/50;
  border: 1px solid #4a4a4a;
  border-radius: 0.75rem;
  padding: 1.5rem;
}
```

**Tailwind 버전**:
```html
<div class="card bg-[#2d2d2d]/50 border border-[#4a4a4a] rounded-xl p-6">
  <!-- 카드 내용 -->
</div>
```

### 4.3 Flow Box (플로우 박스)
```css
.flow-box {
  background-color: #1e1e1e;
  border: 1px solid #4a4a4a;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  text-align: center;
}
```

**Tailwind 버전**:
```html
<div class="flow-box bg-[#1e1e1e] border border-[#4a4a4a]
     px-4 py-2 rounded-lg text-center">
  텍스트
</div>
```

### 4.4 Flow Arrow (플로우 화살표)
```css
.flow-arrow {
  color: #6b7280;
  font-size: 1.8rem;
  font-weight: bold;
}
```

**Tailwind 버전**:
```html
<div class="flow-arrow text-gray-500 text-3xl font-bold">↓</div>
```

### 4.5 Chart Container (차트 컨테이너)
```css
.chart-container {
  position: relative;
  width: 100%;
  height: 220px;
}
```

**Tailwind 버전**:
```html
<div class="chart-container relative w-full h-[220px]">
  <canvas id="chartId"></canvas>
</div>
```

---

## 5. 레이아웃 패턴

### 5.1 슬라이드 헤더
```html
<header class="text-center mb-6">
  <h2 class="text-3xl font-bold text-white">슬라이드 제목</h2>
  <p class="text-lg text-gray-400 mt-1">부제목 또는 설명</p>
</header>
```

### 5.2 2단 레이아웃
```html
<main class="grid grid-cols-2 gap-8 items-center flex-grow">
  <div class="card">왼쪽 내용</div>
  <div class="space-y-4">오른쪽 내용</div>
</main>
```

### 5.3 3단 레이아웃
```html
<main class="grid grid-cols-3 gap-6 flex-grow">
  <div class="card">카드 1</div>
  <div class="card">카드 2</div>
  <div class="card">카드 3</div>
</main>
```

### 5.4 타이틀 슬라이드
```html
<div class="slide justify-center text-center">
  <h1 class="text-6xl font-extrabold text-white">메인 타이틀</h1>
  <p class="text-2xl text-gray-400 mt-4">부제목</p>
</div>
```

### 5.5 리스트 스타일
```html
<ul class="list-disc list-inside space-y-2 text-gray-400 text-sm">
  <li><span class="font-bold text-gray-200">강조 제목:</span> 설명 내용</li>
  <li><span class="font-bold text-gray-200">강조 제목:</span> 설명 내용</li>
</ul>
```

---

## 6. Chart.js 스타일 가이드

### 기본 차트 옵션
```javascript
const chartDefaultOptions = {
  responsive: true,
  maintainAspectRatio: false,
  scales: {
    y: {
      beginAtZero: true,
      ticks: { color: '#9CA3AF', font: { size: 10 } },
      grid: { color: '#4a4a4a' }
    },
    x: {
      ticks: { color: '#9CA3AF', font: { size: 10 } },
      grid: { color: 'transparent' }
    }
  },
  plugins: {
    legend: { labels: { color: '#E0E0E0', font: { size: 12 } } }
  }
};
```

### 차트 색상 팔레트
- **라인 1**: `#22D3EE` (Cyan)
- **라인 2**: `#F472B6` (Pink)
- **라인 3**: `#FBBF24` (Yellow)
- **라인 4**: `#34D399` (Green)

---

## 7. 필수 CDN 의존성

### HTML Head 섹션에 반드시 포함
```html
<!-- Tailwind CSS -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Pretendard Font -->
<link rel="stylesheet" as="style" crossorigin
  href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
```

---

## 8. 전체 슬라이드 템플릿 구조

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>슬라이드 제목</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <link rel="stylesheet" as="style" crossorigin
    href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
  <style>
    body { font-family: 'Pretendard', sans-serif; background-color: #1e1e1e; }
    .slide { /* 위 스타일 참고 */ }
    .card { /* 위 스타일 참고 */ }
    .flow-box { /* 위 스타일 참고 */ }
    .flow-arrow { /* 위 스타일 참고 */ }
    .chart-container { /* 위 스타일 참고 */ }
    .highlight-cyan { color: #22D3EE; }
    .highlight-red { color: #F472B6; }
    .highlight-yellow { color: #FBBF24; }
    .highlight-green { color: #34D399; }
  </style>
</head>
<body class="flex flex-col items-center justify-center py-8">

  <!-- 슬라이드들 -->
  <div class="slide">...</div>
  <div class="slide">...</div>

  <!-- Chart.js 스크립트 (필요 시) -->
  <script>
    // 차트 초기화 코드
  </script>

</body>
</html>
```

---

## 9. 콘텐츠 타입별 레이아웃 가이드

### 9.1 강의안 (교육용)
- **타이틀 슬라이드**: 제목 + 부제목 중앙 정렬
- **이론 슬라이드**: 2단 레이아웃 (다이어그램 + 설명)
- **실습 슬라이드**: 카드 + 단계별 리스트
- **요약 슬라이드**: 3단 카드 레이아웃

### 9.2 보고서 (인포그래픽)
- **타이틀 슬라이드**: 제목 + 날짜/작성자
- **핵심 지표**: 3~4개 카드 그리드
- **데이터 시각화**: 차트 + 인사이트 텍스트
- **결론**: 2단 레이아웃 (결과 + 제안)

### 9.3 제안서
- **타이틀 슬라이드**: 제목 + 부제목
- **문제 정의**: 현황 분석 (차트/리스트)
- **솔루션**: 플로우 다이어그램 + 설명
- **기대효과**: 카드 레이아웃 (정량적 + 정성적)

### 9.4 뉴스레터
- **헤드라인**: 큰 제목 + 요약
- **주요 콘텐츠**: 카드형 레이아웃 (이미지 영역 + 텍스트)
- **추가 정보**: 리스트 또는 작은 카드
- **CTA**: 강조 박스 + 버튼 스타일 텍스트

---

## 10. 금지 사항

### ❌ 절대 하지 말아야 할 것
1. **색상 변경 금지**: 팔레트에 없는 색상 사용 불가
2. **폰트 변경 금지**: Pretendard 이외의 폰트 사용 불가
3. **슬라이드 크기 변경 금지**: 960×540px 고정
4. **CDN 변경 금지**: Tailwind, Chart.js, Pretendard CDN 링크 유지
5. **클래스 임의 생성 금지**: 정의된 `.slide`, `.card`, `.flow-box` 외 커스텀 클래스 생성 불가

### ⚠️ 주의 사항
- 모든 색상은 정확한 HEX 코드 사용
- Tailwind 클래스 사용 시 `bg-[#191919]` 형태로 명시
- 간격(padding, margin)은 Tailwind 기본 단위 사용 (`p-6`, `mb-4` 등)
- 반응형 미지원 (데스크톱 고정 크기)

---

**최종 업데이트**: 2025-10-02
**버전**: 1.0.0 (Beta)
