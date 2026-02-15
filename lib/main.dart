import 'package:flutter/material.dart';

void main() {
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoListPage(),
    );
  }
}

class TodoItem {
  int? id;
  String title;
  bool isDone;

  TodoItem({
    this.id,
    required this.title,
    this.isDone = false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('リスト一覧')),
      body: todoList.isEmpty
          ? const Center(child: Text('まだリストがありません'))
          : ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          final item = todoList[index];

          return Card(
            child: ListTile(
              leading: Checkbox(
                value: item.isDone,
                onChanged: (value) {
                  setState(() {
                    item.isDone = value!;
                  });
                },
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  decoration: item.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: item.isDone
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    todoList.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newText = await Navigator.of(context).push<String>(
            MaterialPageRoute(
              builder: (context) => const TodoAddPage(),
            ),
          );

          if (newText != null) {
            setState(() {
              todoList.add(TodoItem(title: newText));
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  State<TodoAddPage> createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('リスト追加')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'やることを入力',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _text = value;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final text = _text.trim();
                if (text.isEmpty) return;
                Navigator.of(context).pop(text);
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}
