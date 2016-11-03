class StatisticsController < ApplicationController
  def getForms
    unless File.exists? "public/downloads/#{session[ "yearSelected" ]}.csv"
      # Database Aggregation 
      new_students = {}
      new_students[ "CP" ] = Student.where([ "first_tamu_term like ? and prim_deg_maj_1 like ? and prim_deg like ?", session[ "yearSelected" ]+"%", "CP%", "M%" ]).count
      new_students[ "CE" ] = Student.where([ "first_tamu_term like ? and prim_deg_maj_1 like ? and prim_deg like ?", session[ "yearSelected" ]+"%", "CE%", "M%" ]).count
    
      prior_students = {}
      prior_students[ "CP" ] = Student.where([ "first_tamu_term like ? and prim_deg_maj_1 like ? and prim_deg like ?", (session[ "yearSelected" ].to_i-1).to_s+"%", "CP%", "M%" ]).count
      prior_students[ "CE" ] = Student.where([ "first_tamu_term like ? and prim_deg_maj_1 like ? and prim_deg like ?", (session[ "yearSelected" ].to_i-1).to_s+"%", "CE%", "M%" ]).count
    
      # Generate .csv file containing all the statistics
      CSV.open("public/downloads/#{session[ "yearSelected" ]}.csv", "wb") do |csv|
        csv << ["", "CS", "CE"]
        csv << ["Number of newly-admitted masters students", new_students[ "CP" ].to_s, new_students[ "CE" ].to_s]
        csv << ["Prior Year", prior_students[ "CP" ].to_s, prior_students[ "CE" ].to_s]
      end
    end
    
    @file_names = {:form1 => "The form for the number of masters students in #{session[ "yearSelected" ]}"}
    
    # render the page of downloading links
  end
  
  def getForm1
    send_file "public/downloads/#{session[ "yearSelected" ]}.csv", type: 'text/csv' and return
  end
end
