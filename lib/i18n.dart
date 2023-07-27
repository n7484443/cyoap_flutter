import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("en_us") +
      const {
        //common
        "en": {
          'language': 'Language Setting',
          'variable': 'Variable',
          'variable_name': 'Row name',
          'version': 'Version',
          'confirm': 'Ok',
          'cancel': 'Cancel',
          'back': 'Back',
          'save': 'Save',
          'search': 'Search',
          'node': 'Choices',
          'line': 'Row',
          'yes': 'Yes',
          'no': 'No',
          'edit': 'Edit',
          'length': 'Width',
        },
        "ko": {
          'language': '언어 설정',
          'variable': '변수',
          'version': '버전',
          'variable_name': '변수명',
          'confirm': '확인',
          'cancel': '취소',
          'back': '뒤로가기',
          'save': '저장',
          'search': '검색',
          'node': '선택지',
          'line': '라인',
          'yes': '예',
          'no': '아니오',
          'edit': '편집',
          'length': '크기',
        }
      } +
      const {
        //first page
        "en": {
          'add_file': 'Add file',
          'add_folder': 'Add folder',
          'save_as_webp': 'Convert images to WEBP when saving',
          'force_wide': 'Forced wide mode',
          'settings': 'Settings',
          'project_name': 'Project Name',
          'create': 'Create',
          'font_licenses': 'Font licenses',
          'version_check': 'New version available!',
          'version_latest': 'Latest version : ',
        },
        "ko": {
          'add_file': '파일 추가',
          'add_folder': '폴더 추가',
          'save_as_webp': '저장 시 이미지를 webp 파일로 변환',
          'force_wide': '항상 최대 칸수로 보기',
          'settings': '설정',
          'project_name': '프로젝트명',
          'create': '생성',
          'font_licenses': '폰트 라이센스',
          'version_check': '새로운 버전이 있습니다!',
          'version_latest': '최신 버전 : ',
        }
      } +
      const {
        //play page
        "en": {
          'summary': 'Summary',
          'summary_error': 'No options selected',
          'show_image_source': 'View source',
          'debug_mode': 'Enable debug mode',

          'save_as_image': 'Save as image',

          'copy_clipboard': 'Copy to clipboard and close',
        },
        "ko": {
          'summary': '요약',
          'summary_error': '선택한 선택지가 없습니다.',
          'show_image_source': '이미지 출처 보기',
          'debug_mode': '디버그 모드 활성화',

          'save_as_image': '이미지로 저장',

          'copy_clipboard': '클립보드로 복사 후 닫기',
        }
      } +
      const {
        "en": {
          //make page
          'lineSetting_tooltip_0': 'Number of selections available',
          'lineSetting_tooltip_1': 'Allowed Choices %s',
          'lineSetting_tooltip_2': "ChoiceLine's name",
          'lineSetting': 'Row settings',
          'preset_setting_tooltip': 'Preset settings',
          'visible_condition_tooltip': 'Visible condition (visible when true)',
          'design_settings': 'Design',
          'image_settings': 'Images',
          'project_settings': 'Variables',
          'compress_process': 'Compressing...',
          'save_process': 'Saving...',
          'create_tooltip': 'Create a choice',
          'copy_tooltip':
              'Drag and drop to make a copy a recently deleted choice',
          'recently_tooltip':
              'Drag and drop to make a restore a recently deleted choice',
          'update_variable_tooltip': 'Update the variable list',
          'save_option': 'Saving options',
          'extract': 'Save as Zip',

          'remove_image': 'Delete images',
          'remove_image_undo': 'Cancel',

          'change_data': 'Change data',
          'variable_init': 'Initial value',
          'variable_notation': 'Variable Name',
          'variable_show': 'Show when playing',
          'variable_add': 'Add variable',
          'variable_show_hidden': 'Hidden variables',

          'unsaved': 'There is something unsaved. Do you want to save it?',
          'warning': '!Warning!',
          'warning_message':
              'This is a complete deletion of the selected project and cannot be recovered. Are you sure you want to delete it?',

          'add_image': 'Upload image',
          'add_image_description': 'Drop image here or',
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
          'source_hint': 'If you dont know a source, leave it blank.',
          'crop': 'Crop',
          'code_hint_execute_condition': 'Execution Conditions',
          'code_hint_visible_condition':
              'Visible Conditions (Visible when true)',
          'code_hint_execute': 'Executable code on selection',
          'space_hide': 'Takes up space when hidden',
          'sort': 'Sort',
          'sort_error':
              'The number of {\'s and }\'s in the code are not equal.',
          'auto_complete': 'Auto Complete',
          'hide_result': 'Hide \n in viewer',
          'show_result': 'Show \n in viewer',
          'slider_mode': 'Slider mode',

          'default': 'Default',
          'random': 'Random',
          'multiple': 'Multiple selections',
          'unselect': 'Unable to select',
          'onlyCode': 'Use code only',

          'max_select': 'MaxSelect',
          'max_random': 'Random number, 0 to n-1',
          
          'gui': 'Change editing type',
          'editor_simple': 'Simple',
          'editor_code': 'Code',

          //preset
          'preset': 'Preset',
          'preset_setting': 'Preset settings',
          'preset_new': 'New preset',
          'black_line': 'Line between rows',
          'background_color': 'Background color',
          'color_select': 'Select color',
          'color_direct_select': 'Direct selection',
          'height': 'Shadow of the choice',
          'round': 'Rounded corners',
          'padding': 'Inner padding',
          'maximize_image': 'Maximize images',
          'hide_title': 'Hide title',
          'title_up': 'Title up',
          'horizontal_mode': 'Horizontal mode',
          'image_left': 'Image left',
          'node_color': 'Choices background color',
          'node_outline_color': 'Border color when choice is selected',
          'font_title': 'Title font',
          'font_content': 'Content font',

          //design
          'general': 'General',
          'background': 'Background',
          'font_score': 'Score font',
          'margin_vertical': 'Vertical margin between choices',
          'margin_default': 'Default value',
          'background_image': 'Background Image',
          'outline_shape': 'Outline shape',
          'outline_padding': 'Outline padding',
          'outline_width': 'Outline width',

          'modify_size': 'Modify size',
          'random_show': 'Random',
          'copy': 'Copy',
          'delete': 'Delete',
          'sample_node': 'Adjust and view layouts, fonts, designs and more.',
          'sample_title': 'Design',
        },
        "ko": {
          //make page
          'lineSetting_tooltip_0': '선택 가능 개수',
          'lineSetting_tooltip_1': '최대 %s 개만큼 선택 가능',
          'lineSetting_tooltip_2': "선택지 줄 명칭",
          'lineSetting': '라인 설정',
          'preset_setting_tooltip': '프리셋 설정',
          'visible_condition_tooltip': '보이는 조건(true 일 때 보임, 비어있을 시 true)',
          'design_settings': '디자인 설정',
          'image_settings': '이미지 설정',
          'project_settings': '프로젝트 설정',
          'compress_process': '압축중...',
          'save_process': '저장중...',
          'create_tooltip': '선택지 생성',
          'recently_tooltip': '드래그로 삭제된 선택지 생성',
          'copy_tooltip': '드래그로 복사된 선택지 생성',
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
          'variable_show_hidden': '숨겨진 변수',

          'unsaved': '저장되지 않은 내용이 있습니다. 저장하시겠습니까?',
          'warning': '!경고!',
          'warning_message':
              '이것은 선택된 프로젝트를 완전히 삭제하는 것이며, 복구할 수 없습니다. 삭제하시겠습니까?',

          'add_image': '이미지 추가',
          'add_image_description': '이미지를 추가하려면 드래그하세요. 혹은, ',
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
          'auto_complete': '자동 완성',
          'hide_result': '결론창에서 \n숨기기',
          'show_result': '결론창에서 \n보이기',
          'slider_mode': '슬라이더 모드',

          'default': '기본',
          'random': '랜덤 선택',
          'multiple': '다중 선택',
          'unselect': '선택 불가',
          'onlyCode': '코드만 사용',

          'max_select': '최대 선택',
          'max_random': '랜덤, 0 에서 n-1까지',

          'gui': '에디터 변경',
          'editor_simple': '간편',
          'editor_code': '코드',

          //preset
          'preset': '프리셋',
          'preset_setting': '프리셋 설정',
          'preset_new': '새 프리셋',
          'black_line': '검은 줄이 보임',
          'background_color': '배경 색상',
          'color_select': '색상 선택',
          'color_direct_select': '직접 선택',
          'height': '높이',
          'round': '라운드',
          'padding': '내부 여백',
          'maximize_image': '이미지 최대화',
          'hide_title': '제목 숨기기',
          'title_up': '제목을 위로',
          'horizontal_mode': '가로 모드',
          'image_left': '이미지 왼쪽으로',
          'node_color': '선택지 색상',
          'node_outline_color': '외곽선 색상',
          'font_title': '제목 폰트',
          'font_content': '내용 폰트',

          //design
          'general': '일반',
          'background': '배경',
          'font_score': '점수 폰트',
          'margin_vertical': '선택지 간 세로 여백',
          'margin_default': '기본 값',
          'background_image': '배경 이미지',
          'outline_shape': '외곽선',
          'outline_padding': '외곽선 여백',
          'outline_width': '외곽선 두께',

          'modify_size': '크기 수정',
          'random_show': '랜덤',
          'copy': '복사',
          'delete': '삭제',
          'sample_node': '레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.',
          'sample_title': '디자인',
        },
      };

  String get i18n {
    return localize(this, _t);
  }

  String fill(List<Object> params) => localizeFill(this, params);
}
