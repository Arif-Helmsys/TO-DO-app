import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/custom_search_delegate.dart';
import 'package:to_do_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTastk;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTastk = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: GestureDetector(
          onTap: () => _showAddTaskBottomSheet(),
          child: const Text(
            "Bugün Neler Yapacaksın?",
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => _showSearchPage(),
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () => _showAddTaskBottomSheet(),
              icon: const Icon(Icons.add))
        ],
      ),
      body: _allTastk.isNotEmpty
          ? ListView.builder(
              itemCount: _allTastk.length,
              itemBuilder: (context, index) {
                var oankiListeElemani = _allTastk[index];
                return Dismissible(
                  background: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  key: Key(oankiListeElemani.id),
                  onDismissed: (direction) {
                    _allTastk.removeAt(index);
                    _localStorage.deleteTask(task: oankiListeElemani);
                    setState(() {});
                  },
                  child: TaskItem(task: oankiListeElemani),
                );
              },
            )
          : Center(
              child: Text("Görev Ekle!",
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                  hintText: "Görev Nedir?", border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length >= 3) {
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev =
                          Task.create(name: value, createdAt: time);

                      // _allTastk.add(yeniEklenecekGorev);
                      _allTastk.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _getAllTaskFromDb() async {
    _allTastk = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTastk));
    _getAllTaskFromDb();
  }
}
