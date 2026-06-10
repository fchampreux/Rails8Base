require 'rails_helper'

RSpec.describe "Server homepage", type: :feature do
 
    it "displays successfully" do
      visit root_path
 
      expect(page).to have_http_status(200)
    end
  end