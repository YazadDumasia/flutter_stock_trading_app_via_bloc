import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yazad_stock_demo/screens/home_screen/widgets/sort_slider_icon_icons.dart';
import '../../../bloc/home_screen_bloc.dart';
import '../../../models/watcher_model/watcher_model.dart';
import 'watchlist_item.dart';

class WatchlistContent extends StatelessWidget {
  const WatchlistContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      buildWhen: (previous, current) {
        // Only rebuild if the data or selected tab actually changed
        if (previous is HomeLoadedState && current is HomeLoadedState) {
          return previous.data != current.data || previous.selectedTab != current.selectedTab;
        }
        return true;
      },
      builder: (context, state) {
        if (state is HomeLoadingState || state is HomeInitialState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is HomeNoInternetState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(state.message, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeScreenBloc>().add(HomeScreenRequested());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is HomeLoadedState) {
          final tabs = state.data.keys.toList();
          if (tabs.isEmpty) {
            return const Center(child: Text('No watchlist available'));
          }

          final initialIndex = tabs.indexOf(state.selectedTab).clamp(0, tabs.length - 1);

          return DefaultTabController(
            key: ValueKey(tabs.join(',')), // Recreate controller only if tabs change
            length: tabs.length,
            initialIndex: initialIndex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  labelColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  unselectedLabelColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                  onTap: (index) {
                    context.read<HomeScreenBloc>().add(
                          HomeScreenTabChanged(tabs[index]),
                        );
                  },
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: tabs.map((tab) {
                      return WatchlistTabContent(
                        tabName: tab,
                        items: state.data[tab] ?? [],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class WatchlistTabContent extends StatelessWidget {
  final String tabName;
  final List<WatcherModel> items;

  const WatchlistTabContent({
    super.key,
    required this.tabName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No stocks found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeScreenBloc>().add(HomeScreenRequested());
      },
      child: CustomScrollView(
        key: PageStorageKey<String>(tabName),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      SortSliderIcon.settings_sliders,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Sort by',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () async {
                      await context.pushNamed(
                        'reorder',
                        pathParameters: {'tabName': tabName},
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return WatchlistItem(stock: items[index]);
                },
                childCount: items.length,
                addAutomaticKeepAlives: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
