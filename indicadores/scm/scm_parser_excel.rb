require "rubyXL"

module SCM
	class ParserExcel
		

		
		def initialize (file_name)        
			@file = File.new( file_name )        
		end
			
		def each_indice(add_element_proc)

			if (add_element_proc.nil?)
				raise "Handler is null!!!"
			end
			
			workbook = RubyXL::Parser.parse(@file, {:skip_filename_check => true} )
			
			planilha = workbook[0].get_table(["Outorga", "Indicador", "UnidadePrimaria", "FaixaVelValor", "indice", "valor"])
	  
			tabela = planilha[:table];
					 
			tabela.each() do |indice| 
				add_element_proc.call(indice)
			end
		end
		
	end
end
