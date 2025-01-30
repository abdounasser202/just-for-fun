/*

A command line todo app that uses sqlite to store data to learn dart
It uses https://pub.dev/packages/sqlite3

*/

import 'package:sqlite3/sqlite3.dart';


class TodoServices {

      String title;
      bool done;
      late final Database db;

      TodoServices(this.title, this.done){
          print("1. Open DB...");
          db = sqlite3.open('./todo.db');
	  print("2. DB opened");
      }


      void createTodo() {
      	   print("3. Create Todo");
      	   db.execute('''
		CREATE TABLE IF NOT EXISTS todo (
		       id INTEGER NOT NULL PRIMARY KEY,
		       title TEXT NOT NULL
		       // add done also as boolean
		);
	   ''');
	   final query = db.prepare('''
	   	 INSERT INTO todo (title) VALUES (?);
	   ''');
	   query.execute([this.title]);
	   query.dispose();
	   
      }

      void showTodo(int? id) {
      	   print("showing $id");
      }

      void listTodo() {}

      void deleteTodo(int? id) {
      	   print("deleted $id");
      }

      void editTodo(id) {}


}


