module HasOneSoftDelete

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module InstanceMethods

  end # InstanceMethods

  module ClassMethods

    def has_one_soft_delete(subject,options={})
      base = options[:base]
      base ||= self

      subjects = subject.to_s.pluralize.to_sym
      
      base.has_one subject, options

    end

  end # ClassMethods

end
