
class ::Hash

  def to_obj
    self.each do |k,v|
      if v.kind_of? Hash
        v.to_obj
      end
      k=k.gsub(/\.|\s|-|\/|\'/, '_').downcase.to_sym
      self.instance_variable_set("@#{k}", v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      ## create the setter that sets the instance variable
    self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
    return self
  end

  end

