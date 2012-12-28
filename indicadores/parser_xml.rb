require "rexml/document"

class ParserXML
    
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

