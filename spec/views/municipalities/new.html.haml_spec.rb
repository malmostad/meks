RSpec.describe 'municipalities/new', type: :view do
  before(:each) do
    assign(:municipality, build(:municipality))
  end

  it 'renders new municipality form' do
    render

    assert_select 'form[action=?][method=?]', municipalities_path, 'post' do
      assert_select 'input#municipality_name[name=?]', 'municipality[name]'
    end
  end
end
