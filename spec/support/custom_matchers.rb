RSpec::Matchers.define :a_persisted_value do
  match { |actual| actual.persisted? }
end
