import 'package:todo/todo_logic.dart';


void main() {

     TodoServices todo = TodoServices('Cleaning the room', false);
     todo.createTodo();
     todo.showTodo(45);
     todo.deleteTodo(45);

}