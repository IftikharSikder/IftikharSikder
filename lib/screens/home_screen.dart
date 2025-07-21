import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hive_ce_test/models/task_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final taskManager = Hive.box("Task Manager");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: taskManager.listenable(),
        builder: (context, box, _) {
          return box.isEmpty
              ? Center(child: Text("No task available"))
              : ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final task = box.getAt(index);
                    int indexNo = index + 1;
                    return ListTile(
                      leading: CircleAvatar(child: Text(indexNo.toString())),
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              addTask(
                                context,
                                index,
                                task.title,
                                task.description,
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              final key = taskManager.keyAt(index);
                              taskManager.delete(key);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTask(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

addTask(
  BuildContext context, [
  int? index,
  String? title,
  String? description,
]) {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  if (title != null && description != null) {
    titleController.text = title;
    descriptionController.text = description;
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add New Task'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: ListBody(
              children: [
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter title";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter description";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              titleController.clear();
              descriptionController.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final taskManager = Hive.box("Task Manager");
                if (index != null && title != null && description != null) {
                  final box = TaskManager(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  taskManager.putAt(index!, box);
                } else if (index == null &&
                    title == null &&
                    description == null) {
                  final box = TaskManager(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  taskManager.add(box);
                }
                index = null;
                title = null;
                description = null;
                titleController.clear();
                descriptionController.clear();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
