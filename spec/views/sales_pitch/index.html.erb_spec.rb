require 'spec_helper'

describe 'sales_pitch/index.html.erb' do
  it "displays login form" do
    render
    response.should contain('Login')
  end
end