import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _taskNameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10)
          ]),
      child: ListTile(
        leading: GestureDetector(
            onTap: () {
              widget.task.isCompleted = !widget.task.isCompleted;
              _localStorage.updateTask(task: widget.task);
              setState(() {});
            },
            child: Container(
              // ignore: sort_child_properties_last
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                  color: widget.task.isCompleted ? Colors.green : Colors.white,
                  border: Border.all(color: Colors.black, width: 0.8),
                  shape: BoxShape.circle),
            )),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                maxLines: null,
                controller: _taskNameController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (yeniDeger) {
                  if (yeniDeger.length >= 3) {
                    widget.task.name = yeniDeger;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat("hh:mm a").format(widget.task.createdAt),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
