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
          'create': 'Create',
          'font_licenses': 'Font licenses',

          //common
          'variable': 'Variable',
          'variable_name': 'Variable',
          'version': 'Variable name',
          'confirm': 'Confirm',
          'cancel': 'Cancel',
          'back': 'Back',
          'save': 'Save',
          'search': 'Search',
          'node': 'Node',
          'yes': 'Yes',
          'no': 'No',

          //play page
          'summary': 'Summary',
          'summary_error': 'No options selected',
          'show_image_source': 'View source',
          'debug_mode': 'Enable debug mode',

          'save_as_image': 'Save as image',

          'copy_clipboard': 'Copy to clipboard',

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
          'create_tooltip': 'Drag to create a selection',
          'recently_tooltip': 'Create recently deleted options',
          'update_variable_tooltip': 'Update the variable list',
          'save_option': 'Saving options',
          'extract': 'Extract to zip file',

          'remove_image': 'Delete images from a project',
          'remove_image_undo': 'Undelete an image',

          'change_data': 'Change data',
          'variable_init': 'Variable initial values',
          'variable_notation': 'Variable notation',
          'variable_show': 'Show when playing',
          'variable_add': 'Add default values',

          'unsaved' : 'There is something unsaved. Do you want to save it?',
          'warning' : '!Warning!',
          'warning_message' : 'This is a complete deletion of the selected project and cannot be recovered. Are you sure you want to delete it?',

          //image editor
          'crop_ratio_free': 'Free',
          'crop_rotate': 'Rotate',

          //node editor
          'content': 'Content',
          'code': 'Code',
          'setting': 'Setting',
          'image': 'Image',
          'title': 'Title',
          'source': 'Sources',
          'source_hint':
              'If you dont know or dont have a source, leave it blank.',
          'crop': 'Crop',
          'code_hint_execute_condition': 'Execution Conditions',
          'code_hint_visible_condition':
              'Visible conditions(Visible when true, true if empty)',
          'code_hint_execute': 'Executable code on selection',
          'space_hide': 'Takes up space when hidden',
          'sort': 'Sort',
          'sort_error':
              'The number of {\'s and }\'s in the code are not equal.',
          'hide_result': 'Hide \n in the final window',
          'show_result': 'Show \n in the final window',
          'slider_mode': 'Slider mode',

          'default' : 'Default',
          'random' : 'Randomize',
          'multiple' : 'Multiple Selections',
          'unselect' : 'Unable to select',
          'onlyCode' : 'Use code only',

          'max_select' : 'MaxSelect',
          'max_random' : 'Random number, 0 to n-1',

          //preset
          'preset_setting': 'Preset settings',

          //design
          'location': 'Location',
          'font': 'Font',
          'background': 'Background',
          'preset': 'Preset',
          'font_score': 'Score font',
          'margin_vertical': 'Vertical margin between choices',
          'margin_default':'Default value',
          'background_image': 'Background Image',

          'modify_size': 'Modify size',
          'random_show': 'Random',
          'copy': 'Copy',
        },
        "ko_kr": {
          'language': '언어 설정',

          //first page
          'add_file': '파일 추가',
          'add_folder': '폴더 추가',
          'save_as_webp': '저장 시 이미지를 webp 파일로 변환',
          'settings': '설정',
          'project_name': '프로젝트명',
          'create': '생성',
          'font_licenses': '폰트 라이센스',

          //common
          'variable': '변수',
          'version': '버전',
          'variable_name': '변수명',
          'confirm': '확인',
          'cancel': '취소',
          'back': '뒤로가기',
          'save': '저장',
          'search': '검색',
          'node': '노드',
          'yes': '예',
          'no': '아니오',

          //play page
          'summary': '요약',
          'summary_error': '선택한 선택지가 없습니다.',
          'show_image_source': '이미지 출처 보기',
          'debug_mode': '디버그 모드 활성화',

          'save_as_image': '이미지로 저장',

          'copy_clipboard': '클립보드로 복사',

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
          'recently_tooltip': '드래그로 선택지 생성',
          'update_variable_tooltip': '변수 목록 갱신',
          'save_option': '저장 관련 옵션',
          'extract': 'zip 파일로 추출',

          'remove_image': '프로젝트에서 이미지 삭제',
          'remove_image_undo': '이미지 삭제 취소',

          'change_data': '데이터 변경',
          'variable_init': '변수 초기값',
          'variable_notation': '변수 표기명',
          'variable_show': '플레이시 표시',
          'variable_add': '초기값 추가',

          'unsaved' : '저장되지 않은 내용이 있습니다. 저장하시겠습니까?',
          'warning' : '!경고!',
          'warning_message' : '이것은 선택된 프로젝트를 완전히 삭제하는 것이며, 복구할 수 없습니다. 삭제하시겠습니까?',

          //image editor
          'crop_ratio_free': '자유',
          'crop_rotate': '회전',

          //node editor
          'content': '내용',
          'code': '코드',
          'setting': '설정',
          'image': '이미지',
          'title': '제목',
          'source': '출처',
          'source_hint': '출처를 모르거나 없을 경우 비워두세요.',
          'crop': '자르기',
          'code_hint_execute_condition': '실행 조건',
          'code_hint_visible_condition': '보이는 조건(true 일 때 보임, 비어있을 시 true)',
          'code_hint_execute': '선택 시 시행 코드',
          'space_hide': '숨김 시 공간 차지',
          'sort': '정렬',
          'sort_error': '코드의 {의 개수와 }의 개수가 같지 않습니다.',
          'hide_result': '결론창에서 \n숨기기',
          'show_result': '결론창에서 \n보이기',
          'slider_mode': '슬라이더 모드',

          'default' : '기본',
          'random' : '랜덤 선택',
          'multiple' : '다중 선택',
          'unselect' : '선택 불가',
          'onlyCode' : '코드만 사용',

          'max_select' : '최대 선택',
          'max_random' : '랜덤, 0 에서 n-1까지',

          //preset
          'preset_setting': '프리셋 설정',

          //design
          'location': '위치',
          'font': '폰트',
          'background': '배경',
          'preset': '프리셋',
          'font_score': '점수 폰트',
          'margin_vertical': '선택지 간 세로 여백',
          'margin_default':'기본 값',
          'background_image': '배경 이미지',

          'modify_size': '크기 수정',
          'random_show': '랜덤',
          'copy': '복사',
        },
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
