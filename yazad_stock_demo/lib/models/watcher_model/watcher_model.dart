import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'watcher_model.g.dart';

List<WatcherModel> watcherModelFromJson(String str) => List<WatcherModel>.from(
  json.decode(str).map((x) => WatcherModel.fromJson(x)),
);

String watcherModelToJson(List<WatcherModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable(includeIfNull: false)
class WatcherModel {
  @JsonKey(name: "watchlist_name")
  String? watchlistName;
  @JsonKey(name: "symbol")
  String? symbol;
  @JsonKey(name: "exchange")
  String? exchange;
  @JsonKey(name: "type_key")
  String? typeKey;
  @JsonKey(name: "last_price")
  double? lastPrice;
  @JsonKey(name: "change")
  double? change;
  @JsonKey(name: "change_percent")
  double? changePercent;
  @JsonKey(name: "position")
  int? position;

  WatcherModel({
    this.watchlistName,
    this.symbol,
    this.exchange,
    this.typeKey,
    this.lastPrice,
    this.change,
    this.changePercent,
    this.position,
  });

  WatcherModel copyWith({
    String? watchlistName,
    String? symbol,
    String? exchange,
    String? typeKey,
    double? lastPrice,
    double? change,
    double? changePercent,
    int? position,
  }) => WatcherModel(
    watchlistName: watchlistName ?? this.watchlistName,
    position: position ?? this.position,
    symbol: symbol ?? this.symbol,
    exchange: exchange ?? this.exchange,
    typeKey: typeKey ?? this.typeKey,
    lastPrice: lastPrice ?? this.lastPrice,
    change: change ?? this.change,
    changePercent: changePercent ?? this.changePercent,
  );

  factory WatcherModel.fromJson(Map<String, dynamic> json) =>
      _$WatcherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WatcherModelToJson(this);

  @override
  String toString() {
    return 'WatcherModel(watchlistName: $watchlistName, symbol: $symbol, exchange: $exchange, typeKey: $typeKey, lastPrice: $lastPrice, change: $change, changePercent: $changePercent, position: $position)';
  }
}
