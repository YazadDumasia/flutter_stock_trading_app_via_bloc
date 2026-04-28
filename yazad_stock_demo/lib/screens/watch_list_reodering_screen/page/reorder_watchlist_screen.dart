import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/home_screen_bloc.dart';
import '../../../models/watcher_model/watcher_model.dart';
import '../widgets/dragging_decorator.dart';
import '../widgets/sort_item_tile.dart';

class WatchlistReorderScreen extends StatefulWidget {
  final String tabName;

  const WatchlistReorderScreen({super.key, required this.tabName});

  @override
  State<WatchlistReorderScreen> createState() => _WatchlistReorderScreenState();
}

class _WatchlistReorderScreenState extends State<WatchlistReorderScreen> {
  List<WatcherModel>? _localItems;
  late TextEditingController _nameController;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tabName);
    final state = context.read<HomeScreenBloc>().state;
    if (state is HomeLoadedState) {
      _localItems = List<WatcherModel>.from(state.data[widget.tabName] ?? []);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showOtherWatchlistsDialog() {
    final state = context.read<HomeScreenBloc>().state;
    if (state is! HomeLoadedState) return;

    final otherTabs = state.data.keys.toList();
    String selectedTab = widget.tabName;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Theme(
              data: Theme.of(context),
              child: AlertDialog(
                title: const Text('Select Watchlist'),
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: otherTabs.map((tab) {
                    return RadioListTile<String>(
                      title: Text(tab),
                      value: tab,
                      activeColor: Colors.black,
                      hoverColor: Colors.grey,
                      groupValue: selectedTab,
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedTab = value);
                        }
                      },
                    );
                  }).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (selectedTab != widget.tabName) {
                        context.pushReplacementNamed(
                          'reorder',
                          pathParameters: {'tabName': selectedTab},
                        );
                      }
                    },
                    child: Text(
                      'OK',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_localItems == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit ${widget.tabName}',
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _isEditingName
                      ? TextField(
                          controller: _nameController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(),
                          ),
                          onSubmitted: (_) =>
                              setState(() => _isEditingName = false),
                        )
                      : Text(
                          _nameController.text,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                  onPressed: () {
                    setState(() {
                      _isEditingName = !_isEditingName;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              proxyDecorator: (child, index, animation) =>
                  DraggingDecorator(animation: animation, child: child),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = _localItems!.removeAt(oldIndex);
                  _localItems!.insert(newIndex, item);
                });
              },
              itemCount: _localItems!.length,
              itemBuilder: (context, index) {
                final item = _localItems![index];
                return SortItemTile(
                  key: ValueKey('reorder_${item.symbol}_$index'),
                  item: item,
                  index: index,
                  onDelete: () {
                    setState(() {
                      _localItems!.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: _showOtherWatchlistsDialog,
                  style:
                      OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        overlayColor: Colors.black26,
                      ),
                  child: const Text(
                    'Edit other watchlists',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeScreenBloc>().add(
                      WatchlistOrderSaved(
                        tab: widget.tabName,
                        items: _localItems!,
                        newName: _nameController.text,
                      ),
                    );
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Watchlist'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
