RSpec.describe 'homes/edit', type: :view do
  before(:each) do
    @home = assign(:home, create(:home))
  end

  it 'renders the edit home form' do
    render

    assert_select 'form[action=?][method=?]', home_path(@home), 'post' do
      assert_select 'input#home_name[name=?]', 'home[name]'
      assert_select 'input#home_phone[name=?]', 'home[phone]'
      assert_select 'input#home_fax[name=?]', 'home[fax]'
      assert_select 'input#home_address[name=?]', 'home[address]'
      assert_select 'input#home_post_code[name=?]', 'home[post_code]'
      assert_select 'input#home_postal_town[name=?]', 'home[postal_town]'
      assert_select 'select#home_type_of_housing_ids[name=?]', 'home[type_of_housing_ids][]'
      assert_select 'select#home_owner_type_id[name=?]', 'home[owner_type_id]'
      assert_select 'select#home_target_group_ids[name=?]', 'home[target_group_ids][]'
      assert_select 'input#home_guaranteed_seats[name=?]', 'home[guaranteed_seats]'
      assert_select 'input#home_movable_seats[name=?]', 'home[movable_seats]'
      assert_select 'select#home_language_ids[name=?]', 'home[language_ids][]'
      assert_select 'textarea#home_comment[name=?]', 'home[comment]'
    end
  end
end
