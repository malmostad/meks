RSpec.describe 'people/show', type: :view do
  before(:each) do
    @person = assign(:person, create(:person))
  end

  it 'renders attributes for person' do
    render
    expect(rendered).to match(/#{@person.name}/)
    expect(rendered).to match(/#{@person.registered}/)
    expect(rendered).to match(/#{@person.residence_permit_at}/)
    expect(rendered).to match(/#{@person.checked_out_to_our_city}/)
    expect(rendered).to match(/#{@person.temporary_permit_starts_at}/)
    expect(rendered).to match(/#{@person.temporary_permit_ends_at}/)
    expect(rendered).to match(/#{@person.municipality_placement_migrationsverket_at}/)
    expect(rendered).to match(/#{@person.municipality_placement_comment}/)
    expect(rendered).to match(/#{@person.deregistered}/)

    expect(rendered).to match(/#{@person.ssn}/)
    expect(rendered).to match(/#{@person.ssns.map(&:full_ssn).join(', ')}/)

    expect(rendered).to match(/#{@person.dossier_number}/)
    expect(rendered).to match(/#{@person.dossier_numbers.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@person.age}/)
    expect(rendered).to match(/#{@person.gender.present? ? @person.gender.name : 'Ej angivet'}/)

    expect(rendered).to match(/#{@person.languages.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@person.countries.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@person.special_needs ? 'Ja' : 'Nej'}/)
  end
end
