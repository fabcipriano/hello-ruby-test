class Teste
    def calculate(a, b, *numbers)
      option = {:add => true}
      if ((numbers.size > 0) && (numbers[-1].is_a? Hash) )
        option = numbers[-1]
        numbers.slice!(-1)
      end
  
      if option[:add]
        add(a, b, *numbers)
      elsif option[:subtract]
        subtract(a, b, *numbers)
      end
    end

    def add (a, b, *numbers)
      if (numbers.size == 0)
        a + b
      else
        numbers = [a , b , numbers]
        numbers.flatten!
        numbers.inject(0) {|sum, num| sum + num}
      end
    
    end

    def subtract(a, b, *numbers)
      if (numbers.size == 0)
        a - b
      else
        numbers = [b, numbers]
        numbers.flatten!
        total = a;
        numbers.each {|subs| total = total - subs}

        total
      end
    end
    
    def is_ancestor?(klass, subclass)
      result = false;
      begin
        subclass = subclass.superclass
        result = subclass.eql? (klass)
      end until (result) || (subclass == nil)
  
      result
    end    
end

#Begin
puts ("Running...")
t = Teste.new

puts(t.is_ancestor?(Numeric, String))
#End

#invoking add(4, 5) returns 9 ✔
#invoking add(-10, 2, 3) returns -5 ✔
#invoking add(0, 0, 0, 0) returns 0 ✔
#invoking subtract(4, 5) returns -1 ✔
#invoking subtract(-10, 2, 3) returns -15 ✔
#invoking subtract(0, 0, 0, 0, -10) returns 10 ✔
#defaults to addtion when no option is specified ✔
#invoking calculate(4, 5, add: true) returns 9 ✔
#invoking calculate(-10, 2, 3, add: true) returns -5 ✔
#invoking calculate(0, 0, 0, 0, add: true) returns 0 ✔
#invoking calculate(4, 5, subtract: true) returns -1 ✔
#invoking calculate(-10, 2, 3, subtract: true) returns -15 ✔
#invoking calculate(0, 0, 0, 0, -10, subtract: true) returns 10 ✔