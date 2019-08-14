RSpec.describe 'refugees/search', type: :view do
  before(:each) do
    @refugees = assign(:refugees, create_list(:refugee, 2))
  end

  it 'renders a list of refugees' do
    render
    assert_select 'tr>td', text: @refugees.first.name, count: 1
    assert_select 'tr>td', text: @refugees.second.name, count: 1
    assert_select 'tr>td', text: @refugees.first.dossier_number, count: 1
    assert_select 'tr>td', text: @refugees.first.ssn, count: 1
    assert_select 'tr>td', text: @refugees.first.gender.name, count: 1
    assert_select 'tr>td', text: @refugees.first.countries.map(&:name).join(', '), count: 1
  end
end
