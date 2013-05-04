require 'rest_client'
require 'pp'

class MyTimer
    
    def initialize()
        @run = true
    end
    
    def repeat_every(interval)
        #Ctrl-C
      Signal.trap("INT")  { stop() }
      Signal.trap("TERM")  { stop() }
      while @run do
        start_time = Time.now
        yield
        elapsed = Time.now - start_time
        sleep([interval - elapsed, 0].max)
      end
      
      puts "MyTimer STOPPED!"
    end
    
    def stop()
        @run = false
        puts "Stopping MyTimer ... "        
    end

end

#BEGIN
puts("Calling http urls...")

#puts response.body, response.code, response.message, response.headers.inspect
#pp Page.get('http://www.google.com')

MyTimer.new.repeat_every(5) do
      puts("========================================== Requisicao HTTP ==========================================")
      puts Time.now.strftime("%T,%L")
      response = RestClient.get('http://www.google.com.br')
      puts response.code, response.description, response.headers
    end


#END