import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo_item.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isDone INTEGER NOT NULL
      )
    ''');
  }

  Future<TodoItem> insert(TodoItem todo) async {
    final db = await instance.database;
    final id = await db.insert('todos', todo.toMap());
    return TodoItem(
      id: id,
      title: todo.title,
      isDone: todo.isDone,
    );
  }

  Future<List<TodoItem>> getAll() async {
    final db = await instance.database;
    final result = await db.query('todos');
    return result.map((map) => TodoItem.fromMap(map)).toList();
  }

  Future delete(int id) async {
    final db = await instance.database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future update(TodoItem todo) async {
    final db = await instance.database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
}
