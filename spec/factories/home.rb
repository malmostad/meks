FactoryBot.define do
  factory :home do
    sequence(:name) { |n| "home-#{n}" }
    sequence(:phone) { |n| "040-34 10 #{n}" }
    sequence(:fax) { |n| "040-34 11 #{n}" }
    sequence(:address) { |n| "Adress-#{n}" }
    post_code { '210 00' }
    postal_town { 'Malmö' }
    guaranteed_seats { 70 }
    movable_seats { 20 }
    comment { 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' }
    type_of_cost { 'cost_per_day' }
    languages { create_list(:language, 2) }
    owner_type { create(:owner_type) }
    target_groups { create_list(:target_group, 2) }
    type_of_housings { create_list(:type_of_housing, 2) }
  end
end
