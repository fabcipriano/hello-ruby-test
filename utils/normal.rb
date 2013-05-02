require "rexml/document"


class Normal

	include REXML

	def initialize (file_name, filename_output)        
		@filename_in =  file_name
        @filename_out = filename_output
	end
	
	def format_xml
		nice_formatter = REXML::Formatters::Pretty.new(4, false)
		outf = File.new(@filename_out, "w")
        inf = File.new(@filename_in)
        doc = Document.new inf
		nice_formatter.write(doc, outf)
	end

end


#Begin

if (ARGV.size == 2)
    puts ("Working...")
    n = Normal.new(ARGV[0], ARGV[1])
    n.format_xml()
    puts ("Done")
else
    puts ("ruby normal input.xml output.xml")
end


#End