import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  int completedTaskCount = 0;
  int pendingTaskCount = 0;

  @override
  Widget build(BuildContext context) {
    completedTaskCount = tasks.where((task) => task.isCompleted).length;
    pendingTaskCount = tasks.length - completedTaskCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas Pendientes'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Completadas: $completedTaskCount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.red, 
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Pendientes: $pendingTaskCount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.red, 
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Container(
                      color: Colors.red[100], // Color de fondo rojo pálido
                      child: ListTile(
                        title: Text(tasks[index].title,
                        style: TextStyle(
                                fontSize: 19.0, // Ajusta el tamaño de la fuente a 18.0 o según tus preferencias
                              ),),
                        subtitle: Text(tasks[index].description,
                        style: TextStyle(
                                fontSize: 17.0, // Ajusta el tamaño de la fuente a 18.0 o según tus preferencias
                              ), ),
                        leading: Checkbox(
                          value: tasks[index].isCompleted,
                          onChanged: (value) {
                            setState(() {
                              tasks[index].isCompleted = value!;
                            });
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,color: Colors.red,),
                              onPressed: () {
                                _editTask(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,color: Colors.red,),
                              onPressed: () {
                                setState(() {
                                  tasks.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _editTask(index);
                        },
                      ),
                    ),
                    Divider(
                      height: 3, // Controla el espacio entre las tareas
                      color: Colors.grey, // Color del divisor
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask() async {
    final task = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormScreen()),
    );

    if (task != null) {
      setState(() {
        tasks.add(task);
      });
    }
  }

  void _editTask(int index) async {
    final editedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: tasks[index]),
      ),
    );

    if (editedTask != null) {
      setState(() {
        tasks[index] = editedTask;
      });
    }
  }
}

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Agregar Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16.0),
            CheckboxListTile(
              title: Text('Completada'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  isCompleted: _isCompleted,
                );
                Navigator.pop(context, newTask);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String description;
  bool isCompleted;

  Task({required this.title, required this.description, this.isCompleted = false});
}