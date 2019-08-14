RSpec.describe 'languages/new', type: :view do
  before(:each) do
    assign(:language, build(:language))
  end

  it 'renders new language form' do
    render

    assert_select 'form[action=?][method=?]', languages_path, 'post' do
      assert_select 'input#language_name[name=?]', 'language[name]'
    end
  end
end
