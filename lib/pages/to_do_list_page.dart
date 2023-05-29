import 'package:flutter/material.dart';
import 'package:todolistpage/models/todo.dart';
import 'package:todolistpage/repositories/to_do_repositories.dart';
import 'package:todolistpage/widgets/to_do_list_item.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff121212),
        appBar: AppBar(
          backgroundColor: Color(0xff1f1f1f),
          title: Center(
            child: Text(
              'Lista de Tarefas',
              style: TextStyle(
                color: Color(0xffe1e1e1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: const [
                    Text(
                      'Suas tarefas ativas:',
                      style: TextStyle(color: Color(0xffe1e1e1), fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Color(0xffe1e1e1),
                        ),
                        controller: todoController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Ex: Estudar Flutter',
                            errorText: errorText,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffe1e1e1))),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffbb86fc), width: 2),
                            ),
                            labelStyle: TextStyle(
                              color: Color(0xffbb86fc),
                              fontWeight: FontWeight.w700,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xffe1e1e1),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'A tarefa não pode ser vazia!';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo =
                              Todo(tittle: text, dateTime: DateTime.now());
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffbb86fc),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Color(0xffe1e1e1),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: false,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Voce possui ${todos.length} tarefas pendentes',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xffe1e1e1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffbb86fc),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Text(
                        'Limpar tudo',
                        style: TextStyle(color: Color(0xffe1e1e1)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.tittle} foi removida com sucesso',
          style: TextStyle(
            color: Color(
              0xffe1e1e1,
            ),
          ),
        ),
        backgroundColor: Color(0xff1f1f1f),
        action: SnackBarAction(
          textColor: Color(0xffbb86fc),
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff1e1e1e),
        title: Text(
          'Limpar tudo ?',
          style: TextStyle(
            color: Color(0xffe1e1e1),
          ),
        ),
        content: Text(
          'Voce tem certeza que deseja apagar as ${todos.length} tarefas ?',
          style: TextStyle(
            color: Color(
              0xffe1e1e1,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Color(0xffbb86fc)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deletedAllTodos();
            },
            style: TextButton.styleFrom(foregroundColor: Color(0xffcf6679)),
            child: Text(
              'Limpar tudo',
            ),
          ),
        ],
      ),
    );
  }

  void deletedAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
