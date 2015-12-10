require 'rails_helper'

RSpec.describe "refugees/edit", type: :view do
  before(:each) do
    @refugee = assign(:refugee, Refugee.create!(
      :name => "MyString",
      :deregistered_reason => "MyText",
      :special_needs => false,
      :comment => "MyText",
      :gender => nil,
      :home => nil,
      :countries => nil,
      :ssns => nil,
      :dossier_numbers => nil
    ))
  end

  it "renders the edit refugee form" do
    render

    assert_select "form[action=?][method=?]", refugee_path(@refugee), "post" do

      assert_select "input#refugee_name[name=?]", "refugee[name]"

      assert_select "textarea#refugee_deregistered_reason[name=?]", "refugee[deregistered_reason]"

      assert_select "input#refugee_special_needs[name=?]", "refugee[special_needs]"

      assert_select "textarea#refugee_comment[name=?]", "refugee[comment]"

      assert_select "input#refugee_gender_id[name=?]", "refugee[gender_id]"

      assert_select "input#refugee_home_id[name=?]", "refugee[home_id]"

      assert_select "input#refugee_countries_id[name=?]", "refugee[countries_id]"

      assert_select "input#refugee_ssns_id[name=?]", "refugee[ssns_id]"

      assert_select "input#refugee_dossier_numbers_id[name=?]", "refugee[dossier_numbers_id]"
    end
  end
end
