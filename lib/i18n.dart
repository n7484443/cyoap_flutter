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
          'project_name': 'Project Name',
          'create' : 'Create',
          'font_licenses' : 'Font licenses',

          //common
          'variable': 'Variable',
          'variable_name': 'Variable',
          'version': 'Variable name',
          'confirm': 'Confirm',
          'cancel': 'Cancel',
          'back' : 'Back',
          'search': 'Search',
          'node': 'Node',

          //play page
          'summary': 'Summary',
          'summary_error': 'No options selected',
          'show_image_source': 'View source',
          'debug_mode': 'Enable debug mode',

          'save_as_image' : 'Save as image',

          'copy_clipboard' : 'Copy to clipboard',

          //make page
          'lineSetting_tooltip_0': 'Number of selections available',
          'lineSetting_tooltip_1': 'Max %s number of selections',
          'lineSetting': 'Line settings',
          'preset_setting_tooltip': 'Preset settings',
          'visible_condition_tooltip':
              'Visible condition (visible when true, true when empty)',
          'design_settings': 'Design settings',
          'image_settings': 'Image settings',
          'project_settings': 'Project settings',
          'compress_process': 'Compressing...',
          'save_process': 'Saving...',
          'remove_tooltip': 'Delete selections with drag-and-drop',
          'create_tooltip' : 'Drag to create a selection',
          'recently_tooltip' : 'Create recently deleted options',
          'update_variable_tooltip' : 'Update the variable list',
          'save_option' : 'Saving options',
          'save' : 'Save',
          'extract' : 'Extract to zip file',

          'remove_image' : 'Delete images from a project',
          'remove_image_undo' : 'Undelete an image',

          'change_data' : 'Change data',
          'variable_init' : 'Variable initial values',
          'variable_notation' : 'Variable notation',
          'variable_show' : 'Show when playing',
          'variable_add' : 'Add default values',

          //image editor
          'crop_ratio_free' : 'Free',
          'crop_rotate' : 'Rotate',
        },
        "ko_kr": {
          'language': '언어 설정',

          //first page
          'add_file': '파일 추가',
          'add_folder': '폴더 추가',
          'save_as_webp': '저장 시 이미지를 webp 파일로 변환',
          'settings': '설정',
          'project_name': '프로젝트명',
          'create' : '생성',
          'font_licenses' : '폰트 라이센스',

          //common
          'variable': '변수',
          'version': '버전',
          'variable_name': '변수명',
          'confirm': '확인',
          'cancel': '취소',
          'back' : '뒤로가기',
          'search': '검색',
          'node': '노드',

          //play page
          'summary': '요약',
          'summary_error': '선택한 선택지가 없습니다.',
          'show_image_source': '이미지 출처 보기',
          'debug_mode': '디버그 모드 활성화',

          'save_as_image' : '이미지로 저장',

          'copy_clipboard' : '클립보드로 복사',

          //make page
          'lineSetting_tooltip_0': '선택 가능 개수',
          'lineSetting_tooltip_1': '최대 %s 개만큼 선택 가능',
          'lineSetting': '라인 설정',
          'preset_setting_tooltip': '프리셋 설정',
          'visible_condition_tooltip': '보이는 조건(true 일 때 보임, 비어있을 시 true)',
          'design_settings': '디자인 설정',
          'image_settings': '이미지 설정',
          'project_settings': '프로젝트 설정',
          'compress_process': '압축중...',
          'save_process': '저장중...',
          'remove_tooltip': '드래그-드랍으로 선택지 삭제',
          'recently_tooltip' : '드래그로 선택지 생성',
          'update_variable_tooltip' : '변수 목록 갱신',
          'save_option' : '저장 관련 옵션',
          'save' : '저장',
          'extract' : 'zip 파일로 추출',

          'remove_image' : '프로젝트에서 이미지 삭제',
          'remove_image_undo' : '이미지 삭제 취소',

          'change_data' : '데이터 변경',
          'variable_init' : '변수 초기값',
          'variable_notation' : '변수 표기명',
          'variable_show' : '플레이시 표시',
          'variable_add' : '초기값 추가',

          //image editor
          'crop_ratio_free' : '자유',
          'crop_rotate' : '회전',
        },
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
