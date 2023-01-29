import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("en_us") +
      const {
        "en_us": {
          //first page
          'add_file': 'Add file',
          'add_folder': 'Add folder',
          'save_as_webp' : 'Save as WebP',

          //common
          'variable': 'Variable',
          'version' : 'Version',

          //play page
          'summary' : 'Summary',
          'show_image_source' : 'Show image source',
          'debug_mode' : 'Debug mode',
          //make page
        },
        "ko_kr": {
          //first page
          'add_file': '파일 추가',
          'add_folder': '폴더 추가',
          'save_as_webp' : '저장 시 이미지를 webp 파일로 변환',

          //common
          'variable': '변수',
          'version' : '버전',
          
          //play page
          'summary' : '요약',
          'show_image_source' : '이미지 출처 보기',
          'debug_mode' : '디버그 모드'
          //make page
        },
      };

  String get i18n => localize(this, _t);
}
