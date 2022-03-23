# CYOA Player
<img src="https://img.shields.io/github/v/release/n7484443/FlutterCyoap"></img>
[![pages-build-deployment](https://github.com/n7484443/FlutterCyoap/actions/workflows/pages/pages-build-deployment/badge.svg?branch=gh-pages)](https://github.com/n7484443/FlutterCyoap/actions/workflows/pages/pages-build-deployment)

[web 버전](https://n7484443.github.io/FlutterCyoap/)

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

## 함수 리스트
* if
* floor
* round
* ceil
* +, -, *, / 의 사칙연산
* =
* ==, !=, >, <, >=, <=
* and, or, not
* random

## 변수의 종류
* int => 1, 2, 3, -1 등
* double => 5.0, -3.14 등
* boolean => true, false
* string => 쌍따음표 "로 둘러싸인 값.

## 알수 없는 개발자라는 오류가 떠요!
* 제가 유료로 해야 하는 디지털 인증을 안해서 그렇습니다.
* windows 의 경우 추가정보->실행, android의 경우 무시하고 실행 하시면 됩니다.

## 배포 방법
index.html 의
```
<script src="save_web.js" type="application/javascript"></script>
<script src="jszip.js" type="application/javascript"></script>
```
이 두줄을 삭제.
flutter_service_worker.js 의
```
Notice 검색 후 그 글자를 포함한 줄 삭제
```
후 dist 폴더를 생성하고, 거기에 압축을 풀면 됩니다.