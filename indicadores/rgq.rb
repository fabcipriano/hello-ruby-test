require_relative "parser_xml"
require_relative "parser_excel"
require_relative "rgq_formatter"

class RgqAnatel
    
    def initialize (cnpj, parser, filename)
        @cnpj = cnpj
        @parser = parser
        @formatter = RgqFormatter.new(filename)
    end
    
    def build
		puts("Working...")
		start_time = Time.now
        #TODO: Mudar para abstrair o formatador                      
		parse_and_build();
		
        @formatter.print_xml
        end_time = Time.now
		puts("Done. Time spent.: #{end_time - start_time} seconds");
    end
    
    def parse_and_build()
        add_el_itemProc = Proc.new {|e| @formatter.add_element_from_item(e)}
        if (@parser.respond_to?(:each_indice)) 
            @parser.each_indice(add_el_itemProc)        
        else 
            raise "This is NOT a true parser!!!"
        end        
		 
    end
    
end

ruby_version = "Ruby Version.: #{RUBY_VERSION} - #{RUBY_PLATFORM} - #{RUBY_RELEASE_DATE}"
puts("#{ruby_version}")
# Begin Main()
if (ARGV.size == 3)
	#r = RgqAnatel.new("05835916000185", ParserXML.new("rgq_Agosto.xml"), "rgq_out.xml")
	r = RgqAnatel.new(ARGV[0], ParserExcel.new(ARGV[1]), ARGV[2])
	r.build
else
    puts("Usage: rgq.rb <CNPJ> <in.xlsx> <out.xml>")
end

#End Main()

