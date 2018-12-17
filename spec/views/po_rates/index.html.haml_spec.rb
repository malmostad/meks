RSpec.describe 'po_rates/index', type: :view do
  before(:each) do
    @po_rates = assign(:po_rates, create_list(:po_rate, 1))
  end

  it 'renders a list of po_rates' do
    render
    assert_select 'tr>td', text: "#{@po_rates.first.start_date}–#{@po_rates.first.end_date}", count: 1
  end
end
