class Global{
  static int primaryColor = 0xFFFFDAC1;
  static String mToken = "";


  /// Condition to check the email address
  bool checkEmailAddress(String newEmail) {
    if (newEmail.isNotEmpty) {
      return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(newEmail);
    }
    return false;
  }


  /// block auto click or many time click
  static int mTimeClick = 0;

  static bool isAvailableToClick() {
    if (DateTime.now().millisecondsSinceEpoch - mTimeClick > 2000) {
      mTimeClick = DateTime.now().millisecondsSinceEpoch;
      return true;
    }
    return false;
  }
}