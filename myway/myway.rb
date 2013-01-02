require 'sinatra'

get '/' do
  'Hello world!'
end

get '/about' do
    'About page'
end

get '/hello/:name' do
    "Hello there, #{params[:name]}."
end

get '/form' do
    erb :form
end

post '/form' do  
  "You said '#{params[:message]}'"  
end  
