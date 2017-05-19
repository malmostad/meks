FactoryGirl.define do
  factory :payment_import do
    user { create(:user) }
    imported_at { DateTime.now }
    number_of_records { 20 }

    factory :payment_import_with_payment do
      after(:create) do |payment_import|
        create(:payment, payment_import: payment_import)
      end
    end
  end
end
