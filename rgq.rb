# rgq.rb

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
    
    def initialize (str_document)
        @str_document = str_document
    end
        
    def each_indice(&handle)

        if (handle.nil?)
            raise "Handler is null!!!"
        end
  
        doc = Document.new @str_document      
        doc.elements.each("Anatel/Indice") do |element| 
            indice = return_indice_from(element)
            handle.call(indice)                                   
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
    
    def initialize (cnpj, parser)
        @cnpj = cnpj
        @parser = parser
    end
    
    def build
        
        #TODO: So falta criar a rotina que pega os Maps e transforma em XML ANATEL aqui.
        parse() {|indice| puts indice}
        
    end
    
    def parse(&handle)
        if (handle.nil?)            
            raise "Fail to parse indicadores. There is no Block of code to use!!!"
        else 
            @parser.each_indice(&handle) 
        end
    end
    
end

class RgqFormatter
    def initializer()
        puts "created"
    end
    
    def add_element_from_item(h, doc)
        
        
        elOutorga = add_outorga(h["Outorga"], doc)
        
        elIndicador = add_indicador(h["Indicador"], elOutorga)
        
        elUp = add_unidadeprimaria(h["UnidadePrimaria"], elIndicador)
        
        add_periodocoleta(h["PeriodoColeta"], 
            h["FatorPonderacao"], 
            h["FatorPonderacaoValor"], 
            h["indice"], 
            h["valor"], elUp)
        
    end
    
    def add_periodocoleta(periodo, fator, fator_valor, indice, valor, element)
        raise "Implement THIS!!!"
    end

    def add_unidadeprimaria(valorup, element)
        
        if (element.elements["Unidade"].nil? || 
                !element.elements["Unidade"].attribute("Primaria").value.eq?("#{valorup}"))
                 
            element.add_element("Unidade", {"Primaria"=>"#{valorup}"})
            puts "Adiciona Unidade"          
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
            puts "Adiciona #{ind}"          
        end
        
        elIndicador = element.get_elements("./#{ind}")

        if (elIndicador.size > 1) 
            raise "Error from parser! Too many elements from Indicador"
        end        
        
        elIndicador[0]
    end
    
    def add_outorga(cnpj, doc)
        
        if (!doc.root.elements["/root/ColetaSMP"].has_elements?)                
            doc.root.elements["/root/ColetaSMP"].add_element("Outorga", {"CNPJ"=>"#{cnpj}"})
        end
        elements = doc.root.get_elements("/root/ColetaSMP/Outorga[@CNPJ='#{cnpj}']")

        if (nil.equal?(elements) || elements.empty?) 
            raise "Error from parser! No Outorga element!"
        end
                
        if (elements.size > 1) 
            raise "Error from parser! Too many elements from Outorga"
        end

        elements[0]
    end
    
end

#Simulando Hash com elementos de um XML
items = {"Outorga"=>"05835916000185", 
  "Indicador"=>"SMP3", 
  "UnidadePrimaria"=>"00546", 
  "PeriodoColeta"=>"1", 
  "FatorPonderacao"=>"016", 
  "FatorPonderacaoValor"=>"1049", 
  "indice"=>"014", 
  "valor"=>"1038"}

# Simulando o carregamento dos indicadores
indicadores_str = <<END_OF_STRING
<Anatel>
    <Indice>
        <Outorga>05835916000185</Outorga>
        <Indicador>SMP3</Indicador>
        <UnidadePrimaria>00546</UnidadePrimaria>
        <PeriodoColeta>1</PeriodoColeta>
        <FatorPonderacao>016</FatorPonderacao>
        <FatorPonderacaoValor>1049</FatorPonderacaoValor>
        <indice>014</indice>
        <valor>1038</valor>
    </Indice>
    <Indice>
        <Outorga>05835916000185</Outorga>
        <Indicador>SMP3</Indicador>
        <UnidadePrimaria>00549</UnidadePrimaria>
        <PeriodoColeta>1</PeriodoColeta>
        <FatorPonderacao>016</FatorPonderacao>
        <FatorPonderacaoValor>259</FatorPonderacaoValor>
        <indice>014</indice>
        <valor>258</valor>
    </Indice>
    <Indice>
        <Outorga>05835916000185</Outorga>
        <Indicador>SMP3</Indicador>
        <UnidadePrimaria>00551</UnidadePrimaria>
        <PeriodoColeta>1</PeriodoColeta>
        <FatorPonderacao>016</FatorPonderacao>
        <FatorPonderacaoValor>20699</FatorPonderacaoValor>
        <indice>014</indice>
        <valor>20368</valor>
    </Indice>
</Anatel>
END_OF_STRING


#r = RgqAnatel.new("05835916000185", ParserXML.new(indicadores_str))
#r.build

anatel_str = <<END_OF_STRING
<root>
  <ColetaSMP ano="2012" mes="8" TipoArquivo="0" Identificador="stringxxxxx">
  </ColetaSMP>
</root>
END_OF_STRING


doc = REXML::Document.new anatel_str

formatter = RgqFormatter.new 

formatter.add_element_from_item(items, doc)

puts doc

