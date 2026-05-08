import 'dart:io';

void main() {
  final englishFile = File('C:/Users/Deva/OneDrive/Desktop/New folder/clothes/lib/languages/english_language.dart');
  final hindiFile = File('C:/Users/Deva/OneDrive/Desktop/New folder/clothes/lib/languages/hindi_language.dart');
  final marathiFile = File('C:/Users/Deva/OneDrive/Desktop/New folder/clothes/lib/languages/marathi_language.dart');
  final appLocalizationsFile = File('C:/Users/Deva/OneDrive/Desktop/New folder/clothes/lib/utils/localization/app_localizations.dart');

  final englishMap = '''
  'measurements': 'Measurements',
  'step': 'Step',
  'step_3_of_6': '3 of 6',
  'auto_fill_with_ai': 'Auto-Fill with AI',
  'auto_fill_desc': 'Let AI extract measurements from a body\\nphoto or text description for high-precision\\nresults.',
  'extracting_data': 'Extracting Data...',
  'start_ai_extraction': 'Start AI Extraction',
  'measurement_guide': 'MEASUREMENT GUIDE',
  'shoulder': 'Shoulder',
  'upper_body': 'Upper Body',
  'chest': 'Chest',
  'bust_optional': 'Bust (Optional)',
  'sleeve_length': 'Sleeve Length',
  'arm_length': 'Arm Length',
  'neck': 'Neck',
  'front_length': 'Front Length',
  'lower_body': 'Lower Body',
  'waist': 'Waist',
  'hip': 'Hip',
  'inseam': 'Inseam',
  'outseam': 'Outseam',
  'legs_and_height': 'Legs & Height',
  'thigh': 'Thigh',
  'knee': 'Knee',
  'calf': 'Calf',
  'ankle': 'Ankle',
  'total_height': 'Total Height',
  'custom_measurements': 'Custom Measurements',
  'label': 'Label',
  'eg_wrist': 'e.g. Wrist',
  'value': 'Value',
  'add_custom_measurement': 'Add Custom Measurement',
  'inches': 'inches',
  'additional_fitting_notes': 'Additional Fitting Notes',
  'fitting_notes_hint': 'e.g. Prefer tighter fit around\\nwaist, extra allowance for\\ncuffing...',
  'customize_details': 'Customize Details',
  'customize_details_hint': 'e.g. Monograms, hidden pockets, specific button colors...',
  'extra_options_services': 'Extra Options & Services',
  'extra_options_hint': 'e.g. Rush order requested, premium lining, matching pocket square...',
  'please_select_customer_first': 'Please select a customer first',
  'next_assign_staff': 'Next: Assign Staff',
  'unit_upper': 'Unit',
  'other_upper': 'OTHER',
  'cm_upper': 'CM',
  'inch_upper': 'INCH',
  'male_upper': 'MALE',
  'female_upper': 'FEMALE',
  'ai_auto_filled_measurements_detected': 'AI auto-filled measurements detected!',
  'unknown_customer': 'Unknown Customer',
  'no_contact_information': 'No contact information',
''';

  final hindiMap = '''
  'measurements': 'माप (Measurements)',
  'step': 'कदम (Step)',
  'step_3_of_6': '6 में से 3',
  'auto_fill_with_ai': 'AI के साथ ऑटो-फ़िल',
  'auto_fill_desc': 'उच्च-सटीक परिणामों के लिए AI को शरीर की तस्वीर या पाठ विवरण से माप निकालने दें।',
  'extracting_data': 'डेटा निकाला जा रहा है...',
  'start_ai_extraction': 'AI एक्सट्रैक्शन शुरू करें',
  'measurement_guide': 'माप गाइड',
  'shoulder': 'कंधा',
  'upper_body': 'ऊपरी शरीर',
  'chest': 'छाती',
  'bust_optional': 'बस्ट (वैकल्पिक)',
  'sleeve_length': 'आस्तीन की लंबाई',
  'arm_length': 'हाथ की लंबाई',
  'neck': 'गर्दन',
  'front_length': 'सामने की लंबाई',
  'lower_body': 'निचला शरीर',
  'waist': 'कमर',
  'hip': 'कूल्हा',
  'inseam': 'इनसीम',
  'outseam': 'आउटसीम',
  'legs_and_height': 'पैर और ऊँचाई',
  'thigh': 'जांघ',
  'knee': 'घुटना',
  'calf': 'पिंडली',
  'ankle': 'टखना',
  'total_height': 'कुल ऊँचाई',
  'custom_measurements': 'कस्टम माप',
  'label': 'लेबल',
  'eg_wrist': 'उदाहरण: कलाई',
  'value': 'मान (Value)',
  'add_custom_measurement': 'कस्टम माप जोड़ें',
  'inches': 'इंच',
  'additional_fitting_notes': 'अतिरिक्त फिटिंग नोट्स',
  'fitting_notes_hint': 'उदाहरण: कमर के आसपास कड़ा फिट पसंद है, कफिंग के लिए अतिरिक्त भत्ते...',
  'customize_details': 'विवरण अनुकूलित करें',
  'customize_details_hint': 'उदाहरण: मोनोग्राम, छिपी हुई जेबें, विशिष्ट बटन के रंग...',
  'extra_options_services': 'अतिरिक्त विकल्प और सेवाएँ',
  'extra_options_hint': 'उदाहरण: रश ऑर्डर का अनुरोध, प्रीमियम अस्तर, मैचिंग पॉकेट स्क्वायर...',
  'please_select_customer_first': 'कृपया पहले किसी ग्राहक का चयन करें',
  'next_assign_staff': 'अगला: स्टाफ असाइन करें',
  'unit_upper': 'इकाई',
  'other_upper': 'अन्य',
  'cm_upper': 'सेमी',
  'inch_upper': 'इंच',
  'male_upper': 'पुरुष',
  'female_upper': 'महिला',
  'ai_auto_filled_measurements_detected': 'AI ऑटो-फ़िल्ड माप का पता चला!',
  'unknown_customer': 'अज्ञात ग्राहक',
  'no_contact_information': 'कोई संपर्क जानकारी नहीं',
''';

  final marathiMap = '''
  'measurements': 'मापे (Measurements)',
  'step': 'पायरी (Step)',
  'step_3_of_6': '६ पैकी ३',
  'auto_fill_with_ai': 'AI सह ऑटो-फील',
  'auto_fill_desc': 'अचूक परिणामांसाठी AI ला शरीराच्या फोटोवरून किंवा मजकूर वर्णनावरून मापे काढू द्या.',
  'extracting_data': 'डेटा काढत आहे...',
  'start_ai_extraction': 'AI एक्सट्रैक्शन सुरू करा',
  'measurement_guide': 'मापे मार्गदर्शक',
  'shoulder': 'खांदा',
  'upper_body': 'वरचे शरीर',
  'chest': 'छाती',
  'bust_optional': 'बस्ट (पर्यायी)',
  'sleeve_length': 'हाताची लांबी (Sleeve)',
  'arm_length': 'हाताची लांबी (Arm)',
  'neck': 'मान',
  'front_length': 'पुढील लांबी',
  'lower_body': 'खालचे शरीर',
  'waist': 'कंबर',
  'hip': 'नितंब (Hip)',
  'inseam': 'इनसीम',
  'outseam': 'आउटसीम',
  'legs_and_height': 'पाय आणि उंची',
  'thigh': 'मांडी',
  'knee': 'गुडघा',
  'calf': 'पोटरी',
  'ankle': 'घोटा',
  'total_height': 'एकूण उंची',
  'custom_measurements': 'कस्टम मापे',
  'label': 'लेबल',
  'eg_wrist': 'उदा. मनगट',
  'value': 'मूल्य',
  'add_custom_measurement': 'कस्टम माप जोडा',
  'inches': 'इंच',
  'additional_fitting_notes': 'अतिरिक्त फिटिंग नोट्स',
  'fitting_notes_hint': 'उदा. कंबरेभोवती घट्ट फिटिंगला प्राधान्य, कफिंगसाठी अतिरिक्त जागा...',
  'customize_details': 'तपशील कस्टमाइझ करा',
  'customize_details_hint': 'उदा. मोनोग्राम, लपलेले खिसे, विशिष्ट बटणाचे रंग...',
  'extra_options_services': 'अतिरिक्त पर्याय आणि सेवा',
  'extra_options_hint': 'उदा. तातडीची ऑर्डर विनंती, प्रीमियम अस्तर, जुळणारा पॉकेट स्क्वेअर...',
  'please_select_customer_first': 'कृपया प्रथम ग्राहक निवडा',
  'next_assign_staff': 'पुढे: कर्मचारी नेमा',
  'unit_upper': 'एकक',
  'other_upper': 'इतर',
  'cm_upper': 'सेमी',
  'inch_upper': 'इंच',
  'male_upper': 'पुरुष',
  'female_upper': 'महिला',
  'ai_auto_filled_measurements_detected': 'AI ऑटो-फील मापे सापडली!',
  'unknown_customer': 'अज्ञात ग्राहक',
  'no_contact_information': 'संपर्क माहिती नाही',
''';

  final appLocalizationsGetters = '''
  // ── Measurements Screen ──
  String get measurements => translate('measurements');
  String get step => translate('step');
  String get step3Of6 => translate('step_3_of_6');
  String get autoFillWithAi => translate('auto_fill_with_ai');
  String get autoFillDesc => translate('auto_fill_desc');
  String get extractingData => translate('extracting_data');
  String get startAiExtraction => translate('start_ai_extraction');
  String get measurementGuide => translate('measurement_guide');
  String get shoulder => translate('shoulder');
  String get upperBody => translate('upper_body');
  String get chest => translate('chest');
  String get bustOptional => translate('bust_optional');
  String get sleeveLength => translate('sleeve_length');
  String get armLength => translate('arm_length');
  String get neck => translate('neck');
  String get frontLength => translate('front_length');
  String get lowerBody => translate('lower_body');
  String get waist => translate('waist');
  String get hip => translate('hip');
  String get inseam => translate('inseam');
  String get outseam => translate('outseam');
  String get legsAndHeight => translate('legs_and_height');
  String get thigh => translate('thigh');
  String get knee => translate('knee');
  String get calf => translate('calf');
  String get ankle => translate('ankle');
  String get totalHeight => translate('total_height');
  String get customMeasurements => translate('custom_measurements');
  String get labelLabel => translate('label');
  String get egWrist => translate('eg_wrist');
  String get valueLabel => translate('value');
  String get addCustomMeasurement => translate('add_custom_measurement');
  String get inches => translate('inches');
  String get additionalFittingNotes => translate('additional_fitting_notes');
  String get fittingNotesHint => translate('fitting_notes_hint');
  String get customizeDetails => translate('customize_details');
  String get customizeDetailsHint => translate('customize_details_hint');
  String get extraOptionsServices => translate('extra_options_services');
  String get extraOptionsHint => translate('extra_options_hint');
  String get pleaseSelectCustomerFirst => translate('please_select_customer_first');
  String get nextAssignStaff => translate('next_assign_staff');
  String get unitUpper => translate('unit_upper');
  String get otherUpper => translate('other_upper');
  String get cmUpper => translate('cm_upper');
  String get inchUpper => translate('inch_upper');
  String get maleUpper => translate('male_upper');
  String get femaleUpper => translate('female_upper');
  String get aiAutoFilledMeasurementsDetected => translate('ai_auto_filled_measurements_detected');
  String get unknownCustomer => translate('unknown_customer');
  String get noContactInformation => translate('no_contact_information');
''';

  void updateLangFile(File file, String mapStr) {
    var content = file.readAsStringSync();
    int index = content.lastIndexOf('};');
    if (index != -1) {
      content = content.substring(0, index) + mapStr + content.substring(index);
      file.writeAsStringSync(content);
      print("Updated \${file.path}");
    }
  }

  void updateAppLocalizations() {
    var content = appLocalizationsFile.readAsStringSync();
    int index = content.lastIndexOf('class _AppLocalizationsDelegate');
    if (index != -1) {
      content = content.substring(0, index - 1) + appLocalizationsGetters + content.substring(index - 1);
      appLocalizationsFile.writeAsStringSync(content);
      print("Updated \${appLocalizationsFile.path}");
    }
  }

  updateLangFile(englishFile, englishMap);
  updateLangFile(hindiFile, hindiMap);
  updateLangFile(marathiFile, marathiMap);
  updateAppLocalizations();
}
