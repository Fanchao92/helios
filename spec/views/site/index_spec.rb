require "rails_helper"

RSpec.describe "site/index.html.haml", type: :view do	
	before(:each) do
		@spreadsheet = FactoryGirl.create(:spreadsheet)
		@spreadsheets = FactoryGirl.create_list(:spreadsheet,3)
		render		
	end

	it "can render" do
		expect(rendered).to include("Taulbee Survey")
		expect(rendered).to include("Choose among existing data files")
	end

	it "include button" do
		expect(rendered).to include("Select")
		expect(rendered).to include("Save")
	end
end