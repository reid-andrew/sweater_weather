class UsersSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :api_key, if: proc { |record| record.id }
  attributes :error, if: proc { |record| !record.id }
end
