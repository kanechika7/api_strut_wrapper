# coding: UTF-8
module ApiStrutWrapper
  module Model
    module MongoQueryParser
      extend ActiveSupport::Concern
      included do

        scope :mongo_scope ,->(pms) do
          cs = scoped
          cs = cs.mongoquery_to_filter(pms) # filter -> arel
          cs = cs.mongoquery_to_where(pms[:query]) unless pms[:query].blank? # query -> arel
          cs = cs.mongoquery_to_sort(pms[:sort])   unless pms[:sort].blank?  # sort  -> arel(order)
          cs = cs.mongoquery_to_offset(pms[:skip]) unless pms[:skip].blank?  # skip  -> arel(offset)
          cs = cs.mongoquery_to_limit(pms[:limit]) unless pms[:limit].blank? # limit -> arel(limit)
          return cs
        end


        # mongo query -> sql where
        #   filter_a=1 => where(:a,1)
        scope :mongoquery_to_filter ,->(ps) do
          where(Hash[*ps.to_a.map{|a| a[0]=~/^filter_(.*)/ ? [$1,a[1]] : nil }.flatten.compact])
        end

        # mongo query -> sql where
        #   filter_a=1 => where(:a,1)
        scope :mongoquery_to_where ,->(q) do
          scoped
        end

        # mongo sort  -> sql sort
        #   ts:-1 => order('ts DESC')
        #   ts:1  => order('ts ASC')
        scope :mongoquery_to_sort  ,->(q) do
          order("#{$1.strip} #{$2=='-1' ? 'DESC' : 'ASC'}") if q =~ /(.*)\:(.*)/
        end

        # mongo skip  -> sql offset
        scope :mongoquery_to_offset,->(n) do
          offset(n.to_i)
        end

        # mongo limit -> sql limit
        scope :mongoquery_to_limit ,->(n) do
          limit(n.to_i)
        end

      end

    end
  end
end
