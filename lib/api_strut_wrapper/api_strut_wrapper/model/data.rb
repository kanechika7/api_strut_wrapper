# coding: UTF-8

#
# - How To -
# Model 
#
# class Model
#   module Scope
#
#     included IndexAndShowData::Document
#     
#     INDEX_SELECTS  = %w(id type me)
#     INDEX_METHODS  = %w()
#     INDEX_INCLUDES = []
#     SHOW_SELECTS   = %w(id type me)
#     SHOW_METHODS   = %w()
#     SHOW_INCLUDES  = [:questions=>[:answers]]
#
#

module ApiStrutWrapper
  module Model
    module Data
      extend ActiveSupport::Concern
      included do

        # select
        scope :select_index   ,->(pms){ select(selects_from_params(pms,'INDEX').join(',')) } # select(respond_to?(:index_selects) ? send(:index_selects) : eval("#{self.to_s}::Scope::INDEX_SELECTS").join(','))
        scope :select_show    ,->(pms){ select(selects_from_params(pms,'SHOW').join(',')) } #select(respond_to?(:show_selects) ? send(:show_selects) : eval("#{self.to_s}::Scope::SHOW_SELECTS").join(','))

        # includes
        scope :includes_index ,->(pms){ includes(includes_from_params(pms,'INDEX')) } #includes(respond_to?(:index_includes) ? send(:index_includes) : eval("#{self.to_s}::Scope::INDEX_INCLUDES"))
        scope :includes_show  ,->(pms){ includes(includes_from_params(pms,'SHOW')) } #includes(respond_to?(:show_includes) ? send(:show_includes) : eval("#{self.to_s}::Scope::SHOW_INCLUDES"))

        # for data
        scope :index_data_filter ,->(pms){ select_index(pms).includes_index(pms) }
        scope :show_data_filter  ,->(pms){ select_show(pms).includes_show(pms) }

      end

      module ClassMethods

        def includes_from_params pms,aktion='INDEX'
          #pms[:includes].blank? ? eval("#{self.to_s}::Scope::#{aktion}_INCLUDES") : ((eval("#{self.to_s}::Scope::#{aktion}_INCLUDES") + includes_parser(pms[:includes])).uniq)
          includes_parser(pms[:includes])
        end
        def selects_from_params pms,aktion='INDEX'
          pms[:selects].blank? ? eval("#{self.to_s}::Scope::#{aktion}_SELECTS") : ((eval("#{self.to_s}::Scope::#{aktion}_SELECTS") + pms[:selects].split(',').map{|s| s.to_sym }).uniq)
        end

        def includes_parser str
          return [] if str.blank?
          eval(('['+str+']').gsub('-','=').gsub('(','[').gsub(')',']').gsub('[','[:').gsub(',',',:'))
        end


        # - index -
        def index_data cs,pms={}
          { :current_page => ( cs.current_page if cs.methods.include?(:current_page) ),
            :num_pages    => ( cs.num_pages  if cs.methods.include?(:num_pages) ),
            :first_page?  => ( cs.first_page?  if cs.methods.include?(:first_page?) ),
            :last_page?   => ( cs.last_page?  if cs.methods.include?(:last_page?) ),
            :total_count  => ( cs.total_count  if cs.methods.include?(:total_count) ),
            :rows         => to_index_data(cs.index_data_filter(pms),pms,includes_from_params(pms,'INDEX')) }
        end

        # - show -
        def show_data c,pms={}
          to_show_data(c.show_data_filter.first,pms,includes_from_params(pms,'SHOW'))
        end


        def to_index_data cs,pms={},ins=[]
          cs.map do |c|
            to_one_data c,pms,ins,'INDEX'
          end
        end


        def to_show_data c,pms={},ins=[]
          to_one_data c,pms,ins,'SHOW'
        end


        def to_one_data c,pms,ins,aktion
          h = Hash[*((selects_from_params(pms,aktion))+eval("#{self.to_s}::Scope::#{aktion}_METHODS")).map{|f| [f,c.send(f)] }.flatten]
          ins.each do |t|
            if t.is_a? Hash
              t.each_pair do |k,vs|
                k_data = c.send(k)
                if !k_data.blank?
                  if c.methods.include?("#{k}_id".to_sym)
                    k_data = k.to_s.classify.constantize.to_show_data(k_data,{},vs) 
                  else
                    k_data = k.to_s.classify.constantize.to_index_data(k_data,{},vs)
                  end
                end
                h.merge!({ k => k_data })
              end
            else
              c_data = c.send(t)
              if !c_data.blank?
                if c.methods.include?("#{t}_id".to_sym)
                  c_data = t.to_s.classify.constantize.to_show_data(c_data)   # belongs_to の場合
                else
                  c_data = t.to_s.classify.constantize.to_index_data(c_data)  # has_many の場合
                end
              end
              h.merge!({ t => c_data })
            end
          end
          return h
        end


      end
    end
  end
end
