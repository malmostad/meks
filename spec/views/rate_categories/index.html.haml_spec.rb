RSpec.describe 'rate_categories/index', type: :view do
  before(:each) do
    @rate_categories = assign(:rate_categories, create_list(:rate_category, 2))
  end

  it 'renders a list of rate_categories' do
    render
    assert_select 'tr>td', text: @rate_categories.first.human_name, count: 2
  end
end
