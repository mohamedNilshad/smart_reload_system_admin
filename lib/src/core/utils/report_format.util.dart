/// Currency symbol shown on the dashboard.
const kCurrency = 'Rs. ';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// 12500 -> "Rs. 12,500", 99.5 -> "Rs. 99.50"
String formatMoney(double value, {String currency = kCurrency}) {
  final isWhole = value == value.roundToDouble();
  final fixed = value.abs().toStringAsFixed(isWhole ? 0 : 2);
  final parts = fixed.split('.');
  final grouped = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final sign = value < 0 ? '-' : '';
  final decimals = parts.length > 1 ? '.${parts[1]}' : '';
  return '$sign$currency$grouped$decimals';
}

String formatDay(DateTime d) => '${d.day} ${_months[d.month - 1]}';

String formatPct(double pct) => '${pct.abs().toStringAsFixed(0)}%';

/// 2 -> "2", 2.5 -> "2.5"
String formatRate(double rate) =>
    rate == rate.roundToDouble() ? rate.toStringAsFixed(0) : rate.toStringAsFixed(1);
