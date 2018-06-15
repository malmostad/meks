FactoryBot.define do
  factory :payment_import do
    user { create(:user) }
    imported_at { DateTime.now }
    raw { 'raw file' }

    factory :payment_import_with_payment do
      after(:create) do |payment_import|
        create(:payment, payment_import: payment_import)
      end
    end
  end
end
