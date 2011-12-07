# coding: UTF-8
#require 'api_strut_wrapper/document'
#require 'api_strut_wrapper/strut_wrapper'
module ApiStrutWrapper
  require File.join(File.dirname(__FILE__), 'api_strut_wrapper/document')
  require File.join(File.dirname(__FILE__), 'api_strut_wrapper/strut_wrapper')
  class ApiStrutWrapper::Error < StandardError; end
end

