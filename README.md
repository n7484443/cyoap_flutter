# CYOA Player
<img src="https://img.shields.io/github/v/release/n7484443/FlutterCyoap"></img>
[![pages-build-deployment](https://github.com/n7484443/FlutterCyoap/actions/workflows/pages/pages-build-deployment/badge.svg?branch=gh-pages)](https://github.com/n7484443/FlutterCyoap/actions/workflows/pages/pages-build-deployment)

[cyoap web](https://n7484443.github.io/FlutterCyoap/)

[web 배포용 뷰어](https://github.com/n7484443/cyoap_vue/releases/tag/v0.1.0)
## 목차
1. [프로젝트 파일 형식](#프로젝트-파일-형식)

## 프로젝트 파일 형식
* zip - 불러오기는 웹에서만 지원. 그 외는 모든 플랫폼이 지원.
* 폴더 - 윈도우, 안드로이드에서만 지원. 보다 빠르고 관리가 쉬운 편집.

|                  | android | windows | web |
|-----------------:|:-------:|:-------:|:---:|
|    zip file read |    O    |    O    |  O  |
|   zip file write |    O    |    O    |  O  |
|   directory read |    O    |    O    |  X  |
|  directory write |    O    |    O    |  X  |
| webp compression |    O    |    O    |  X  |

## 변수 정의 예제
```javascript
// 주석은 이렇게 답니다. 이 기호 이후의 부분은 컴파일 되지 않습니다.
var i = 123
// var은 지역변수로, 가로 줄마다 초기화됩니다. 따라서 간단한 계산에 사용됩니다.
var d = -3.14
var b = true
var str = "가나다"
let e = not(b) 
// let은 전역변수로, cyoa 페이지 전체에서 통용되는 변수입니다.
```

## Windows 에서 알수 없는 개발자라는 경고가 떠요!
* 제가 유료로 해야 하는 디지털 인증을 안해서 그렇습니다.
* 추가정보->실행 하시면 됩니다.
## 배포 방법
dist 폴더를 생성하고, 거기에 프로젝트 압축을 풀거나 폴더 형식이면 그대로 옮기면 됩니다.

## Todo List
### 문법적 사양
현제는 선택지 제목을 띄워쓰기 없이 사용하고 있지만, 이는 영어로만 이루어진 경우 변수와 오류가 생길 수 있음.
따라서 $[선택지 이름] 형태로 변경 필요.
#### 기존
```javascript
if(선택지1){
    a = 1
}else{
    if(check){
        b = true;
    }else{
        c = false;
    }
}
```
#### 변경
```javascript
if($[선택지 1]){
    a = 1
}else if(check){
    b = true
}else{
    c = false
}
```
### 문법 오류 표시기 추가

## 함수 목록
```python
if(조건){
    조건이 참일 경우 실행 문장
}else{
    조건이 거짓일 경우 실행 문장
}
```
```python
for(i in 1..5){
    i는 1,2,3,4 이고, 5는 포함되지 않음.
    지역변수로 i가 선언되어 있음.
}
```
* ### and | bool → bool
  * 모든 값이 참일 때 참을 내보냅니다.
  * and(조건1, 조건2, true, false, 등등) → false
* ### or | bool → bool
  * 한개의 값이라도 참일 때 참을 내보냅니다.
  * or(조건1, 조건2, true, false, 등등) → true
* ### not | bool → bool
  * 값을 반전합니다.
  * not(false) → true
* ### floor | double → int
  * 값을 내림합니다.
  * floor(3.6) → 3
* ### round | double → int
  * 값을 반올림합니다.
  * round(3.6) → 4
* ### ceil | double → int
  * 값을 올림합니다.
  * ceil(3.6) → 4
* ### random | int → int
  * 랜덤값을 반환합니다. 0 ~ 입력값-1 이 나옵니다.
  * random(3) → 2
* ### exist | string → bool
  * 변수가 존재하는지 여부를 확인합니다. 
  * exist("변수 이름") → true
* ### isVisible | string → bool
  * 변수가 숨겨져있는지 여부를 확인합니다.
  * isVisible("변수 이름") → true
* ### setVisible | string, bool
  * 변수를 숨기거나 보이게 합니다.
  * setVisible("변수 이름", false) → 변수가 숨겨짐
* ### 그 외의 기본 연산
  * +, -, *, / 의 사칙연산
  * =
  * ==, !=, >, <, >=, <=