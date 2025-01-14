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


var _nobleGases = {1: 2};
// this is a lambda function.
final isNoble = (int atomicNumber) => _nobleGases[atomicNumber] != null;


// function with named parameters
void enableColors({bool colorRed = true, required bool? colorBlue}) {
     print("$colorRed, $colorBlue");
}


// here device is optional
String say(String from, String msg, [String? device]) {
       var result = "$from says $msg";
       if (device != null) {
       	  result = "$result with a $device";
       }
       return result;
}

void anonymous() {
     var listFruits = ["apple", "Orange", "mangO"];

     var fruitsUpperCase = listFruits.map((item) {
     	 return item.toUpperCase();
     }).toList();

     for (var item in fruitsUpperCase) {
     	 print("$item : ${item.length}");
     }

}

void anonymous2() {
   var listFruits = ["apple", "Orange", "mangO"];
   var fruitsUpperCase = listFruits.map((item) => item.toUpperCase()).toList();
   fruitsUpperCase.forEach((item) => print("$item : ${item.length}"));
}

// synchronous function return Iterable an uses sync* with yield
Iterable<int> naturalsTo(int n) sync* {
	      int k = 0;
	      while (k < n) yield k++;
}

// asynchronous function returns Stream obj and uses async* with yield
Stream<int> asynchronousNaturalsTo(int n) async* {
	    int k = 0;
	    while (k < n) yield k++;
}

class Point {

      int x;
      int y;

      // this is the contructor
      Point(this.x, this.y) {
          // this can also be used as constructor : Point.anyName(this.x, this.y)
          print("Initialisation");
	  print("x => $x");
	  print("y => $y");
      }

      int getSomeValue() {
      	   return (this.x * this.x) - this.y;
      }

}

void main() {

     anonymous();
     anonymous2();


    var result = fibonacci(12);
    print(result);

     var listOfPlanets = ['March', 'Jupiter', 'Uranus'];
     listOfPlanets.where((name) => name.contains("u")).forEach(print);

     print(isNoble(3));

     enableColors(colorBlue: false);
     enableColors(colorRed: false, colorBlue: true);

     print(say("nasser", "bonjour"));
     print(say("abdou", "bonsoir", null));
     print(say("abdou", "bonsoir", "LG"));

     var p = Point(6, 7);
     print(p.getSomeValue());
     print('The type of p is ${p.runtimeType}');
}