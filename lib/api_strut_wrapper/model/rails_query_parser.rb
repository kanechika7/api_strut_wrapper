# coding: UTF-8
module ApiStrutWrapper
  module Model
    module RailsQueryParser
      extend ActiveSupport::Concern
      included do

        scope :rails_scope ,->(pms) do
          cs = scoped
          cs = cs.page(pms[:page]) unless pms[:page].blank?
          cs = cs.per(pms[:per])   unless pms[:per].blank?
          return cs
        end

      end

    end
  end
end
