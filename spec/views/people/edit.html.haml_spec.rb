RSpec.describe 'people/edit', type: :view do
  before(:each) do
    @person = assign(:person, create(:person))
  end

  it 'renders the edit person form' do
    render

    assert_select 'form[action=?][method=?]', person_path(@person), 'post' do
      assert_select 'input#person_name[name=?]', 'person[name]'
      assert_select 'input#person_date_of_birth[name=?]', 'person[date_of_birth]'
      assert_select 'input#person_ssn_extension[name=?]', 'person[ssn_extension]'
      assert_select 'select#person_deregistered_reason_id[name=?]', 'person[deregistered_reason_id]'
      assert_select 'select#person_special_needs[name=?]', 'person[special_needs]'
    end
  end
end
