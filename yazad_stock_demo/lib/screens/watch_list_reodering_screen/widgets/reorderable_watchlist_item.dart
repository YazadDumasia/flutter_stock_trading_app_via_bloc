import 'package:flutter/material.dart';
import '../../../models/watcher_model/watcher_model.dart';

class ReorderableWatchlistItem extends StatelessWidget {
  final WatcherModel item;

  const ReorderableWatchlistItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.drag_handle, color: Colors.grey),
        title: Text(
          item.symbol ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.exchange ?? ''),
        tileColor: Colors.white,
      ),
    );
  }
}
