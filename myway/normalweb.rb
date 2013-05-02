require "sinatra"
require "erb"
require_relative "normalize"

class NormalWeb


    get '/' do
        'Hello World!!!'
    end
    
    get '/xmltransform' do
        erb :normal                
    end
    
    post '/transform' do
        encode = params[:code]
        xmlin = params[:myxml]
        n = Normal.new(xmlin)
                
        @xml = n.format_xml()
        
        erb :xml
    end
    
end
