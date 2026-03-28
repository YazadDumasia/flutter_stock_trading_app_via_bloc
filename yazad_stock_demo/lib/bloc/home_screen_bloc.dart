import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../service/realtime_service.dart';
import '../models/watcher_model/watcher_model.dart';
import 'package:equatable/equatable.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc()
    : _source = WatchlistLocalSource(),
      _connection = InternetConnection(),
      super(HomeInitialState()) {
    on<HomeScreenRequested>(_onFetch);
    on<HomeScreenTabChanged>(_onTabChange);
    on<HomeScreenSearchChanged>(_onSearch);
    on<HomeScreenReordered>(_onReorder);
    on<WatchlistOrderSaved>(_onSaveOrder);
    on<_RealtimeUpdateEvent>(_onRealtime);
    on<_NoInternetEvent>(_onNoInternet);

    _listenInternet();
  }

  final WatchlistLocalSource _source;
  final InternetConnection _connection;

  StreamSubscription? _connSub;
  StreamSubscription? _priceSub;

  final _rand = Random();

  Map<String, List<WatcherModel>> _cache = {};

  void _listenInternet() {
    _connSub = _connection.onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected) {
        add(_NoInternetEvent());
      } else {
        add(HomeScreenRequested());
      }
    });
  }

  Future<void> _onFetch(
    HomeScreenRequested event,
    Emitter<HomeScreenState> emit,
  ) async {
    final hasNet = await _connection.hasInternetAccess;

    if (!hasNet) {
      emit(const HomeNoInternetState("No Internet"));
      return;
    }

    try {
      emit(HomeLoadingState());

      final list = await _source.fetch();

      _cache = _group(list);

      emit(
        HomeLoadedState(
          data: _cache,
          selectedTab: _cache.keys.first,
          query: '',
        ),
      );

      _startRealtime(list);
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void _onTabChange(HomeScreenTabChanged event, Emitter<HomeScreenState> emit) {
    final current = state;

    if (current is HomeLoadedState) {
      emit(current.copyWith(selectedTab: event.tab));
    }
  }

  void _onSearch(HomeScreenSearchChanged event, Emitter<HomeScreenState> emit) {
    final current = state;

    if (current is HomeLoadedState) {
      final filtered = _filter(event.query, _cache);

      emit(current.copyWith(data: filtered, query: event.query));
    }
  }

  void _onReorder(
    HomeScreenReordered event,
    Emitter<HomeScreenState> emit,
  ) {
    final current = state;
    if (current is HomeLoadedState) {
      final tabItems = List<WatcherModel>.from(_cache[event.tab] ?? []);
      if (tabItems.isEmpty) return;

      int oldIndex = event.oldIndex;
      int newIndex = event.newIndex;

      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = tabItems.removeAt(oldIndex);
      tabItems.insert(newIndex, item);

      _cache[event.tab] = tabItems;

      final filtered = _filter(current.query, _cache);
      emit(current.copyWith(data: filtered));
    }
  }

  Future<void> _onSaveOrder(
    WatchlistOrderSaved event,
    Emitter<HomeScreenState> emit,
  ) async {
    final currentName = event.tab;
    final newName = event.newName ?? currentName;
    final items = event.items;

    // Update items with the new watchlist name if it changed
    final updatedItems = items.map((e) => e.copyWith(watchlistName: newName)).toList();

    if (newName != currentName) {
      _cache.remove(currentName);
    }
    _cache[newName] = updatedItems;

    // Flatten cache to save
    final allItems = _cache.values.expand((e) => e).toList();
    await _source.save(allItems);

    final current = state;
    if (current is HomeLoadedState) {
      final selectedTab = current.selectedTab == currentName ? newName : current.selectedTab;
      final filtered = _filter(current.query, _cache);
      emit(current.copyWith(data: filtered, selectedTab: selectedTab));
    }
  }

  void _startRealtime(List<WatcherModel> base) {
    _priceSub?.cancel();

    final stream = Stream.periodic(const Duration(seconds: 1), (_) {
      final currentList = _cache.values.expand((e) => e).toList();
      return currentList.map((item) {
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

    _priceSub = stream.throttleTime(const Duration(milliseconds: 500)).listen((
      updated,
    ) {
      final grouped = _group(updated);
      add(_RealtimeUpdateEvent(grouped));
    });
  }

  void _onRealtime(_RealtimeUpdateEvent event, Emitter<HomeScreenState> emit) {
    final current = state;

    if (current is HomeLoadedState) {
      _cache = event.grouped;

      final filtered = _filter(current.query, _cache);

      emit(current.copyWith(data: filtered));
    }
  }

  void _onNoInternet(_NoInternetEvent event, Emitter<HomeScreenState> emit) {
    emit(const HomeNoInternetState("No Internet"));
  }

  Map<String, List<WatcherModel>> _group(List<WatcherModel> list) {
    final map = <String, List<WatcherModel>>{};
    for (final item in list) {
      final key = item.watchlistName ?? "Others";
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  Map<String, List<WatcherModel>> _filter(
    String query,
    Map<String, List<WatcherModel>> src,
  ) {
    if (query.isEmpty) return src;

    final q = query.toLowerCase();

    return src.map((k, v) {
      return MapEntry(
        k,
        v.where((e) => (e.symbol ?? '').toLowerCase().contains(q)).toList(),
      );
    });
  }

  @override
  Future<void> close() async {
    await _connSub?.cancel();
    await _priceSub?.cancel();
    return super.close();
  }
}
