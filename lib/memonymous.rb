require "memonymous/version"

module Memonymous
  def self.included(receiver)
    receiver.extend ClassMethod
    unless receiver.instance_variable_defined?('@memoized_methods')
      receiver.instance_variable_set('@memoized_methods', {})
    end
  end

  # Note the singular name!
  # The point of this exercise is to memoize without cluttering up the function namespace.
  module ClassMethod
    def memoize(*methods)
      Array(methods).flatten.map(&:to_sym).each do |mname|
        @memoized_methods[mname] = instance_method(mname) # save the UnboundMethod for later
        class_eval <<-RUBY
          # apparently 'def' is faster than 'define_method', according to Several Random People on the Internet
          def #{mname}(*args, &b)
            ivar_name = '@#{mname}'

            # The entire point:  returning fast if we already know the answer
            return instance_variable_get(ivar_name) if instance_variable_defined?(ivar_name)

            # FIRST POST^H^H^H^H CALL!
            # Grab the UnboundMethod, bind it, and call it.
            # I like to think of this as the "Gromit's Train Track" approach to memoization.
            # (See: http://www.google.com/search?q=wallace+and+gromit+train+chase if you don't get the reference.)
            return instance_variable_set( ivar_name,
                                          self \
                                            .class \
                                            .instance_variable_get('@memoized_methods')[:'#{mname}'] \
                                            .bind(self) \
                                            .call(*args, &b)
                                        )
          end
        RUBY
      end
    end
  end
end
