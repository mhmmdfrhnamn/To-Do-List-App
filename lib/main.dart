import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const TodoListApp());
}

// Data Tugas
class Todo {
  String title;
  bool isDone;
  String date;

  Todo ({required this.title, required this.isDone, required this.date});

  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'isDone':isDone,
      'date':date,
    };
  }
  factory Todo.fromMap(Map<String, dynamic>map){
  return Todo(
    title:map['title'],
    isDone: map['isDone'],
    date: map['date'],
  );
}
}



class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List Harian',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.indigo)
        ),
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState()=> _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List<Todo> _todos = []; // Daftar tugas
  final TextEditingController _controller = TextEditingController(); // Untuk input teks

@override
void initState() {
  super.initState();
  _loadTodos();
}

Future<void> _loadTodos() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear(); // Hapus semua data
  final String? todosString = prefs.getString('todos');
  if (todosString != null) {
    final List<dynamic>decoded = jsonDecode(todosString);
    setState(() {
      _todos = decoded.map((item)=> Todo.fromMap(item)).toList();
    });
  }
}

Future<void> _saveTodos() async {
  final prefs = await SharedPreferences.getInstance();
  final String encoded = jsonEncode(_todos.map((todo)=>todo.toMap()).toList());
  await prefs.setString('todos',encoded);
}

  void _addTodo() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      final now = DateTime.now();
      final date = "${_getDayName(now.weekday)}, ${now.day}/${now.month}/${now.year}";
      setState(() {
        _todos.add(Todo(title: text, isDone: false, date: date));
        _controller.clear();
      });
      _saveTodos();
    }
  }

  void _toggleTodo(int index, bool? value) {
    setState(() {
      _todos[index].isDone =value ?? false;
    });
    _saveTodos();
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _saveTodos();
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List Harian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Tambahkan Tugas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Tambah'),
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _todos.isEmpty
              ? const Center(child: Text('Belum Ada Tugas'))
              : ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(value: todo.isDone, 
                      onChanged: (value)=> _toggleTodo(index, value),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isDone ? TextDecoration.lineThrough : null,
                          color: todo.isDone ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text(todo.date),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeTodo(index),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
