part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeScreenState {}

class HomeLoadingState extends HomeScreenState {}

class HomeLoadedState extends HomeScreenState {
  final Map<String, List<WatcherModel>> data;
  final String selectedTab;
  final String query;

  const HomeLoadedState({
    required this.data,
    required this.selectedTab,
    required this.query,
  });

  HomeLoadedState copyWith({
    Map<String, List<WatcherModel>>? data,
    String? selectedTab,
    String? query,
  }) {
    return HomeLoadedState(
      data: data ?? this.data,
      selectedTab: selectedTab ?? this.selectedTab,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [data, selectedTab, query];
}

class HomeNoInternetState extends HomeScreenState {
  final String message;

  const HomeNoInternetState(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeErrorState extends HomeScreenState {
  final String message;

  const HomeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
