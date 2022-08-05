import 'package:flutter/material.dart';
import 'package:my_flutter_todo/database_helper.dart';
import 'package:my_flutter_todo/models/task.dart';
import 'package:my_flutter_todo/screens/taskpage.dart';
import 'package:my_flutter_todo/screens/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          color: const Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 32.0,
                      top: 32.0,
                    ),
                    child: Image.asset('assets/images/mobile_logo.png'),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _databaseHelper.getTasks(),
                      builder: ((BuildContext context,
                          AsyncSnapshot<List<Task>> snapshot) {
                        final tasks = snapshot.data;
                        return ListView.builder(
                          itemCount: tasks?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskPage(
                                          task: tasks?[
                                              index]), // i have remove .id as well
                                    )).then((value) {
                                  setState(() {});
                                });
                              }),
                              child: TaskCardWidgets(
                                title: "${tasks?.elementAt(index).title}",
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 30.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TaskPage(
                                task: null,
                              )),
                    ).then((value) => {
                          setState(() {}),
                        });
                  }),
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff7349ef),
                          Color.fromARGB(255, 47, 10, 160)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Image.asset('assets/images/add.png'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
