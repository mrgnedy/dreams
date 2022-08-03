class URLs {
  const URLs._();
  static const String _BASE_URL = "https://dreams.gulfterminal.com/api/v1/";
  static const String LOGIN = '${_BASE_URL}login';
  static const String REGISTER = '${_BASE_URL}register';
  static const String FORGET_PASSWORD = '${_BASE_URL}forget-password';
  static const String RESEND_CODE = '${_BASE_URL}resend-code';
  static const String CODE_CONFIRM = '${_BASE_URL}code-confirm';
  static const String NEW_PASSOWRD = '${_BASE_URL}new-password';
  static const String CITIES = '${_BASE_URL}cities';

  static const String GET_MOABERENLIST = "${_BASE_URL}interpreters?pages=";
  static const String GET_QUESTIONS = "${_BASE_URL}questions";
  static const String SUBMIT_QUESTION = "${_BASE_URL}submit-answers";
  static const String MY_DREAMS = "${_BASE_URL}dreams-list";
  static const String ANSWER_DREAM = "${_BASE_URL}submit-interpreter-answer/";
}
