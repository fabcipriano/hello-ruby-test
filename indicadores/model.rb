#model.rb

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

