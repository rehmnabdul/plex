/// Default English strings for all user-visible text in the Plex library.
///
/// Subclass [PlexStrings] and override getters to provide custom translations.
class PlexStrings {
  // Login
  String get loginTitle => 'Login';
  String get loginUsername => 'Username';
  String get loginPassword => 'Password';
  String get loginRememberMe => 'Remember Me';
  String get loginButton => 'Sign In';
  String get loginUsernameHint => 'Enter Your Email or Username';
  String get loginPasswordHint => 'Enter Your Password';
  String get loginRecentLogins => 'Recent Logins';
  String get loginUsernameEmpty => "Username can't be empty";
  String get loginPasswordEmpty => "Password can't be empty";

  // Form
  String get formSubmit => 'Submit';
  String get formSave => 'Save';
  String get wizardBack => 'Back';
  String get wizardNext => 'Next';
  String get wizardSubmit => 'Submit';

  // Table
  String get tableSearch => 'Search...';
  String get tableSearchHint => 'Type here to search whole data...';
  String get tableNoData => 'No data available';
  String get tableData => 'Data';
  String get tableCopy => 'Copy';
  String get tablePrint => 'Print';

  // Dialogs / Sheets
  String get dialogOk => 'OK';
  String get dialogCancel => 'Cancel';
  String get dialogClose => 'Close';

  // Form Fields
  String get pickDate => 'Pick a date';
  String get pickTime => 'Pick a time';
  String get dropdownNoData => 'N/A';
  String get filePickerSelect => 'Select File(s)';
  String get colorPickerTitle => 'Pick a color';

  // Misc
  String get versionLabel => 'Version:';
}
