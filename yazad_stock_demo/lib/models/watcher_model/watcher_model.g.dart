// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watcher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatcherModel _$WatcherModelFromJson(Map<String, dynamic> json) => WatcherModel(
  watchlistName: json['watchlist_name'] as String?,
  symbol: json['symbol'] as String?,
  exchange: json['exchange'] as String?,
  typeKey: json['type_key'] as String?,
  lastPrice: (json['last_price'] as num?)?.toDouble(),
  change: (json['change'] as num?)?.toDouble(),
  changePercent: (json['change_percent'] as num?)?.toDouble(),
  position: (json['position'] as num?)?.toInt(),
);

Map<String, dynamic> _$WatcherModelToJson(WatcherModel instance) =>
    <String, dynamic>{
      'watchlist_name': ?instance.watchlistName,
      'symbol': ?instance.symbol,
      'exchange': ?instance.exchange,
      'type_key': ?instance.typeKey,
      'last_price': ?instance.lastPrice,
      'change': ?instance.change,
      'change_percent': ?instance.changePercent,
      'position': ?instance.position,
    };
