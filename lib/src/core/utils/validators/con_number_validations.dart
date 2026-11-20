import 'package:smart_reload_system_admin/src/core/enums/connection_data.enum.dart';

class ConnectionValidator {
  // Regex Definitions

  // 1. HBB Dialog: Matches 81XXXXXXX
  static final RegExp _dialogHBBRegex = RegExp(r'^81\d{7}$');

  // 2. SLT Landline / Fiber HBB: Matches standard Sri Lankan area codes (e.g., 011XXXXXXX, 033XXXXXXX)
  static final RegExp _sltLandlineRegex = RegExp(r'^(?:\+94|0)(11|21|23|24|25|26|27|31|32|33|34|35|36|37|38|41|45|47|51|52|54|55|57|63|65|66|67|81|91)\d{7}$');

  // 3. Mobile Airtel number format (075XXXXXXX)
  static final RegExp _airtelMobileRegex = RegExp(r'^075\d{7}$');

  // 4. Mobile Dialog number format (074XXXXXXX | 076XXXXXXX | 077XXXXXXX | 0777XXXXXXX)
  static final RegExp _dialogMobileRegex = RegExp(r'^(074|076|077)\d{7}$');

  // 5. Mobile Hutch number format (072XXXXXXX | 078XXXXXXX)
  static final RegExp _hutchMobileRegex = RegExp(r'^07[28]\d{7}$');

  // 6. Mobile Mobitel number format (071XXXXXXX)
  static final RegExp _mobitelMobileRegex = RegExp(r'^071\d{7}$');

  // 7. Dialog TV Account Number: Typically 8 digits (e.g., 80XXXXXX)
  static final RegExp _dialogTvRegex = RegExp(r'^80\d{6}$');


  // 4. CEB (Ceylon Electricity Board): Exactly 10 digits
  static final RegExp _cebRegex = RegExp(r'^\d{10}$');

  // 5. NWSDB (Water Board): 12 digits, often formatted with slashes or dots (e.g., 12/34/567/891/11)
  static final RegExp _nwsdbRegex = RegExp(r'^(\d{2}/\d{2}/\d{3}/\d{3}/\d{2})|(\d{12})$');

  /// Main validation entry point based on your UI fields
  static bool validate({
    required String category,      // 'Telecom' or 'Utility'
    required String serviceType,   // 'Mobile', 'HBB', 'TV', 'CEB', 'NWSDB'
    required String provider,      // 'Dialog', 'Hutch', 'SLT', etc.
    required String connectionNo,  // The raw input string
  }) {
    // Sanitize input by removing leading/trailing spaces
    final cleanInput = connectionNo.trim();

    if (cleanInput.isEmpty) return false;

    if (category.toLowerCase() == ConCategory.Telecom.name.toLowerCase()) {

      if(serviceType.toLowerCase() == TelecomType.Mobile.name.toLowerCase()){

        if (provider == ServiceProviderMobile.Airtel_Sri_Lanka.name.replaceAll("_", " ")) {
          // Airtel number format (075XXXXXXX)
          return _airtelMobileRegex.hasMatch(cleanInput);

        } else if (provider == ServiceProviderMobile.Dialog_Axiata.name.replaceAll("_", " ")) {
          // Dialog number format (074XXXXXXX | 076XXXXXXX | 077XXXXXXX | 0777XXXXXXX)
          return _dialogMobileRegex.hasMatch(cleanInput);

        } else if (provider == ServiceProviderMobile.Hutch.name.replaceAll("_", " ")) {
          // Hutch number format (072XXXXXXX | 078XXXXXXX)
          return _hutchMobileRegex.hasMatch(cleanInput);

        } else if (provider == ServiceProviderMobile.SLT_Mobitel.name.replaceAll("_", " ")) {
          // Mobitel number format (071XXXXXXX)
          return _mobitelMobileRegex.hasMatch(cleanInput);

        }

      } else if(serviceType.toLowerCase() == TelecomType.HBB.name.toLowerCase()){
        if (provider == ServiceProviderHBB.SLT_Mobitel.name.replaceAll("_", " ")) {
          // SLT HBB uses the home landline/fiber circuit number format (011XXXXXXX)
          return _sltLandlineRegex.hasMatch(cleanInput);
        } else {
          // Dialog HBB (81XXXXXXX)
          return _dialogHBBRegex.hasMatch(cleanInput);
        }

      }else if(serviceType.toLowerCase() == TelecomType.TV.name.toLowerCase()){

        if (provider == ServiceProviderHBB.SLT_Mobitel.name.replaceAll("_", " ")) {
          // SLT HBB uses the home landline/fiber circuit number format (011XXXXXXX)
          // return _sltTvRegex.hasMatch(cleanInput);
        } else {
          // Dialog HBB (81XXXXXXX)
          return _dialogTvRegex.hasMatch(cleanInput);
        }

      }
    }

    if (category.toLowerCase() == ConCategory.Utility.name.toLowerCase()) {

      if(serviceType.toLowerCase() == UtilType.CEB.name.toLowerCase()){
        return _cebRegex.hasMatch(cleanInput);

      }else{
        return _nwsdbRegex.hasMatch(cleanInput);

      }
    }

    return false;
  }
}
