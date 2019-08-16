RSpec.describe 'people/search', type: :view do
  before(:each) do
    @people = assign(:people, create_list(:person, 2))
  end

  it 'renders a list of people' do
    render
    assert_select 'tr>td', text: @people.first.name, count: 1
    assert_select 'tr>td', text: @people.second.name, count: 1
    assert_select 'tr>td', text: @people.first.dossier_number, count: 1
    assert_select 'tr>td', text: @people.first.ssn, count: 1
    assert_select 'tr>td', text: @people.first.gender.name, count: 1
    assert_select 'tr>td', text: @people.first.countries.map(&:name).join(', '), count: 1
  end
end
