require "nokogiri"
require "csv"

class TaskReader


	def initialize ()
		@tarefas = {}
	end

    def read_event_received(dirname, file)
	    completefilename = dirname + file
		
		if ((file == '.') || (file == '..'))
		    puts ('Current dir or Parent dir, exit!')
		    return
		end
		
		@doc = Nokogiri::XML(File.read(completefilename))
		plugin_received = @doc.xpath('//task:taskStateAutomationNotifications[contains(@name,"received")]//prov:type/text()', 
			'task' => 'http://xmlns.oracle.com/communications/sce/osm/model/process/task', 'prov' => 'http://xmlns.oracle.com/communications/sce/osm/model/provisioning')
		
		str_received = plugin_received.to_s()
		
		@tarefas[file] = str_received
	end
	
	def read_event_from_dir(dirname) 
	    dirname += '/'
		Dir.foreach(dirname) do |filename|
			read_event_received(dirname, filename)
		end
		
		CSV.open("cor-854.csv", "wb", :col_sep => ";") do |csv|
			csv << ["Tarefa", "Evento Plugin"]			
			@tarefas.each do |key, value|
			  csv << [key, value]			
			end
		end		
	end

end



#Begin

if (ARGV.size == 1)
    puts ("Working...")
    n = TaskReader.new()
    n.read_event_from_dir(ARGV[0])
    puts ("Done")
else
    puts ("ruby readtask input.xml")
end


#End