require "rubyXL"

class ParserExcel
    

    
    def initialize (file_name)        
        @file = File.new( file_name )        
    end
        
    def each_indice(add_element_proc)

        if (add_element_proc.nil?)
            raise "Handler is null!!!"
        end
        
        workbook = RubyXL::Parser.parse(@file, {:skip_filename_check => true} )
        
        planilha = workbook[0].get_table(["Outorga", "Indicador", "UnidadePrimaria", "PeriodoColeta", "FatorPonderacao", "FatorPonderacaoValor", "indice", "valor"])
  
        tabela = planilha[:table];
                 
        tabela.each() do |indice| 
            add_element_proc.call(indice)
        end
    end
    
end

#Begin Main

puts ("Testing...")

#excel = ParserExcel.new("/Users/fabcipriano/Developer/projs/hello-ruby-test/indicadores/SMPJulho2012.xlsx")

#print_proc = Proc.new {|indice|   puts("Indice=#{indice}")}

#excel.each_indice (print_proc)

puts("Finished!")
#End Main

