
require_relative "rgq/parser_excel"
require_relative "rgq/rgq_formatter"
require_relative "scm/scm_parser_excel"
require_relative "scm/scm_formatter"

class GeraIndicadorXML
    
    def initialize (parser, formatter)
        @parser = parser
        @formatter = formatter
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
	tipo_de_indicador = ARGV[0];
	
	if ("-rgq".eql?(tipo_de_indicador)) 
		r = GeraIndicadorXML.new(RGQ::ParserExcel.new(ARGV[1]), RGQ::RgqFormatter.new(ARGV[2]))
		r.build
	elsif ("-scm".eql?(tipo_de_indicador))
		r = GeraIndicadorXML.new(SCM::ParserExcel.new(ARGV[1]), SCM::ScmFormatter.new(ARGV[2]))
		r.build
	else
		puts("Missing operator type: -rgq or -scm")
		puts("Usage: ruby gera_indicador.rb <tipo de indicador ssing(-rgq ou -scm) > <in.xlsx> <out.xml>")
	end	
else
    puts("Usage: ruby gera_indicador.rb <tipo de indicador (-rgq ou -scm) > <in.xlsx> <out.xml>")
end

#End Main()

