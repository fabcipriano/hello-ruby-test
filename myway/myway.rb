require "sinatra"

class MyWayApp
    use Rack::Session::Cookie, :secret => 'teste paranaueh'
    
    set(:auth) do |role|   
      condition do
        unless logged_in? 
          redirect "/login", 303
        end
      end
    end    

    helpers do
        def logged_in?
          session[:username] != nil
        end
        
        def authentication(username, password)
            if ("fabiano".eql? username) && ("12345678".eql? password)
                session[:username] = username
                true
            else
            end
        end
        
        def logoff!
            session[:username] = nil
        end
    end

    get '/' do
      'Hello world, annonumous!'
    end

    get '/logout' do
        logoff!
      'I am annonumous! LOGOUT done !!!'
    end

    get '/login' do
        @title = "Efetuando Login"
        erb :login
    end

    get '/login_failed' do
        @title = "Login Falhou ... Tente Novamente !!!"
        erb :login
    end

    post '/login' do
        if (authentication(params[:usuario], params[:senha]))
            redirect '/form'
        else
            redirect "/login_failed", 303
        end
    end


    # Protected !!!!!
    get '/about', :auth => :user do
        'About page'
    end

    get '/hello/:name', :auth => :user do
        "Hello there, #{params[:name]}."
    end

    get '/form', :auth => :user do
        @title = "Teste Formulario ... Login OK"
        erb :form
    end

    post '/form', :auth => :user do  
      "You said '#{params[:message]}'"  
    end  


end 