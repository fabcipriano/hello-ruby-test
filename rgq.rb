# rgq.rb

require "rexml/document"

class SMP
    def initialize (nome)
        @nome = nome
        @unidades = Array.new
    end

    def append (unidade)
        @unidades.push(unidade)
    end
end

class Unidade
    def initialize (primaria)
        @primaria = primaria
        @periodos = Array.new 
    end
    
    def append (periodo)
        @periodos.push(periodo)
    end
end

class Periodo
    def initialize (coleta, fator_ponderacao, fator_valor, indice, valor)
        @coleta = coleta
        
        @fator_ponderacao, @fator_valor, @indice, @valor = fator_ponderacao, fator_valor, indice, valor
        
    end
end

class RgqAnatel
    
    def initialize (cnpj, indicadores_str)
        @cnpj = cnpj
        @indicadores_str = indicadores_str
        smps = Array.new 
    end
    
    def build
        
        #TODO: So falta criar a rotina que pega os Maps e transforma em XML ANATEL aqui.
        parse(@indicadores_str) {|indice| puts indice}
    end
    
    def parse(str)
        if (block_given?)
            
            doc = REXML::Document.new str
            
            doc.elements.each("Anatel/Indice") do |element| 
                
                indice = Hash.new
                
                indice["Outorga"] = element.get_elements("Outorga")[0].get_text();
                indice["Indicador"] = element.get_elements("Indicador")[0].get_text();
                indice["UnidadePrimaria"] = element.get_elements("UnidadePrimaria")[0].get_text();
                indice["PeriodoColeta"] = element.get_elements("PeriodoColeta")[0].get_text();
                indice["FatorPonderacao"] = element.get_elements("FatorPonderacao")[0].get_text();
                indice["FatorPonderacaoValor"] = element.get_elements("FatorPonderacaoValor")[0].get_text();
                indice["indice"] = element.get_elements("indice")[0].get_text();
                indice["valor"] = element.get_elements("valor")[0].get_text();
                
                yield(indice) 
            end 
            
            
        else 
            puts "Fail to parse indicadores. There is no Block of code to use!!!"
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


r = RgqAnatel.new("05835916000185", indicadores_str)

r.build
