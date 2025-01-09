void greet(String name) {
     print('Hello $name');
}

void variables() {
     final name = 'Nasser';
     // name = 'Abdou'; // will not work because of final

     final int year = 2025;
     const price = 99.8;
     // price = 2.1; // will not work because of const

     var listOfPlanets = const [];
     listOfPlanets = ['March', 'Jupiter', 'Uranus'];

     var article = {
     	 'tags' : ['docker', 'flutter'],
	 'url' : '//path/to/file.dart',
     };

     print("$name, $year, $price, $listOfPlanets, $article");

     Object anything = "Bob";
     anything = 152;
     print(anything);

     String canNotBeNull;
     String? canBeNull;
     canBeNull = null;
     print(canBeNull);

     int? lineCount;
     assert(lineCount == null);

}

late String description;

void simpleExample(bool weLikeToCount) {
     description = 'eeee';
     print(description);
     if (weLikeToCount) {
     			variables();
	} else {
	 greet('Abdou');
	}
}


void getCenturyByYear(int year) {
     if (year >= 2000){
     	print("21st century");
     } else if (year >= 1900) {
       print("20th century");
     } else {
       print("not yet defined");
     }
}

void oldMain() {
     var result = fibonacci(12);
     print(result);

     var listOfPlanets = ['March', 'Jupiter', 'Uranus'];
     for (final planet in listOfPlanets) {
     	 print(planet);
     }

     for (int month = 1; month <= 12; month++) {
     	 print(month);
     }

     int year = 2010;
     while (year < 2016) {
     	   year+=1;
	   print(year);
     }

     var message = StringBuffer("Dart is like JS and Python");
     for (int i = 1; i <= 5; i++) {
     	 message.write("!");
	 print(message);
     }

     var collection = [1, 2, 3];
     collection.forEach(print);	 
}

// this is a function, it returns a value and start with the type it returns
int fibonacci(int n){
    if (n == 0 || n == 1) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

void main() {
    var result = fibonacci(12);
    print(result);

     var listOfPlanets = ['March', 'Jupiter', 'Uranus'];
     listOfPlanets.where((name) => name.contains("u")).forEach(print);
}