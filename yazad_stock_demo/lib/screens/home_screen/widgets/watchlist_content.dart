import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yazad_stock_demo/screens/home_screen/widgets/sort_slider_icon_icons.dart';
import '../../../bloc/home_screen_bloc.dart';
import 'watchlist_item.dart';

class WatchlistContent extends StatelessWidget {
  const WatchlistContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
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

          return DefaultTabController(
            length: tabs.length,
            initialIndex: tabs
                .indexOf(state.selectedTab)
                .clamp(0, tabs.length - 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor:  Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  labelColor:  Theme.of(context).brightness == Brightness.light
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
                    // Managed by bloc sync
                    children: tabs.map((tab) {
                      final items = state.data[tab] ?? [];
                      if (items.isEmpty) {
                        return const Center(child: Text('No stocks found'));
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenRequested(),
                          );
                        },
                        child: SingleChildScrollView(
                          primary: true,
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
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
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ), // Adjust the radius as needed
                                        ),
                                      ),
                                      onPressed: () async {
                                        await context.pushNamed(
                                          'reorder',
                                          pathParameters: {'tabName': tab},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return WatchlistItem(stock: items[index]);
                                },
                              ),
                            ],
                          ),
                        ),
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
