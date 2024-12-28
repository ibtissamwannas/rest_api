import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rest_api/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/user_card.dart';
import 'add_user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final users = await UsersService.getUsers();
      final preferences = await SharedPreferences.getInstance();
      if (users == null) return;

      final json = jsonEncode(users);
      preferences.setString('users', json);

      setState(() {
        this.users = users;
        isLoading = false;
      });
    } on SocketException catch (_) {
      showSnackBar(context, message: 'No internet connection');
      fetchCachedUsers();
    }
  }

  Future<void> fetchCachedUsers() async {
    final preferences = await SharedPreferences.getInstance();
    final json = jsonDecode(preferences.getString('users')!);
    final users = json.map((json) => User.fromJson(json)).toList();

    setState(() {
      this.users = users;
      isLoading = false;
    });
  }

  Future<void> navigateToAddUserPage() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddUserPage(),
    ));

    setState(() {
      isLoading = true;
    });
    fetchUsers();
  }

  Future<void> navigateToEditUserPage(User user) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddUserPage(user: user),
    ));

    setState(() {
      isLoading = true;
    });
    fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    try {
      final isSuccess = await UsersService.deleteUser(id);

      if (isSuccess) {
        setState(() {
          users.removeWhere((user) => user.id == id);
        });
      }
    } catch (_) {
      showSnackBar(context, message: 'Deletion Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Users List')),
      ),
      body: buildUsers(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddUserPage,
        label: const Text('Add User'),
      ),
    );
  }

  Widget buildUsers() {
    print(users.length);
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (users.isEmpty) {
      return Center(
        child: Text(
          'No Users Found',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: users.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final user = users[index];
          return UserCard(
            index: index,
            user: user,
            onUserEdited: navigateToEditUserPage,
            onDeletedById: deleteUser,
          );
        },
      );
    }
  }
}
