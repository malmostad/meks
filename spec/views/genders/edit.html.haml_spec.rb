RSpec.describe 'genders/edit', type: :view do
  before(:each) do
    @gender = assign(:gender, create(:gender))
  end

  it 'renders the edit gender form' do
    render

    assert_select 'form[action=?][method=?]', gender_path(@gender), 'post' do
      assert_select 'input#gender_name[name=?]', 'gender[name]'
    end
  end
end
