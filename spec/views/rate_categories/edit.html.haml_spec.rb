require 'rails_helper'

RSpec.describe "rate_categories/edit", type: :view do
  before(:each) do
    @rate_category = assign(:rate_category, create(:rate_category))
  end

  it "renders the edit rate_category form" do
    render
    assert_select "form[action=?][method=?]", rate_category_path(@rate_category), "post" do
      assert_select "input#rate_category_name[name=?]", "rate_category[name]"
      assert_select "input#rate_category_from_age[name=?]", "rate_category[from_age]"
      assert_select "input#rate_category_to_age[name=?]", "rate_category[to_age]"
      assert_select "select#rate_category_legal_code_id[name=?]", "rate_category[legal_code_id]"
    end
  end
end
