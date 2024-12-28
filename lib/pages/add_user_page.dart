import 'package:flutter/material.dart';
import 'package:rest_api/services/services.dart';
import 'package:rest_api/utils/snackbar_helper.dart';
import '../models/user.dart';

const List<String> genders = ['male', 'female'];
const List<String> statuses = ['active', 'inactive'];

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key, this.user});

  final User? user;

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String gender = genders.first;
  String status = statuses.first;
  bool isEdit = false;

  Future<void> updateData() async {
    try {
      final id = widget.user!.id;
      final isSuccess = await UsersService.updateUser(id!, user);

      if (isSuccess) {
        if (!mounted) return;
        showSnackBar(context, message: 'Updated Successfully');
      }
    } catch (e) {
      showSnackBar(context, message: 'Updating Failed');
    }
  }

  Future<void> submitData() async {
    try {
      final isSuccess = await UsersService.addUser(user);

      if (isSuccess) {
        if (!mounted) return;
        showSnackBar(context, message: 'Added Successfully');
      }
    } catch (e) {
      showSnackBar(context, message: 'Creation Failed');
    }
  }

  User get user => User(
        name: nameController.text,
        email: emailController.text,
        gender: gender,
        status: status,
      );

  @override
  void initState() {
    super.initState();

    final user = widget.user;
    if (user != null) {
      isEdit = true;
      nameController.text = user.name;
      emailController.text = user.email;
      gender = user.gender;
      status = user.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Full Name'),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          const SizedBox(height: 20.0),
          DropdownButton<String>(
            hint: const Text('Gender'),
            value: gender,
            icon: const Icon(Icons.arrow_downward),
            iconEnabledColor: Colors.lightBlueAccent,
            isExpanded: true,
            onChanged: (gender) {
              setState(() {
                this.gender = gender!;
              });
            },
            items: genders.map<DropdownMenuItem<String>>((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
          ),
          const SizedBox(height: 20.0),
          DropdownButton<String>(
            value: status,
            hint: const Text('Status'),
            icon: const Icon(Icons.arrow_downward),
            iconEnabledColor: Colors.lightBlueAccent,
            isExpanded: true,
            onChanged: (status) {
              setState(() {
                this.status = status!;
              });
            },
            items: statuses.map<DropdownMenuItem<String>>((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              );
            }).toList(),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          )
        ],
      ),
    );
  }
}
