require File.expand_path(File.join(File.dirname(__FILE__), *%w[test_helper]))

describe Memonymous do
  before do
    @memoize_this = Class.new do
      attr_reader :call_count
      def dont_be_afraid_you_can_call_me
        @call_count ||= 0
        @call_count += 1
      end
    end
  end

  it 'should add a .memoize method' do
    refute @memoize_this.respond_to?(:memoize), "Method found before it should be there"
    @memoize_this.send(:include, Memonymous)
    assert @memoize_this.respond_to?(:memoize), "Method not found after it should've been added"
  end
  
  it 'should ONLY add a .memoize method' do
    old_klass_methods = @memoize_this.methods.sort.dup
    old_inst_methods  = @memoize_this.instance_methods.sort.dup
    
    @memoize_this.send(:include, Memonymous)

    new_klass_methods = @memoize_this.methods.sort.dup
    new_inst_methods  = @memoize_this.instance_methods.sort.dup

    assert_equal [:memoize], new_klass_methods - old_klass_methods
    assert_equal [],         new_inst_methods  - old_inst_methods
  end

  describe 'when included into a class' do
    before :each do
      @memoize_this.send(:include, Memonymous)
    end
    
    it "should not memoize methods it hasn't been told about" do
      foo = @memoize_this.new
      foo.dont_be_afraid_you_can_call_me
      foo.dont_be_afraid_you_can_call_me
      assert_equal 2, foo.call_count
    end

    it 'should set up a @memoized_methods class instance variable' do
      assert @memoize_this.instance_variables.map(&:to_sym).include?(:'@memoized_methods')
    end

    it 'should memoize methods it has been told about' do
      @memoize_this.memoize(:dont_be_afraid_you_can_call_me)
      foo = @memoize_this.new
      foo.dont_be_afraid_you_can_call_me
      foo.dont_be_afraid_you_can_call_me
      assert_equal 1, foo.call_count
    end
  end
end
