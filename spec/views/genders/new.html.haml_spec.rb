RSpec.describe 'genders/new', type: :view do
  before(:each) do
    assign(:gender, build(:gender))
  end

  it 'renders new gender form' do
    render

    assert_select 'form[action=?][method=?]', genders_path, 'post' do
      assert_select 'input#gender_name[name=?]', 'gender[name]'
    end
  end
end
