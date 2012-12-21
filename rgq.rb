require "rexml/document"
require "rexml/namespace"
require "rexml/node"

class Parser
    def each_indice(&handle)
        raise "TODO Implement THIS!!!"
    end
end

class ParserXML < Parser
    
    include REXML
    
    #TODO: Como fazer esta classe ler ou string XML ou Arquivo ?
#    def initialize (str_document)
#        @str_document = str_document
#    end
    
    def initialize (file_name)
        @file = File.new( file_name )        
    end
        
    def each_indice(add_element_proc)

        if (add_element_proc.nil?)
            raise "Handler is null!!!"
        end
  
        doc = Document.new @file      
        doc.elements.each("Anatel/Indice") do |element| 
            indice = return_indice_from(element)
            add_element_proc.call(indice)
        end
    end
    
    def return_indice_from(element)
        indice = Hash.new
        
        element.each do |child|
             if child.instance_of?(Element)
                indice[child.name] = child.text
             end  
        end        
        indice
    end
    
end

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
		@parser.each_indice(add_el_itemProc) 
    end
    
end

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

# Begin Main()
if (ARGV.size == 3)
	#r = RgqAnatel.new("05835916000185", ParserXML.new("rgq_Agosto.xml"), "rgq_out.xml")
	r = RgqAnatel.new(ARGV[0], ParserXML.new(ARGV[1]), ARGV[2])
	r.build
else
    puts("Usage: rgq.rb <CNPJ> <in.xml> <out.xml>")
end

#End Main()

