RSpec.describe 'people/new', type: :view do
  before(:each) do
    assign(:person, build(:person))
  end

  it 'renders new person form' do
    render

    assert_select 'form[action=?][method=?]', people_path, 'post' do
      assert_select 'input#person_name[name=?]', 'person[name]'
      assert_select 'select#person_deregistered_reason_id[name=?]', 'person[deregistered_reason_id]'
      assert_select 'select#person_special_needs[name=?]', 'person[special_needs]'
    end
  end
end
