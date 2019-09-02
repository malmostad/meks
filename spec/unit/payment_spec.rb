RSpec.describe 'ExtraContributionCost' do
  let(:person) { create(:person) }
  let(:payment) do
    create(:payment,
           person: person,
           period_start: '2018-01-01',
           period_end: '2018-03-31',
           amount_as_string: '1234,56')
  end

  before(:each) do
    payment.reload
  end

  it 'should have correct amount for a payment' do
    payments = Economy::Payment.new(
      person.payments,
      from: '2018-01-01',
      to: '2018-03-31'
    )

    expect(payments.sum.round(2)).to eq 1_234.56
    expect(payments.as_formula).to eq '90*13.717333333333333333333333333'
    expect(payments.comments).to be_empty
  end

  it 'should have correct payment for a limiting full month report period' do
    payments = Economy::Payment.new(
      person.payments,
      from: '2018-01-01',
      to: '2018-01-31'
    )

    expect(payments.sum.round(2)).to eq 425.24
    expect(payments.as_formula).to eq '31*13.717333333333333333333333333'
  end

  it 'should have correct amount for an exteded interval' do
    payments = Economy::Payment.new(
      person.payments,
      from: '2018-01-01',
      to: '2018-12-31'
    )

    expect(payments.sum.round(2)).to eq 1_234.56
    expect(payments.as_formula).to eq '90*13.717333333333333333333333333'
  end

  it 'should have a comment' do
    payment.update_attribute(:comment, 'Foo bar kommentar')

    payments = Economy::Payment.new(
      person.payments,
      from: '2018-01-01',
      to: '2018-03-31'
    )

    expect(payments.comments.first).to eq 'Foo bar kommentar'
  end

  describe 'multiple payments' do
    let(:payment2) do
      create(:payment,
             person: person,
             period_start: '2018-04-01',
             period_end: '2018-06-30',
             amount_as_string: '6789,10',
             comment: 'fox barx')
    end

    before(:each) do
      payment2.reload
    end

    it 'should have correct amount' do
      payments = Economy::Payment.new(
        person.payments,
        from: '2018-01-01',
        to: '2018-06-30'
      )

      expect(payments.sum.round(2)).to eq 8_023.66
      expect(payments.as_formula).to eq '90*13.717333333333333333333333333+91*74.605494505494505494505494505'
      expect(payments.comments).not_to be_empty
    end
  end
end
