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


![recipe_recommend](https://github.com/awaaaake/Hansang/assets/103404308/30576508-655d-4678-b046-83f488834f27)




### 로그인 및 회원가입
계정 로그인/생성

<p float="left">
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/b80ee262-8bbd-4ab1-aa69-5b8d85bcca56" alt="start" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/5509761b-4fe7-4b40-bf8b-8e7526e3f814" alt="login" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/73b5b464-a6ab-4f73-b958-825315fb4f57" alt="signup" width="200"/>
</p>

### 레시피 검색
레시피 검색 기능

<p float="left">
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/87917253-8c89-4f73-9b37-5ff06040ec6f" alt="recipe1" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/24f18fa3-7866-428f-a6bb-98f32562bae4" alt="recipe2" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/8f698772-e3f8-4506-8d62-1b5a82b87a41" alt="recipe3" width="200"/>
</p>

### 맞춤 레시피
맞춤형 레시피 추천

<p float="left">
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/30576508-655d-4678-b046-83f488834f27" alt="recipe_recommend" width="200"/>
</p>

### 식자재 기반 및 협업 필터링 사용자 맞춤 레시피 추천
식자재 및 리뷰 기반 레시피 추천

<p float="left">
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/272a1da3-be71-4ee9-83cd-06484d28a10d" alt="recommend1" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/9de888e3-e960-4b57-9c61-f168d77cb459" alt="recommend2" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/33e433d7-6403-4da0-8899-76acdf125cec" alt="user" width="200"/>
</p>

### 식자재 인식 맞춤 레시피 추천
식자재 인식 기반 레시피 추천

<p float="left">
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/0b8cd654-22f5-4ef4-a329-2b223fc3a641" alt="ingredient1" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/ac4f6f75-da92-4342-995a-8e35ffd82759" alt="ingredient2" width="200"/>
</p>

### 사용자 게시판
사용자 게시판

<p float="left">
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/f30c47ef-ac06-4822-908d-aff1c38fc32a" alt="user1" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/145231b2-0b66-4f17-8111-5583b41bf878" alt="user2" width="200"/>
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/80348593-8db0-4b55-9822-cfc896794665" alt="user3" width="200"/>
</p>

### 리뷰
레시피 리뷰 작성 및 조회

<p float="left">
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/5942bc12-5d3a-4daa-b521-cb97dc26dac9" alt="review" width="200"/>
</p>

### 마이페이지
프로필 및 개인 설정 관리

<p float="left">
  <img src="https://github.com/awaaaake/Hansang/assets/103404308/0c36cb9b-94e6-4c5f-a2cf-ffb28f7bb87b" alt="mypage" width="200"/>
</p>

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
