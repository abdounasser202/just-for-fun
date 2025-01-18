class Animal {

      String name;
      int age;

      Animal(this.name, this.age);

      void displayInfo() {
      	   print("name: $name");
      	   print("age: $age");
      }

      void makeSound() {}

      void feed(String food) {
      	   print("Food of $name : $food");
      }

}


class Lion extends Animal {

      bool isAlpha;

      Lion(String name, int age, this.isAlpha) : super(name, age);

      @override
      void makeSound() {
      	   print("Roar");
      }

      @override
      void displayInfo() {
      	   super.displayInfo();
      	   this.makeSound();
      	   print("isAlpha: $isAlpha");
	   this.feed('Meat');
	   print('------------');
      }

}


class Elephant extends Animal {

      double trunkLength = 0.0;

      Elephant(name, age, this.trunkLength) : super(name, age);
      
      @override
      void makeSound() {
      	   print("Trumpet");
      }

      @override
      void displayInfo() {
      	   super.displayInfo();
	   this.makeSound();
      	   print("trunkLength: $trunkLength");
	   this.feed("Crops");
	   print('------------');
      }

}


void main() {

     Lion l = Lion("Simba", 5, true);
     l.displayInfo();

     Elephant e = Elephant("Doumbo", 10, 2.8);
     e.displayInfo();

     List<Animal> animals = [
     		  Lion("Leo", 2, false),
		  Elephant("Moowie", 8, 5)
     ];

     for (var animal in animals) {
     	 animal.displayInfo();
     }

     for (int i=0; i < animals.length; i++){
     	 print('***********');     	 
	 print(animals[i]);
     }
}
