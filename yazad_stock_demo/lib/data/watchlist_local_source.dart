// realtime_service.dart
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../models/watcher_model/watcher_model.dart';

class RealtimeService {
  final _rand = Random();

  Stream<List<WatcherModel>> priceStream(List<WatcherModel> base) {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return base.map((item) {
        final delta = (_rand.nextDouble() - 0.5) * 8;

        final newPrice = (item.lastPrice ?? 0) + delta;
        final newChange = (item.change ?? 0) + delta;
        final newPercent = ((newChange) / (newPrice - newChange)) * 100;

        return item.copyWith(
          lastPrice: newPrice,
          change: newChange,
          changePercent: newPercent,
        );
      }).toList();
    });
  }

  Stream<bool> connectionStream() {
    return InternetConnection().onStatusChange
        .map((s) => s == InternetStatus.connected)
        .startWith(true);
  }

  Stream<List<WatcherModel>> combined(List<WatcherModel> base) {
    return Rx.combineLatest2<List<WatcherModel>, bool, List<WatcherModel>>(
      priceStream(base),
      connectionStream(),
      (prices, isConnected) => isConnected ? prices : base,
    ).throttleTime(const Duration(milliseconds: 500));
  }
}
