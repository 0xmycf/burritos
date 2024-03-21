////
////
////
//// STATE MONAD
////
////
////

pub opaque type State(state, result) {
  State(run_state: fn(state) -> #(state, result))
}

pub fn run(what st: State(state, res), with what: state) -> #(state, res) {
  st.run_state(what)
}

fn state(runner: fn(state) -> #(state, result)) -> State(state, result) {
  State(runner)
}

pub fn bind(first st: State(s, a), then then: fn(a) -> State(s, b)) -> State(s, b) {
  use s0 <- state()
  let #(s1, x) = st.run_state(s0)
  then(x).run_state(s1)
}

pub fn pure(value: a) -> State(state, a) {
  use s <- state()
  #(s, value)
}

pub fn put(new_state: state) -> State(state, Nil) {
  use _ <- state()
  #(new_state, Nil)
}

pub fn get() -> State(state, state) {
  state(fn(s) { #(s, s) })
}

pub fn map(st: State(state, a), with mapper: fn(a) -> b) -> State(state, b) {
  use s <- state()
  let #(state, value) = st.run_state(s)
  #(state, mapper(value))
}

// pub type Foobar {
//   Foo(s: Int, b: Bool)
// }

// pub fn some_test(i, b) -> State(Foobar, Int) {
//   use s <- bind(get())
//   let new_foo = Foo(..s, s: s.s + i)
//   use _ <- bind(put(new_foo))
//   case b {
//     True -> pure(new_foo.s + 1)
//     False -> {
//       use _ <- bind(put(Foo(..new_foo, b: False)))
//       pure(0)
//     }
//   }
// }
