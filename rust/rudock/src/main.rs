use iced::widget::{button, column, text};
use iced::{Element, Sandbox, Settings};

// state that represents the data
struct Counter {
     value: i64,
}

// message that represent the event
#[derive(Debug, Clone, Copy)]
enum Message {
     Increment,
     Decrement,
}

// The sandbox that contains the application logic
impl Sandbox for Counter {
    type Message = Message;

     // Constructor
     fn new() -> Self {
          Self { value: 0 }
     }

     // define title of the app    
     fn title(&self) -> String {
        String::from("Counter")
     }

     // to handle state changes based on Message
     // the app logic lives here 
     fn update(&mut self, message: Message) {
          match message {
               Message::Increment => {
                    self.value += 1;
               }
               Message::Decrement => {
                    self.value -= 1;
               }
          }
     }
     
     // describe how to display the UI
     fn view(&self) -> Element<Message> {
          let increment = button("+").on_press(Message::Increment);
          let decrement = button("-").on_press(Message::Decrement);
          let content = text(self.value.to_string()).size(40);
          column![increment, content, decrement]
               .padding(20)
               .align_items(iced::Alignment::Center)
               .into()
     }
}

fn main() -> iced::Result {
    Counter::run(Settings::default())
}
