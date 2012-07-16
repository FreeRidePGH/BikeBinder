module HasOneSoftDelete

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module InstanceMethods

  end # InstanceMethods

  module ClassMethods

    def has_one_and_soft_delete(cancelable,options={})
      base = options[:base]
      base ||= self
      cancelables = cancelable.to_s.pluralize.to_sym
      
      base.has_many cancelables, options

      base.send(:include, InstanceMethods)

      # Define Method
      # http://apidock.com/ruby/Module/define_method
      # http://rails-bestpractices.com/posts/16-dry-metaprogramming

      base.send(:define_method, "active_#{cancelables.to_s}") do |*args|
        force_reload = args[0]
        force_reload ||= false
        send(cancelables, force_reload).where{state != 'trash'}
      end

      base.send(:define_method, "canceled_#{cancelables.to_s}") do |*args|
        force_reload = args[0]
        force_reload ||= false
        send(cancelables, force_reload).where{state == 'trash'}
      end

      # association(force_reload = false)
      base.send(:define_method, cancelable.to_s) do |*args|
        force_reload = args[0]
        force_reload ||= false
        send("active_#{cancelables}", force_reload).first
      end

      # association=(associate)
      base.send(:define_method, "#{cancelable.to_s}=") do |associate|
        if associate.nil?
          obj = send(cancelable)
          send(cancelables).delete(obj) unless obj.nil?
        else
          send(cancelables)<< associate
        end
      end

      # build_association(attributes = {})
      base.send(:define_method, "build_#{cancelable.to_s}") do |*args|
        attributes = args[0]
        attributes ||= {}
        send(cancelables).build(attributes)
      end

      # create_association(attributes = {})
      base.send(:define_method, "create_#{cancelable.to_s}") do |*args|
        attributes = args[0]
        attributes ||= {}
        send(cancelables).create(attributes)
      end

    end



  end # ClassMethods

end
