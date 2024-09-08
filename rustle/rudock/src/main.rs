use iced::widget::button;
use iced::widget::text;
use iced::widget::column;

struct Counter {
       value: i64,
}

#[derive(Debug, Clone, Copy)]
enum Message {
     Increment,
     Decrement,
}

impl Counter {

     fn update(&mut self, message:Message) {
     	match message {
	      Message::Increment => {
	      	self.value += 1;
	      }
	      Message::Decrement => {
	      	self.value -= 1;
	      }
	}
     }
}



fn main() {
    println!("Hello, world!");

    let x = 5;
    let y = &x;

    println!("x is: {}", x);
    println!("y is: {}", y);

    let mut z = 10;
    let w = &mut z;
    *w += 1;

    println!("w is now: {}", w);
    println!("z is now: {}", z);

    let mut counter = Counter { value: 5};
 
    counter.update(Message::Increment);
    counter.update(Message::Increment);
    counter.update(Message::Decrement);

    println!("counter is: {}", counter.value);

    
    let increment = button("+");
    let decrement = button("-");
    let counter = text(15);
    let interface = column![increment, counter, decrement];
}
