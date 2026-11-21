import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_reload_system_admin/src/core/error/exceptions.dart';
import 'package:smart_reload_system_admin/src/core/services/encryption.service.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/data/model/bank_details.model.dart';
import 'package:smart_reload_system_admin/src/feature/wallet/domain/entity/commission_withdrew_history.entity.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';

abstract class WalletRemoteDataSource {
  Future<double> getWalletSummary();
  Future<List<ComWithdrawHistoryEntity>> getHistory();
  Future<bool> addWithdrawal({required double withdrewAmount, required double totalAmount, required String bankId});
  Future<List<BankDetailsModel>> getVendorBankInfo();
  Future<BankDetailsModel> addNewBankInfo({required BankDetailsModel bankDetails});
  Future<bool> removeBankInfo({required String bankDetailsId});
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  WalletRemoteDataSourceImpl({required this.firestore, required this.firebaseAuth});

  @override
  Future<double> getWalletSummary() async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ServerException('User not authenticated');
      }

      final commissionSnapshot = await firestore
          .collection('commission')
          .where('vendorId', isEqualTo: userId)
          .limit(1)
          .get();

      double totalCommission = 0.0;
      if (commissionSnapshot.docs.isNotEmpty) {
        final commissionData = commissionSnapshot.docs.first.data();
        totalCommission = (commissionData['comAmount'] as num?)?.toDouble() ?? 0.0;
      }

      // totalCommission
      return totalCommission;
    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'WalletRemoteDataSourceImpl.getWalletSummary',
        stackTrace: st,
      );
      throw ServerException('Failed to fetch wallet summary');
    } catch (e, st) {
      errorLog(
        e,
        location: 'WalletRemoteDataSourceImpl.getWalletSummary',
        stackTrace: st,
      );
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Unable to load wallet summary');
    }
  }

  @override
  Future<List<ComWithdrawHistoryEntity>> getHistory() async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ServerException('User not authenticated');
      }

      final snapshot = await firestore
          .collection('commission_withdrew_history')
          .where('vendorId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();


      return snapshot.docs.map((doc) => ComWithdrawHistoryEntity.fromFirestore (doc)).toList();
    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'WalletRemoteDataSourceImpl.getHistory',
        stackTrace: st,
      );
      throw ServerException('Failed to fetch withdrawal history');
    } catch (e, st) {
      errorLog(
        e,
        location: 'WalletRemoteDataSourceImpl.getHistory',
        stackTrace: st,
      );
      if (e is ServerException) rethrow;
      throw ServerException('Unable to load withdrawal history');
    }
  }

  @override
  Future<bool> addWithdrawal({required double withdrewAmount, required double totalAmount, required String bankId}) async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ServerException('User not authenticated');
      }

      await firestore.collection('commission_withdrew_history').add({
        'vendorId': userId,
        'withdrewAmount': withdrewAmount,
        'totalAmount': totalAmount,
        'date': Timestamp.fromDate(DateTime.now()),
        'bankId': bankId,
      });

      final query = await firestore
          .collection('commission')
          .where('vendorId', isEqualTo: userId)
          .get();

      for (final doc in query.docs) {
        await doc.reference.update({
          'comAmount': 0.0,
          'modifyDate': FieldValue.serverTimestamp(),
        });
      }

      return true;
    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'WalletRemoteDataSourceImpl.addWithdrawal',
        stackTrace: st,
      );
      throw ServerException('Failed to add withdrawal record');
    } catch (e, st) {
      errorLog(
        e,
        location: 'WalletRemoteDataSourceImpl.addWithdrawal',
        stackTrace: st,
      );
      if (e is ServerException) rethrow;
      throw ServerException('Unable to submit withdrawal');
    }
  }

  @override
  Future<List<BankDetailsModel>> getVendorBankInfo() async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ServerException('User not authenticated');
      }

      final snapshot = await firestore
          .collection('vendor_bank_info')
          .where('vendorId', isEqualTo: userId)
          .where('isDeleted', isEqualTo: false)
          .get();

      final bankInfoList = <BankDetailsModel>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final encBankData = await EncryptionService().decryptData(data['data']);
        final bankData = BankDetailsModel.fromJson(encBankData, id: doc.id);
        bankInfoList.add(bankData);
      }

      return bankInfoList;
    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'ManageRemoteDataSourceImpl.getVendorBankInfo',
        stackTrace: st,
      );
      throw ServerException('Failed to fetch vendor bank info');
    } catch (e, st) {
      errorLog(
        e,
        location: 'ManageRemoteDataSourceImpl.getVendorBankInfo',
        stackTrace: st,
      );
      if (e is ServerException) rethrow;
      throw ServerException('Unable to load vendor bank info');
    }
  }

  @override
  Future<BankDetailsModel> addNewBankInfo({required BankDetailsModel bankDetails}) async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ServerException('User not authenticated');
      }
      final encryptionService = EncryptionService();
      final data = await encryptionService.encryptData(bankDetails.toJson());

      final docRef = await firestore.collection('vendor_bank_info').add(
          {
            "vendorId": userId,
            "data" : data,
            "updatedAt": FieldValue.serverTimestamp(),
            "isDeleted": false,
          }
      );
      return bankDetails.copyWith(id: docRef.id);
    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'ManageRemoteDataSourceImpl.addNewBankInfo',
        stackTrace: st,
      );
      throw ServerException('Failed to create bank info');
    } catch (e, st) {
      errorLog(
        e,
        location: 'ManageRemoteDataSourceImpl.addNewBankInfo',
        stackTrace: st,
      );
      if (e is ServerException) rethrow;
      throw ServerException('Unable to create bank info');
    }
  }

  @override
  Future<bool> removeBankInfo({required String bankDetailsId}) async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ServerException('User not authenticated');
      }

      await firestore.collection('vendor_bank_info').doc(bankDetailsId).update({
        'isDeleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } on FirebaseException catch (e, st) {
      errorLog(
        e,
        location: 'ManageRemoteDataSourceImpl.removeBankInfo',
        stackTrace: st,
      );
      throw ServerException('Failed to remove bank info');
    } catch (e, st) {
      errorLog(
        e,
        location: 'ManageRemoteDataSourceImpl.removeBankInfo',
        stackTrace: st,
      );
      if (e is ServerException) rethrow;
      throw ServerException('Unable to remove bank info');
    }
  }
}
