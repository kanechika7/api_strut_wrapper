# coding: UTF-8
module ApiStrutWrapper
  module Model
    module Api
      extend ActiveSupport::Concern

      # mongo DB query -> arel
      include ApiStrutWrapper::Model::MongoQueryParser
      # rails DB query -> arel
      include ApiStrutWrapper::Model::RailsQueryParser

      module ClassMethods

        # interface
        def index_api pms, c_klass=Unit
          cs = scoped
                 .cookie_scope(c_klass.current)
                 .mongo_scope(pms)
                 .rails_scope(pms)

          return index_data(cs,pms)
        end

        def show_api pms
          c = where(id: pms[:id])

          return show_data(c,pms)
        end

      end
    end
  end
end
