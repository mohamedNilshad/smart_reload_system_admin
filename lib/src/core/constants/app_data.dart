class AppData {
  String dWifiUssd = "#678#5#-#1#2#";

  String dialogMobile = "*#456#";
  String mobitelMobile = "*100#";
  String hutchPostMobile = "*444#";
  String hutchPreMobile = "*344#";
  String airtelMobile = "*550#";

  static double lockAmount = 10000.0;
  static String lockAmountMessage = "Please settle your outstanding bill to access this feature.";


  static const banks = <String, String>{
    'Bank of Ceylon': '7010',
    "People's Bank": '7135',
    'Commercial Bank of Ceylon PLC': '7056',
    'Hatton National Bank PLC': '7083',
    'Sampath Bank PLC': '7278',
    'Seylan Bank PLC': '7287',
    'National Savings Bank': '7719',
    'National Development Bank PLC': '7214',
    'Nations Trust Bank PLC': '7162',
    'Pan Asia Banking Corporation PLC': '7311',
    'Union Bank of Colombo PLC': '7302',
    'Amana Bank PLC': '7463',
    'Cargills Bank Limited': '7472',
    'HSBC': '7087',
    'Standard Chartered Bank': '7038',
    'Other': ''
  };
  static const otherBank = 'Other';
  static const accountTypes = ['Savings', 'Current'];
}