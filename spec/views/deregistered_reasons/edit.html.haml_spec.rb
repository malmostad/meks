RSpec.describe 'moved_out_reasons/edit', type: :view do
  before(:each) do
    @moved_out_reason = assign(:moved_out_reason, create(:moved_out_reason))
  end

  it 'renders the edit moved_out_reason form' do
    render

    assert_select 'form[action=?][method=?]', moved_out_reason_path(@moved_out_reason), 'post' do
      assert_select 'input#moved_out_reason_name[name=?]', 'moved_out_reason[name]'
    end
  end
end
