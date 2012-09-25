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
        
        
        elOutorga = find_or_create_outorga(h["Outorga"], doc)
        
        if (nil.equal?(elOutorga) || elOutorga.empty?) 
            raise "Error from parser! No Outorga element!"
        end
        
        if (elOutorga.size > 1) 
            raise "Error from parser! Too many elements from Outorga"
        end
        
        
        
    end
    
    def find_outorga(cnpj, doc)
        elements = doc.root.get_elements("/root/ColetaSMP/Outorga[@CNPJ='#{cnpj}']")
        elements
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
    <Outorga CNPJ="05835916000185-">
    </Outorga>
  </ColetaSMP>
</root>
END_OF_STRING


doc = REXML::Document.new anatel_str

formatter = RgqFormatter.new 

formatter.add_element_from_item(items, doc)

