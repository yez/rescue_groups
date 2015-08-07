module RescueGroups
  # method: constantize
  # purpose: given a symbol, convert it into a class name and
  #            return the matching constant
  # param: constant - <symbol> - name of the constant
  # return: constant that is defined or it raises an error
  def self.constantize(constant)
    klass = ''

    constant.to_s.split('_').each do |piece|
      klass += "#{ (piece[0].ord - 32).to_i.chr }#{ piece[1..-1] }"
    end

    begin
      Object.const_get("RescueGroups::#{ klass }")
    rescue NameError => e
      # remove trailing s or es in case of has_many :animals
      if klass[-2..-1] == 'es'
        Object.const_get("RescueGroups::#{ klass[0..-3] }")
      else
        Object.const_get("RescueGroups::#{ klass[0..-2] }")
      end
    end
  end
end

require_relative './config/initializer'
