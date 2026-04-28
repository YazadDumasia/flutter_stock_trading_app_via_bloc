import 'package:flutter/material.dart';
import 'package:yazad_stock_demo/utils/extensions.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/watchlist_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        title: const Text(
          'Stocks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          HomeHeaderWidget(),
          HomeSearchBar(),
          Expanded(child: WatchlistContent()),
        ],
      ),
    );
  }
}
