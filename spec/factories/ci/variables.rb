FactoryGirl.define do
  factory :ci_variable, class: Ci::Variable do
    sequence(:key) { |n| "VARIABLE_#{n}" }
    value 'VARIABLE_VALUE'

    trait(:protected) do
      protected true
    end

    project factory: :empty_project
  end
end
