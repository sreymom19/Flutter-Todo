import 'package:flutter/material.dart';
import 'package:my_flutter_todo/database_helper.dart';
import 'package:my_flutter_todo/models/task.dart';
import 'package:my_flutter_todo/models/todo.dart';
import 'package:my_flutter_todo/screens/homepages.dart';
import 'package:my_flutter_todo/screens/widgets.dart';

class TaskPage extends StatefulWidget {
  // final Int task; // this is your old code
  final Task? task; // thisis what i have changed
  const TaskPage({required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper dbHelper = DatabaseHelper();

  int _taskID = 0;
  String _taskTitle = "";

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
//set visibility = true
      _contentVisible = true;

      _taskTitle = "${widget.task?.title}";
      _taskID = widget.task?.id ?? 0;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus?.dispose();
    _descriptionFocus?.dispose();
    _todoFocus?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 6.0,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image.asset('assets/images/arrow.png'),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _titleFocus,
                          onSubmitted: (value) async {
                            //Check if the field if not empty
                            if (value != "") {
                              //Check if the task is null
                              if (widget.task == null) {
                                Task newTask = Task(title: value);
                                _taskID = await dbHelper.insertTask(newTask);
                                setState(() {
                                  _contentVisible = true;
                                  _taskTitle = value;
                                });
                              } else {
                                await dbHelper.updateTaskTitle(_taskID, value);
                                print("Task Update");
                              }
                              _descriptionFocus?.requestFocus();
                            }
                          },
                          controller: TextEditingController()
                            ..text = _taskTitle,
                          decoration: const InputDecoration(
                            hintText: "Enter Task Title",
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff211551),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                    ),
                    child: TextField(
                      focusNode: _descriptionFocus,
                      onSubmitted: (value) {
                        _todoFocus?.requestFocus();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Description for the task...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: FutureBuilder<List<Todo>>(
                    initialData: const [],
                    future: dbHelper.getTodo(_taskID),
                    builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
                      final List<Todo>? todo = snapshot.data;
                      print("length: ${todo?.length}");
                      return Expanded(
                        child: ListView.builder(
                          itemCount: todo?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: TodoWidgets(
                                  title: snapshot.data![index].title,
                                  isDone: snapshot.data![index].isDone == 0
                                      ? false
                                      : true),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          margin: const EdgeInsets.only(
                            right: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                                color: const Color(0xff86829d), width: 1.5),
                          ),
                          child: Image.asset('assets/images/tick.png'),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: (String? value) async {
                              //Check if the field if not empty
                              if (value != "") {
                                //Check if the task is null
                                if (widget.task != null) {
                                  DatabaseHelper dbHelper = DatabaseHelper();

                                  Todo newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskID: widget.task?.id,
                                  );
                                  await dbHelper.insertTodo(newTodo);
                                  setState(() {});
                                } else {
                                  print("Task doesn't exsit");
                                }
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter todo item",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: _contentVisible,
              child: Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: const Color(0xfffe3577)),
                    child: Image.asset('assets/images/delete.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
