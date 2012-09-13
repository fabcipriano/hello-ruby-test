# rgq.rb
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
        parse(@indicadores_str) {|indice| puts indice}
    end
    
    def parse(str)
        if (block_given?)
            indice = Hash.new 
            
            indice['indicador'] = str.scan(/<Indicador>(.*)<\/Indicador>/)                        
            indice['unidade_primaria'] = str.scan(/<UnidadePrimaria>(.*)<\/UnidadePrimaria>/)
            indice['periodo_coleta'] = str.scan(/<PeriodoColeta>(.*)<\/PeriodoColeta>/)
            indice['fator_ponderacao'] = str.scan(/<FatorPonderacao>(.*)<\/FatorPonderacao>/)
            indice['fator_valor'] = str.scan(/<FatorPonderacaoValor>(.*)<\/FatorPonderacaoValor>/)
            indice['indice'] = str.scan(/<indice>(.*)<\/indice>/)
            indice['valor'] = str.scan(/<valor>(.*)<\/valor>/)
            
            yield(indice)
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


puts indicadores_str

r = RgqAnatel.new("05835916000185", indicadores_str)

r.build
