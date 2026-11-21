import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_row.entity.dart';

// Firestore collection names.
const _requestsCollection = 'requested_packages';
const _connectionsCollection = 'connections';
const _packagesCollection = 'package_details';
const _usersCollection = 'users';

// TODO: where the commission percentage is stored. Reads
// settings/app -> commissionPercent (a number such as 2.5). If it is missing
// the commission shows as 0 until the System settings screen sets it.
const _settingsCollection = 'settings';
const _settingsDoc = 'app';
const _commissionField = 'commissionPercent';

const _amountReloadLabel = 'Amount reload';

/// Reads platform-wide data for the admin dashboard.
///
/// The admin account needs read access to these collections in your
/// Firestore rules.
class AdminReportsRemoteDataSource {
  AdminReportsRemoteDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  /// Loads requests made in [from, to) plus every unpaid request, the vendor
  /// list, platform totals and the commission rate.
  Future<AdminReportSourceEntity> fetch({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final requests = _db.collection(_requestsCollection);

      // Start everything at once, then wait for the results.
      final inRangeFuture = requests
          .where('requestDate', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
          .where('requestDate', isLessThan: Timestamp.fromDate(to))
          .get();
      final unpaidFuture = requests.where('isPaid', isEqualTo: false).get();
      final vendorsFuture =
          _db.collection(_usersCollection).where('role', isEqualTo: 'vendor').get();
      final clientCountFuture = _db
          .collection(_usersCollection)
          .where('role', isEqualTo: 'client')
          .count()
          .get();
      final connectionCountFuture =
          _db.collection(_connectionsCollection).count().get();
      final settingsFuture =
          _db.collection(_settingsCollection).doc(_settingsDoc).get();

      final inRange = await inRangeFuture;
      final unpaid = await unpaidFuture;
      final vendors = await vendorsFuture;
      final clientCount = (await clientCountFuture).count ?? 0;
      final connectionCount = (await connectionCountFuture).count ?? 0;
      final settings = await settingsFuture;

      final docs = <String, Map<String, dynamic>>{};
      for (final snap in [inRange, unpaid]) {
        for (final doc in snap.docs) {
          docs[doc.id] = doc.data();
        }
      }

      final connectionIds = <String>{
        for (final d in docs.values)
          if (_hasId(d['connectionId'])) d['connectionId'] as String,
      };
      final packageIds = <String>{
        for (final d in docs.values)
          if (_hasId(d['packageDetailsId'])) d['packageDetailsId'] as String,
      };

      final connectionsFuture = _getByIds(_connectionsCollection, connectionIds);
      final packagesFuture = _getByIds(_packagesCollection, packageIds);
      final connections = await connectionsFuture;
      final packages = await packagesFuture;

      final rows = <AdminReportRowEntity>[];
      docs.forEach((id, d) {
        // Cancelled or deleted requests don't count towards any report.
        if (d['isCancel'] == true || d['isDelete'] == true) return;

        final requestDate = _toDate(d['requestDate']);
        if (requestDate == null) return;

        final hasPackage = _hasId(d['packageDetailsId']);
        final package = hasPackage
            ? (packages[d['packageDetailsId']] ?? const <String, dynamic>{})
            : const <String, dynamic>{};
        final connection = _hasId(d['connectionId'])
            ? (connections[d['connectionId']] ?? const <String, dynamic>{})
            : const <String, dynamic>{};

        final amount =
            _toDouble(d['amount']) ?? _toDouble(package['packagePrice']) ?? 0;
        if (amount <= 0) return;

        rows.add(
          AdminReportRowEntity(
            id: id,
            vendorId: _text(d['vendorId']),
            connectionId: _text(d['connectionId']),
            // Amount reloads have no package, so use the connection's provider.
            provider: _textOrNull(package['serviceProvider']) ??
                _textOrNull(connection['serviceProvider']) ??
                'Unknown',
            packageName: hasPackage
                ? (_textOrNull(package['packageName']) ?? 'Unknown')
                : _amountReloadLabel,
            requestDate: requestDate,
            amount: amount,
            isPaid: d['isPaid'] == true,
            commissionPercent: _toDouble(d['commissionPercent']),
          ),
        );
      });

      return AdminReportSourceEntity(
        rows: rows,
        vendorNames: {
          for (final v in vendors.docs)
            v.id: _textOrNull(v.data()['fullName']) ??
                _textOrNull(v.data()['email']) ??
                v.id,
        },
        vendorCount: vendors.docs.length,
        clientCount: clientCount,
        connectionCount: connectionCount,
        commissionPercent: _toDouble(settings.data()?[_commissionField]) ?? 0,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the report');
    }
  }

  /// Loads documents by id in chunks (Firestore `whereIn` allows 30 values).
  Future<Map<String, Map<String, dynamic>>> _getByIds(
    String collection,
    Set<String> ids,
  ) async {
    final list = ids.where((id) => id.trim().isNotEmpty).toList();
    if (list.isEmpty) return {};

    final futures = <Future<QuerySnapshot<Map<String, dynamic>>>>[];
    for (var i = 0; i < list.length; i += 30) {
      final end = i + 30 > list.length ? list.length : i + 30;
      futures.add(
        _db
            .collection(collection)
            .where(FieldPath.documentId, whereIn: list.sublist(i, end))
            .get(),
      );
    }
    final snaps = await Future.wait(futures);
    return {
      for (final s in snaps)
        for (final d in s.docs) d.id: d.data(),
    };
  }

  bool _hasId(dynamic v) => v is String && v.trim().isNotEmpty;

  String _text(dynamic v) => v is String ? v.trim() : '';

  String? _textOrNull(dynamic v) {
    final s = _text(v);
    return s.isEmpty ? null : s;
  }

  DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v);
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    return null;
  }

  double? _toDouble(dynamic v) => v is num ? v.toDouble() : null;
}
