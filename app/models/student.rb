class Student < ActiveRecord::Base
    require 'csv'
    def self.to_csv(all_products, selected_columns)
        hasCount = selected_columns.find { |item| item =~ /count/i }
        selected_columns.reject!{|item| item =~ /count/i }
        
        CSV.generate do |csv|
            if hasCount
               csv << ["Count = " + all_products.length.to_s]
            end
            csv << selected_columns
            all_products.each do |product|
                csv << product.attributes.values_at(*selected_columns)
            end
        end
    end
    
    def self.to_j1_csv(yearSelected_int)
        new_students = {}
        new_students[ "CP" ] = where([ "(prim_deg_cat like ? or prim_deg_cat like ? or prim_deg_cat like ?) and prim_deg_maj_1 like ? and prim_deg like ?", "Summer "+yearSelected_int.to_s+"%", "Fall "+yearSelected_int.to_s+"%", "Spring "+(yearSelected_int+1).to_s+"%", "CP%", "M%" ]).count
        new_students[ "CE" ] = where([ "(prim_deg_cat like ? or prim_deg_cat like ? or prim_deg_cat like ?) and prim_deg_maj_1 like ? and prim_deg like ?", "Summer "+yearSelected_int.to_s+"%", "Fall "+yearSelected_int.to_s+"%", "Spring "+(yearSelected_int+1).to_s+"%", "CE%", "M%" ]).count
    
        prior_students = {}
        prior_students[ "CP" ] = where([ "(prim_deg_cat like ? or prim_deg_cat like ? or prim_deg_cat like ?) and prim_deg_maj_1 like ? and prim_deg like ?", "Summer "+(yearSelected_int-1).to_s+"%", "Fall "+(yearSelected_int-1).to_s+"%", "Spring "+yearSelected_int.to_s+"%", "CP%", "M%" ]).count
        prior_students[ "CE" ] = where([ "(prim_deg_cat like ? or prim_deg_cat like ? or prim_deg_cat like ?) and prim_deg_maj_1 like ? and prim_deg like ?", "Summer "+(yearSelected_int-1).to_s+"%", "Fall "+(yearSelected_int-1).to_s+"%", "Spring "+yearSelected_int.to_s+"%", "CE%", "M%" ]).count
        
        CSV.generate do |csv|
            csv << ["", "CS", "CE"]
            csv << ["Number of newly-admitted masters students", new_students[ "CP" ].to_s, new_students[ "CE" ].to_s]
            csv << ["Prior Year", prior_students[ "CP" ].to_s, prior_students[ "CE" ].to_s]
        end
    end
    
    def self.to_f3_csv(yearSelected)
        ;
    end
end
