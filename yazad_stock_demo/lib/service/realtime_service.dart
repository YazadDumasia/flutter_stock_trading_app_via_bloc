import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gen/assets.gen.dart';
import '../models/watcher_model/watcher_model.dart';

class WatchlistLocalSource {
  static const String _watchlistKey = 'watchlist_data';

  Future<List<WatcherModel>> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_watchlistKey);

    if (savedData != null) {
      return watcherModelFromJson(savedData);
    }

    // Fallback to dummy data if nothing is saved in preferences
    final data = await rootBundle.loadString(Assets.data.dummyData);
    final list = watcherModelFromJson(data);
    await save(list); // Save initial dummy data to preferences
    return list;
  }

  Future<void> save(List<WatcherModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = watcherModelToJson(list);
    await prefs.setString(_watchlistKey, jsonString);
  }
}
