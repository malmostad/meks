require 'rails_helper'

RSpec.describe "refugees/show", type: :view do
  before(:each) do
    @refugee = assign(:refugee, create(:refugee))
  end

  it "renders attributes for refugee" do
    render
    expect(rendered).to match(/#{@refugee.name}/)
    expect(rendered).to match(/#{@refugee.registered}/)
    expect(rendered).to match(/#{@refugee.residence_permit_at}/)
    expect(rendered).to match(/#{@refugee.checked_out_to_our_city}/)
    expect(rendered).to match(/#{@refugee.temporary_permit_starts_at}/)
    expect(rendered).to match(/#{@refugee.temporary_permit_ends_at}/)
    expect(rendered).to match(/#{@refugee.municipality_placement_migrationsverket_at}/)
    expect(rendered).to match(/#{@refugee.municipality_placement_per_agreement_at}/)
    expect(rendered).to match(/#{@refugee.municipality_placement_comment}/)
    expect(rendered).to match(/#{@refugee.deregistered}/)
    expect(rendered).to match(/#{@refugee.deregistered_reason.name}/)

    expect(rendered).to match(/#{@refugee.ssn}/)
    expect(rendered).to match(/#{@refugee.ssns.map(&:full_ssn).join(', ')}/)

    expect(rendered).to match(/#{@refugee.dossier_number}/)
    expect(rendered).to match(/#{@refugee.dossier_numbers.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@refugee.age}/)
    expect(rendered).to match(/#{@refugee.gender.present? ? @refugee.gender.name : 'Ej angivet'}/)

    expect(rendered).to match(/#{@refugee.languages.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@refugee.countries.map(&:name).join(', ')}/)
    expect(rendered).to match(/#{@refugee.special_needs ? 'Ja' : 'Nej'}/)

    expect(rendered).to match(/#{@refugee.citizenship.present? ? @refugee.citizenship.name : 'Ej angivet'}/)
    expect(rendered).to match(/#{@refugee.citizenship}/)
    expect(rendered).to match(/#{@refugee.citizenship_at}/)
  end
end
