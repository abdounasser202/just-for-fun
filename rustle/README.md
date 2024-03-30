# Rustle

Learning Rust

0. Why rust ?

- Very good for programs that cares about memory because it has solved the issue with memory allocation
- Good to integrate with webassembly and write programs that runs on browsers
- For curiosity to learn a programming language that is low level

1. Installation

Install rust compiler and rust package manager, cargo -> https://www.rust-lang.org/tools/install

2. Getting started

- Check if Rust is up to date : `rustup update`
- Cargo is the rust build tool and package manager, similar to pip in python : `cargo --version`
- Install rust-analyzer, the Rust VS Code extension -> https://code.visualstudio.com/docs/languages/rust

3. New Rust project : hello-rust

- Create the package : `cargo new hello-rust`
- Cargo.toml is the manifest file where we keep the metadata of the package
- We can run the program in `main.rs` by moving inside the package and running `cargo run`

3. Dependencies

- All packages that can be used as dependencies of a Rust project can be found on `crates.io` meaning that a crate is a dependency.
- To add crate as dependency, we just need to add the name of the crate with it version in Cargo.toml file below `[dependencies]`
- As example, we added ferris-says. We can also write `cargo add ferris-says` then run `cargo build` to install the dependency
- `Cargo.lock` keep the exact versions of the packages that are used as dependency
- We can use a dependency like this at the top of our program `use ferris_says::say;` meaning that we can use `say` function in ferris_says

4. A small application

We will write a small program inside main.rs and run it.

5. Rust and WebAssembly

- We will go throught the book Rust 🦀 and WebAssembly 🕸 to make apps on the browser -> https://rustwasm.github.io/docs/book/introduction.html

- Rustlings is a must to refresh his memory with exercices, at least once a week -> https://github.com/rust-lang/rustlings/tree/main

- The Rust Book is also a must read -> https://doc.rust-lang.org/book/title-page.html