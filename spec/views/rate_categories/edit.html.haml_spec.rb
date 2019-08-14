RSpec.describe 'rate_categories/edit', type: :view do
  before(:each) do
    @rate_category = assign(:rate_category, create(:rate_category))
  end

  it 'renders the edit rate_category form' do
    render
    assert_select 'form[action=?][method=?]', rate_category_path(@rate_category), 'post' do
      assert_select 'button.add-term', text: 'Lägg till belopp', count: 1
    end
  end
end
