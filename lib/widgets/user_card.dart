import 'package:flutter/material.dart';
import '../models/user.dart';

enum PopupAction { edit, delete }

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.index,
    required this.user,
    required this.onUserEdited,
    required this.onDeletedById,
  });

  final int index;
  final User user;
  final ValueChanged<User> onUserEdited;
  final ValueChanged<int> onDeletedById;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == PopupAction.edit) {
              onUserEdited(user);
            } else if (value == PopupAction.delete) {
              onDeletedById(user.id!);
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: PopupAction.edit,
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              ),
              const PopupMenuItem(
                value: PopupAction.delete,
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}
