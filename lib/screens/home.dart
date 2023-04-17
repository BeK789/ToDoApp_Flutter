import 'package:demo/constants/colors.dart';
import 'package:demo/todo.dart';
import 'package:flutter/material.dart';
import 'package:demo/todo_items.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _foundToDo = todosList;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
          backgroundColor: tdBGColor,
          elevation: 0,
          title: Row(
            children: [
              Text(
                'ToDo List App',
                style: TextStyle(
                    color: Colors.blue[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              )
            ],
          )),
      body: Stack(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              searchbox(),
              Expanded(
                child: ListView(children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      'All ToDos',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (ToDo todo in _foundToDo.reversed)
                    ToDoItems(
                      todo: todo,
                      onToDoChanged: _handleToDoChange,
                      onDelete: _deleteToDoItem,
                    ),
                ]),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0)
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: 'Add a new todo', border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 40),
                    ),
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: tdBlue,
                        minimumSize: Size(60, 60),
                        elevation: 10)),
              )
            ],
          ),
        )
      ]),
    );
  }

  void _runFilter(String enteredKey) {
    List<ToDo> results = [];
    if (enteredKey.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) =>
              item.todoText!.toLowerCase().contains(enteredKey.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
    _todoController.clear();
  }

  Widget searchbox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              maxWidth: 25,
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }
}
