# Whack

**Rack for games**

An experimental Ruby game engine/framework/specification inspired by [Rack](https://github.com/rack/rack).

### _Whack is extremely early in development and very incomplete_

Like Rack applications, Whack games are Ruby objects that respond to `call`.

At the most basic level, `call` receives an `env` Hash as an argument and returns a list of objects to render to the screen.

Like Rack applications, Whack games are composable via middleware.

Conceptually, Whack games _could_ be rendered by any graphics backend, but the implementation here is coupled to [Gosu](https://github.com/gosu/gosu).

### Why?

- I want to understand if the concepts Rack applies to web applications (which have been wildly successful in that space) could work for a game engine.
  - I have not seen any other engines that implement this middleware concept, and the possibilities that composability opens up are interesting to me.
  - A stateless game that is basically a method call could be easy to unit test.
- I like Ruby
- The name "Whack" is funny

### How?

There's a [proof of concept example game](https://github.com/alexford/whack-example) here
