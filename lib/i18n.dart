import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("en_us") +
      const {
        "en_us": {
          'language': 'Language Setting',

          //first page
          'add_file': 'Add file',
          'add_folder': 'Add folder',
          'save_as_webp': 'Convert images to WEBP when saving',
          'settings': 'Settings',

          //common
          'variable': 'Variable',
          'variable_name': 'Variable',
          'version' : 'Variable name',
          'confirm' : 'Confirm',

          //play page
          'summary': 'Summary',
          'summary_error': 'No options selected',
          'show_image_source': 'View source',
          'debug_mode': 'Enable debug mode',
          //make page
          'lineSetting_tooltip_0' : 'Number of selections available',
          'lineSetting_tooltip_1' : 'Max %s number of selections',
          'lineSetting' : 'Line settings',
          'preset_setting_tooltip' : 'Preset settings',
          'visible_condition_tooltip' : 'Visible condition (visible when true, true when empty)',
        },
        "ko_kr": {
          'language': '언어 설정',

          //first page
          'add_file': '파일 추가',
          'add_folder': '폴더 추가',
          'save_as_webp': '저장 시 이미지를 webp 파일로 변환',
          'settings': '설정',

          //common
          'variable': '변수',
          'version': '버전',
          'variable_name': '변수명',
          'confirm' : '확인',

          //play page
          'summary': '요약',
          'summary_error': '선택한 선택지가 없습니다.',
          'show_image_source': '이미지 출처 보기',
          'debug_mode': '디버그 모드 활성화',
          //make page
          'lineSetting_tooltip_0': '선택 가능 개수',
          'lineSetting_tooltip_1' : '최대 %s 개만큼 선택 가능',
          'lineSetting' : '라인 설정',
          'preset_setting_tooltip' : '프리셋 설정',
          'visible_condition_tooltip' : '보이는 조건(true 일 때 보임, 비어있을 시 true)',
        },
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
