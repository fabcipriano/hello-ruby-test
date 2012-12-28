require "rexml/document"
require "rexml/namespace"
require "rexml/node"

module RGQ

	class RgqFormatter
		def initialize(filename)
			anatel_str ="<root><ColetaSMP ano=\"2012\" mes=\"8\" TipoArquivo=\"0\" Identificador=\"stringxxxxx\"></ColetaSMP></root>"                
			@doc = REXML::Document.new anatel_str
			@filename = filename
		end
		
		def print_xml
			nice_formatter = REXML::Formatters::Pretty.new(4, false)
			out = File.new(@filename, "w")
			nice_formatter.write(@doc, out)
		end
		
		def add_element_from_item(h)
					
			if (h.empty?)
				puts("WARN: item empty!!!");
				return
			end
			elOutorga = add_outorga(h["Outorga"])
			
			elIndicador = add_indicador(h["Indicador"], elOutorga)
					
			elUp = add_unidadeprimaria(h["UnidadePrimaria"], elIndicador)

			add_periodocoleta(h["PeriodoColeta"], 
				h["FatorPonderacao"], 
				h["FatorPonderacaoValor"], 
				h["indice"], 
				h["valor"], elUp)
			
		end
		
		def add_periodocoleta(periodo_coleta, fator, fator_valor, indice, valor, element)

			#TODO: change this            
			if (fator_valor.nil?)
				new_fator_valor = 0
			else
				new_fator_valor = fator_valor
			end 

			if (element.elements["Periodo"].nil? || 
				  element.get_elements("Periodo[@Coleta='#{periodo_coleta}']").size == 0)
				
				element.add_element("Periodo", {"Coleta"=>"#{periodo_coleta}"})
			end

			elements_periodo_coleta = element.get_elements("Periodo[@Coleta='#{periodo_coleta}']")
			if (elements_periodo_coleta.size > 1) 
				raise "Error from parser! Too many elements from Indicador"
			end
			
			if (!fator.nil?) 
				add_fator(fator, new_fator_valor, elements_periodo_coleta[0])
			end
			
			add_conteudo(indice, valor, elements_periodo_coleta[0])
			
		end
		
		def add_fator(fator, fator_valor, element)

			if (element.elements["Fator"].nil? || 
					element.get_elements("Fator[@Ponderacao='#{fator}']").size == 0)
					 
				element.add_element("Fator", {"Ponderacao"=>"#{fator}", "valor"=>"#{fator_valor}"})
			end

		end

		def add_conteudo(indice, valor, element)
			if (element.elements["Conteudo"].nil? ||
					element.get_elements("Conteudo[@indice='#{indice}']").size == 0 )
					 
				element.add_element("Conteudo", {"indice"=>"#{indice}", "valor"=>"#{valor}"})
			end
		end

		def add_unidadeprimaria(valorup, element)
			
			e = element.get_elements("./Unidade[@Primaria='#{valorup}']")
			
			if (element.elements["Unidade"].nil? || 
					element.get_elements("./Unidade[@Primaria='#{valorup}']").size == 0 )
					 
				element.add_element("Unidade", {"Primaria"=>"#{valorup}"})
			end

			elUP = element.get_elements("./Unidade[@Primaria='#{valorup}']")

			if (elUP.size > 1) 
				raise "Error from parser! Too many elements from Indicador"
			end        
			
			elUP[0]
		end
		
		def add_indicador(ind, element)
			
			if (element.elements["#{ind}"].nil?) 
				element.add_element("#{ind}")  
			end
			
			elIndicador = element.get_elements("./#{ind}")

			if (elIndicador.size > 1) 
				raise "Error from parser! Too many elements from Indicador"
			end        
			
			elIndicador[0]
		end
		
		def add_outorga(cnpj)
			
			#TODO: Tornar este metodo generico para recuperar qualquer CNPJ 
			if (!@doc.root.elements["/root/ColetaSMP"].has_elements?)                
				@doc.root.elements["/root/ColetaSMP"].add_element("Outorga", {"CNPJ"=>"#{cnpj}"})
			end
			elements = @doc.root.get_elements("/root/ColetaSMP/Outorga[@CNPJ='#{cnpj}']")

			if (nil.equal?(elements) || elements.empty?) 
				raise "Error from parser! No Outorga element!"
			end
					
			if (elements.size > 1) 
				raise "Error from parser! Too many elements from Outorga"
			end

			elements[0]
		end
		
	end
end