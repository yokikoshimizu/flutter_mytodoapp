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

// リスト一覧画面
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<String> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'リスト一覧',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: todoList.isEmpty
      // ✅ 空リスト時の表示
          ? const Center(
        child: Text(
          'まだリストがありません\n＋ボタンから追加してください',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(todoList[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  setState(() {
                    todoList.removeAt(index);
                  });

                  // ✅ 削除通知
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('削除しました'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newListText = await Navigator.of(context).push<String>(
            MaterialPageRoute(
              builder: (context) => const TodoAddPage(),
            ),
          );

          if (newListText != null) {
            setState(() {
              todoList.add(newListText);
            });

            // ✅ 追加通知
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('「$newListText」を追加しました'),
                duration: const Duration(seconds: 1),
              ),
            );
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
      appBar: AppBar(
        title: const Text('リスト追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _text,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'やることを入力してください',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final text = _text.trim();
                  if (text.isEmpty) return;
                  Navigator.of(context).pop(text);
                },
                child: const Text('リスト追加'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
