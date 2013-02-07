class NokoSabi 
  attr_accessor :root
  
  def initialize(nokogiri_doc)
    @root = nokogiri_doc
  end
  
  def method_missing(method, *args, &block)
    if a = @root.attr(method.to_s)
      return a.text
    end    
    if @root.children.map(&:name).include? method.to_s
      inner_doc = @root.css(method.to_s)
      if @root.children.size > 1 && @root.children.map(&:name).uniq.size ==1
        return inner_doc.map{|d| NokoSabi.new(d)}
      end
      if inner_doc.children.size == 1 && inner_doc.children.first.class == Nokogiri::XML::Text
        text = inner_doc.children.first.text
        attributes = inner_doc.first.attributes.keys
        attributes.each do |a|
          text.instance_variable_set '@the_answer', inner_doc.first.attributes[a.to_s].value
          eval "def text.#{a}; self.instance_variable_get '@the_answer';end"
        end
        return text
      end
      if (inner_doc.respond_to? :size) && (inner_doc.size > 1)
        return inner_doc.map{|d| (d.children.size == 1 && d.children.first.class == Nokogiri::XML::Text) ? d.children.first.text : NokoSabi.new(d)}
      end
      return NokoSabi.new(inner_doc)
    end
    return nil
  end  
  
  def m
    @root.children.map(&:name).sort
  end
end
