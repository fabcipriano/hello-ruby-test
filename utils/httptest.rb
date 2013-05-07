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

MyTimer.new.repeat_every(60) do
      puts("========================================== Requisicao HTTP ==========================================")
      puts Time.now.strftime("%T,%L")
	  puts "----------------- request LOGIN"
      response = RestClient.get('http://osmhom.network.ctbc:7003/oms/XMLAPI/login?username=oss&password=ctbc2012')
	  sessionid = response.cookies["JSESSIONID"]

      puts response.code
	  puts "session_id[#{sessionid}]"
	  pp response.body

	  puts "----------------- request REFRESH"
      response = RestClient.get('http://osmhom.network.ctbc:7003/oms/XMLAPI/worklist?xmlDocAdmin=OMSAdminSignal.Request&signal=RefreshServer&refreshItems=Workgroup', {:cookies => {:JSESSIONID => sessionid}})
      puts response.code
	  pp response.body

	  puts "----------------- request LOGOUT"
      response = RestClient.get('http://osmhom.network.ctbc:7003/oms/XMLAPI/logout')
      puts response.code
	  pp response.body
    end


#END