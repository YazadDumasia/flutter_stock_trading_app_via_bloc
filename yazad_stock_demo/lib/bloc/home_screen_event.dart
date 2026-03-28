part of 'home_screen_bloc.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();
}

final class HomeScreenRequested extends HomeScreenEvent {
  @override
  List<Object?> get props => [];
}

final class HomeScreenTabChanged extends HomeScreenEvent {
  final String tab;

  const HomeScreenTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

final class HomeScreenSearchChanged extends HomeScreenEvent {
  final String query;

  const HomeScreenSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

final class HomeScreenReordered extends HomeScreenEvent {
  final String tab;
  final int oldIndex;
  final int newIndex;

  const HomeScreenReordered({
    required this.tab,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [tab, oldIndex, newIndex];
}

final class WatchlistOrderSaved extends HomeScreenEvent {
  final String tab;
  final List<WatcherModel> items;
  final String? newName;

  const WatchlistOrderSaved({
    required this.tab,
    required this.items,
    this.newName,
  });

  @override
  List<Object?> get props => [tab, items, newName];
}

final class _RealtimeUpdateEvent extends HomeScreenEvent {
  final Map<String, List<WatcherModel>> grouped;

  const _RealtimeUpdateEvent(this.grouped);

  @override
  List<Object?> get props => [grouped];
}

final class _NoInternetEvent extends HomeScreenEvent {
  @override
  List<Object?> get props => [];
}
