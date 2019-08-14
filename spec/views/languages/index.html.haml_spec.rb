RSpec.describe 'languages/index', type: :view do
  before(:each) do
    @languages = assign(:languages, create_list(:language, 2))
  end

  it 'renders a list of languages' do
    render
    assert_select 'tr>td', text: @languages.first.name, count: 1
    assert_select 'tr>td', text: @languages.first.name, count: 1
  end
end
