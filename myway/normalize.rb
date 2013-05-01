require "rexml/document"


class Normal

	include REXML

	def initialize (xml)
        @xml_input = xml        
	end
	
	def format_xml()
		nice_formatter = REXML::Formatters::Pretty.new(4, false)
		outs = String.new
        doc = Document.new @xml_input
		nice_formatter.write(doc, outs)
        
        outs
	end    

end
