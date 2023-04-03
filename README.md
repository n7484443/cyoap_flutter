# CYOA Player

<img src="https://img.shields.io/github/v/release/n7484443/cyoap_flutter"></img>
[![pages-build-deployment](https://github.com/n7484443/cyoap_flutter/actions/workflows/pages/pages-build-deployment/badge.svg?branch=gh-pages)](https://github.com/n7484443/cyoap_flutter/actions/workflows/pages/pages-build-deployment)

[변경점](https://github.com/n7484443/cyoap_flutter/blob/main/CHANGELOG.md)

[cyoap web](https://n7484443.github.io/cyoap_flutter/)

[web 배포용 뷰어](https://github.com/n7484443/cyoap_vue/releases/tag/v0.1.0)

## 목차
1. [프로젝트 파일 형식](#프로젝트-파일-형식)
2. [Windows 에서 알수 없는 개발자라는 경고가 떠요!](#Windows-경고)
3. [배포 방법](#배포-방법)

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

## Windows 경고
* 제가 유료로 해야 하는 디지털 인증을 안해서 그렇습니다.
* 추가정보->실행 하시면 됩니다.
## 배포 방법
dist 폴더를 생성하고, 거기에 프로젝트 압축을 풀거나 폴더 형식이면 그대로 옮기면 됩니다.
