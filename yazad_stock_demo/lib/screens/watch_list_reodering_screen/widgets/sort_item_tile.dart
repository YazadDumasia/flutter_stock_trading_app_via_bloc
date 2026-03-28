import 'package:flutter/material.dart';
import '../../../models/watcher_model/watcher_model.dart';

class SortItemTile extends StatelessWidget {
  final WatcherModel item;
  final int index;
  final VoidCallback? onDelete;

  const SortItemTile({
    super.key,
    required this.item,
    required this.index,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle, color: Colors.grey),
          ),
        ),
        title: Text(
          item.symbol ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.black),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
