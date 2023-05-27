import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../error/exceptions.dart';
import '../util/app_constants.dart';

class HiveHelper {
  final HiveInterface hive;
  static const hiveDatabaseKey = AppConstants.app_local_db;

  HiveHelper({required this.hive});

  List<Map<String, dynamic>> getQueryLocalDataList(String queryTypeName) {
    List<Map<String, dynamic>> uniquelist = [];
    try {
      if (this.hive.isBoxOpen(hiveDatabaseKey)) {
        final localDatabase = this.hive.box(hiveDatabaseKey);
        if (localDatabase.values.isNotEmpty) {
          final Iterable<Map<String, dynamic>> mapIterable = localDatabase.values.whereType<Map<String, dynamic>>();
          final Iterable<Map<String, dynamic>> typeIterable = mapIterable.where((element) => element["__typename"] == queryTypeName);
          final Set<Map<String, dynamic>> seen = Set<Map<String, dynamic>>();
          uniquelist = typeIterable.where((account) => account != null && seen.add(account)).toList();
        }
      }
    } catch (e) {
      print("Exception getLocalData : $e");
      throw CacheException();
    }
    return uniquelist;
  }

  Future<void> setValue(String key, dynamic value) async {
    try {
      if (this.hive.isBoxOpen(hiveDatabaseKey)) {
        final localDatabase = this.hive.box(hiveDatabaseKey);
        await localDatabase.put(key, value);
      }
    } catch (e) {
      print("Exception set Hive Value : $e");
      throw CacheException();
    }
  }

  dynamic getValue(String key) {
    try {
      if (this.hive.isBoxOpen(AppConstants.app_local_db)) {
        final localDatabase = this.hive.box(AppConstants.app_local_db);
        final dynamic value = localDatabase.get(key);
        return value;
      }
    } catch (e) {
      print("Exception get Hive Value : $e");
      throw CacheException();
    }
  }
}
