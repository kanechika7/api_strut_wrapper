# coding: UTF-8
module ApiStrutWrapper
  module StrutWrapper
    extend ActiveSupport::Concern

    module ClassMethods

      def api_strut_wrapper clazz, options={}
        table_name = clazz.to_s.tableize.gsub("/","_")
        file_name = clazz.to_s.underscore.gsub("/","_")
        actions = Strut::Model::Holder.new options

        class_eval do
          strut_controller clazz, create: [:copy]
          skip_before_filter :find_one ,only: [:show]
        end

        # index
        define_method :index do
          respond_index(instance_variable_get("@#{table_name}"),{
            t_json: Proc.new{ render json: clazz.index_api(params) }
          })
        end

        # show
        define_method :show do
          respond_show(instance_variable_get("@#{file_name}"),{
            t_json: Proc.new{ render json: clazz.show_api(params) }
          })
        end

        # create
        define_method :create do
          obj = instance_variable_get("@#{file_name}")
          respond_create(obj,{
            t_json: Proc.new{ render json: obj.as_json(as: :api) }
          })
        end

        # copy
        define_method :copy do
          obj = instance_variable_get("@#{file_name}")
          obj.attributes = clazz.find(params[:id]).copy_attributes
          respond_create(obj,{
            t_json: Proc.new{ render json: obj.as_json(as: :api) }
          })
        end

        # update
        define_method :update do
          obj = instance_variable_get("@#{file_name}")
          respond_update(obj,{
            t_json: Proc.new{ render json: obj.as_json(as: :api) }
          })
        end

        # destroy
        define_method :destroy do
          obj = instance_variable_get("@#{file_name}")
          respond_destroy(obj,{
            t_json: Proc.new{ render json: obj.as_json(as: :api) }
          })
        end
      end

    end

  end
end
