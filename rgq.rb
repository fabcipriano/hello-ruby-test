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
          
        indice = Hash.new
        
        element.elements.each
        
        indice["Outorga"] = element.get_elements("Outorga")[0].get_text();
        indice["Indicador"] = element.get_elements("Indicador")[0].get_text();
        indice["UnidadePrimaria"] = element.get_elements("UnidadePrimaria")[0].get_text();
        indice["PeriodoColeta"] = element.get_elements("PeriodoColeta")[0].get_text();
        indice["FatorPonderacao"] = element.get_elements("FatorPonderacao")[0].get_text();
        indice["FatorPonderacaoValor"] = element.get_elements("FatorPonderacaoValor")[0].get_text();
        indice["indice"] = element.get_elements("indice")[0].get_text();
        indice["valor"] = element.get_elements("valor")[0].get_text();
        handle.call(indice)           
      end 
        
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


r = RgqAnatel.new("05835916000185", ParserXML.new(indicadores_str))
r.build
