RSpec.describe 'languages/edit', type: :view do
  before(:each) do
    @language = assign(:language, create(:language))
  end

  it 'renders the edit language form' do
    render

    assert_select 'form[action=?][method=?]', language_path(@language), 'post' do
      assert_select 'input#language_name[name=?]', 'language[name]'
    end
  end
end
