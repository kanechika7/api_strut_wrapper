# coding: UTF-8
require 'api_strut_wrapper/model/api'
require 'api_strut_wrapper/model/data'
module ApiStrutWrapper
  module Document
    extend ActiveSupport::Concern
    include ApiStrutWrapper::Model::Api
    include ApiStrutWrapper::Model::Data

    module InstanceMethods

      def copy_attributes
        eval("#{self.class.to_s}::Scope::COPYATTRIBUTES").inject({}) do |attrs,name|
          attrs[name] = read_attribute(name)
          attrs
        end
      end

    end

  end
end
