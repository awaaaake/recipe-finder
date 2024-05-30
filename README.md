# 한상🍽️ : 한국인의 밥상

**한상** 애플리케이션은 사용자 맞춤형 레시피를 제공하는 앱으로, 식자재 인식 및 다양한 필터링을 통해 사용자에게 최적화된 레시피를 추천합니다. 

## 개발 기간
- 2023년 9월 ~ 2023년 11월

## 개발팀
- 팀 이름: 졸업시켜조
- 팀 멤버: 민정윤, 양유정, 이호욱, 조윤희 (부경대학교 컴퓨터공학과 4학년)

## 수상 내역
- 2023 컴퓨터·인공지능공학부 캡스톤디자인 경진대회 장려상 수상

## 주요 기능

| 화면 | 설명 | 이미지 |
|------|------|--------|
| 로그인 및 회원가입 | 계정 로그인/생성 |![로그인 및 회원가입]![start](https://github.com/awaaaake/Hansang/assets/103404308/9428e976-a97c-4142-bb86-258448122c9a)![login](https://githu![signup](https://github.com/awaaaake/Hansang/assets/103404308/c601fec4-3059-4b93-bce3-32585014b279)
b.com/awaaaake/Hansang/assets/103404308/54bb9c7c-5723-4875-bcb1-cfb3f0e006d0)

|
| 레시피 검색 | 레시피 검색 기능 | ![레시피 검색](images/recipe_search_screen.png) |
| 맞춤 레시피 | 맞춤형 레시피 추천 | ![맞춤 레시피](images/custom_recipe_screen.png) |
| 식자재 기반 및 협업 필터링 사용자 맞춤 레시피 추천 | 식자재 및 리뷰 기반 레시피 추천 | ![식자재 기반 레시피 추천](images/ingredient_based_recommendation_screen.png) |
| 식자재 인식 맞춤 레시피 추천 | 식자재 인식 기반 레시피 추천 | ![식자재 인식 레시피 추천](images/ingredient_recognition_screen.png) |
| 사용자 게시판 | 사용자 게시판 | ![사용자 게시판](images/user_board_screen.png) |
| 리뷰 | 레시피 리뷰 작성 및 조회 | ![리뷰](images/review_screen.png) |
| 마이페이지 | 프로필 및 개인 설정 관리 | ![마이페이지](images/mypage_screen.png) |

## 개발 환경 및 시스템 구성

- **플랫폼**: Flutter
- **백엔드**: Spring Boot, Flask
- **프로그래밍 언어**: Python
- **모델**: TensorFlow Lite
- **데이터 출처**: 식품의약품안전처 제공

## 구현 기술

### 1. 식자재와 알러지 성분을 입력받아 TF-IDF를 활용한 레시피 추천
사용자가 입력한 식자재 및 알러지 성분을 바탕으로 TF-IDF 알고리즘을 사용해 맞춤형 레시피를 추천합니다.

### 2. 협업 필터링을 통한 리뷰 평점 기반 레시피 추천
사용자 리뷰 평점을 기반으로 협업 필터링 알고리즘을 사용해 레시피를 추천합니다.

### 식자재 인식
- **모델**: TensorFlow Lite
- **도구**: Google의 Teachable Machine을 사용해 식자재 인식 모델을 학습

### 디렉토리 설계
```
📦lib
 ┣ 📂login
 ┃ ┣ 📜kakao_login.dart
 ┃ ┣ 📜login.dart
 ┃ ┣ 📜main_view_model..dart
 ┃ ┗ 📜start.dart
 ┣ 📂object_detection
 ┃ ┣ 📂servieces
 ┃ ┃ ┣ 📜CameraSettings.dart
 ┃ ┃ ┣ 📜Classifier.dart
 ┃ ┃ ┗ 📜Recognition.dart
 ┃ ┣ 📂utils
 ┃ ┃ ┗ 📜IsolateUtils.dart
 ┃ ┣ 📂views
 ┃ ┃ ┣ 📜BoxWidget.dart
 ┃ ┃ ┗ 📜HomeScreen.dart
 ┃ ┣ 📜CameraView.dart
 ┃ ┗ 📜ImageUtils.dart
 ┣ 📂provider
 ┃ ┣ 📜user_bookmarkedRecipes.dart
 ┃ ┗ 📜user_preferences_provider.dart
 ┣ 📂Recipe
 ┃ ┣ 📜HttpRequests.dart
 ┃ ┣ 📜RecipeDetailPage.dart
 ┃ ┗ 📜RecipePage.dart
 ┣ 📂review
 ┃ ┗ 📜review.dart
 ┣ 📂signup
 ┃ ┣ 📜additional_info.dart
 ┃ ┗ 📜signup.dart
 ┣ 📂tab
 ┃ ┣ 📜Ingredient_scanner.dart
 ┃ ┣ 📜menu.dart
 ┃ ┣ 📜mypage.dart
 ┃ ┗ 📜search.dart
 ┣ 📂user_setting
 ┃ ┣ 📜step1.dart
 ┃ ┗ 📜step2.dart
 ┣ 📜home.dart
 ┣ 📜main.dart
 ┗ 📜style.dart
```
