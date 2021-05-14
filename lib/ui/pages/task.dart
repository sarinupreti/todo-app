import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu_todo/non_ui/provider/tasks.dart';
import 'package:withu_todo/non_ui/jsonclasses/task.dart';
import 'package:withu_todo/non_ui/utils.dart';

class TaskPage extends StatelessWidget {
  TaskPage({this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'New Task' : 'Edit Task'),
      ),
      body: _TaskForm(task),
    );
  }
}

class _TaskForm extends StatefulWidget {
  _TaskForm(this.task);

  final Task task;
  @override
  __TaskFormState createState() => __TaskFormState(task);
}

class __TaskFormState extends State<_TaskForm> {
  static const double _padding = 16;

  __TaskFormState(this.task);

  Task task;
  TextEditingController _titleController;
  TextEditingController _descriptionController;

  final _formKey = GlobalKey<FormState>();

  void init() {
    if (task == null) {
      task = Task();
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    } else {
      _titleController = TextEditingController(text: task.title);
      _descriptionController = TextEditingController(text: task.description);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void _save(BuildContext context) {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      final provider = Provider.of<TaskProvider>(context, listen: false);

      if (widget.task == null) {
        final data = task.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        );

        provider.addATask(data);

        // Utlis.showSnackbar(context, "Added task successful");
      } else {
        provider.updateTask(widget.task, _titleController.text.trim(),
            _descriptionController.text.trim());

        // Utlis.showSnackbar(context, "Update task successful");
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(_padding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoFormSection(
                backgroundColor: CupertinoColors.extraLightBackgroundGray,
                children: <Widget>[
                  CupertinoTextFormFieldRow(
                    prefix: Text(
                      "Title : ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    controller: _titleController,
                    style: Theme.of(context).textTheme.subtitle2,
                    placeholder: 'Enter a title',
                    enableInteractiveSelection: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please, enter your tiltle for task.';
                      }

                      return null;
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: Text(
                      "Description : ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    controller: _descriptionController,
                    expands: true,
                    maxLines: null,
                    style: Theme.of(context).textTheme.subtitle2,
                    minLines: null,
                    placeholder: 'Enter a description',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please, enter your description for task.';
                      }

                      return null;
                    },
                  ),
                  CupertinoFormRow(
                    prefix: Text(
                      'Completed',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    child: CupertinoSwitch(
                      value: task.isCompleted,
                      onChanged: (_) {
                        setState(() {
                          task.toggleComplete();
                        });
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _save(context),
                child: Container(
                  width: double.infinity,
                  child: Center(child: Text(task.isNew ? 'Create' : 'Update')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
