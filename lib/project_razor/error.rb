# EMC Confidential Information, protected under EMC Bilateral Non-Disclosure Agreement.
# Copyright © 2012 EMC Corporation, All Rights Reserved

$std_counter = 0

require "project_razor/error/generic"
require "require_all"

module ProjectRazor
  module Error

    # This creates additional error classes with appropriate http_err code and log_severity.
    def self.create_class(new_class, error_code, val={}, msg='', parent_str='ProjectRazor::Error::Generic')
      raise TypeError unless val.is_a? Hash
      # Make sure we don't specify any instance variable other than what's in Generic Error attr_reader.
      raise Error, "invalid settings #{val.inspect}" unless (val.keys - ['@http_err', '@log_severity']).empty?

      parent = ProjectRazor::Error.contantize(parent_str)
      parent_module_str = parent_str.split('::')[0..-2].join('::')
      parent_module = ProjectRazor::Error.contantize(parent_module_str)

      c = Class.new(parent) do
        attr_reader :data
        define_method :initialize do |message, data={}|
          custom_message = [msg, message].reject(&:empty?).join(' ')
          super(custom_message)
          val.each do |k, v|
            instance_variable_set(k, v)
          end
          instance_variable_set('@std_err', error_code)
          instance_variable_set('@data', data)
        end
      end

      parent_module.const_set new_class, c
    end

    def self.contantize(val)
      raise TypeError unless val.is_a? String
      val.split('::').reduce(Module, :const_get)
    end

    # FIXME: This require is here because other modules needs access to methods in this module.
    require_rel "error/"

  end
end
