import 'dart:math' as math;

abstract class Shape {

	 double calculateArea();

	 void displayInfo();
}


class Circle implements Shape {

      double radius;

      Circle(this.radius);

      @override
      double calculateArea() {
      	     return math.pi * this.radius;
      }

      @override
      void displayInfo() {
      	   print('------- Circle Area -----');
	   print(this.calculateArea());
      }
}


class Rectangle implements Shape {

      double length;
      double width;

      Rectangle(this.length, this.width);

      @override
      double calculateArea() {
      	     return this.length * this.width;
      }

      @override
      void displayInfo() {
      	   print('----- Rectangle Area -----');
	   print(this.calculateArea());
      }
}


class Triangle implements Shape {

      final DOT_FIVE = 0.5;
      double base;
      double height;

      Triangle(this.base, this.height);

      @override
      double calculateArea() {
      	     return this.DOT_FIVE * this.base * this.height;
      }

      @override
      void displayInfo() {
      	   print('---- Triangle Area -----');
	   print(this.calculateArea());
      }
}


void main() {

     double radius = 2.0;
     Circle circle = Circle(radius);
     circle.displayInfo();

     double length = 3;
     double width = 2;
     Rectangle rect = Rectangle(length, width);
     rect.displayInfo();

     double base = 2;
     double height = 3;
     Triangle t = Triangle(base, height);
     t.displayInfo();
}