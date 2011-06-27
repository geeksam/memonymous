# Memonymous:  a Ruby memoization module that doesn't clutter up its includees.

## License

Public domain (more or less).  See the LICENSE file for more information.

## Origin

Inspired by a recent Hangman puzzle at the Portland Ruby Brigade ([link](http://groups.google.com/group/pdxruby/browse_thread/thread/19d58126a268e89a/078efefc26ddcf7b)), I decided to try writing a memoization module that used `super` instead of mucking around with `alias_method_chain`.

Unfortunately, the only way I could think of to get this to work was to override the including class's .new method, so that all new instances were actually instances of a newly-created subclass...and that just seemed like a Really Bad Idea&trade;.

Fortunately, I did find an interesting workaround, and in the process learned a few new tricks that have been sitting right there in the Kernel and Module classes just waiting for me to notice them.

## Usage:

<pre>
  class FrankSinatra
    attr_reader :call_count
    def dont_be_afraid_you_can_call_me
      @call_count ||= 0
      @call_count += 1
    end
  end

  class MemoizedFrankSinatra < FrankSinatra
    include Memonymous
    memoize :dont_be_afraid_you_can_call_me
  end

  naked_frank = FrankSinatra.new
  3.times do
    naked_frank.dont_be_afraid_you_can_call_me
  end
  p naked_frank.call_count # => 3

  memoized_frank = MemoizedFrankSinatra.new
  3.times do
    memoized_frank.dont_be_afraid_you_can_call_me
  end
  p memoized_frank.call_count # => 1
</pre>

## Technique

I was actually quite amused by this one.  Because Ruby doesn't let you change the superclass of a Class object, I couldn't insert new methods above the includee in the hierarchy.  Instead, when .memoize is called, it asks Ruby for an UnboundMethod object for each method it's supposed to memoize and hangs onto it in a class instance variable.  Then it defines its own replacement for the same method.

Later, when you call the memoized method, we either look to see if we've already computed it (thus the 'memoization' part of the gem), or we grab the UnboundMethod, bind it to the caller, call it, and save the result.  This process reminds me of the Wallace and Gromit film "The Wrong Trousers" -- see the comments in the Memonymous module for a link to a Google video search.

Thanks also to Jay Fields for the technique -- I had started down this path and was trying to figure it out, but came across a [2008 blog post](http://blog.jayfields.com/2008/04/alternatives-for-redefining-methods.html) with a conveniently-packaged code snippet.

