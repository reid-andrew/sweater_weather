class UsersSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :api_key, if: Proc.new { |record| record.id }
  attributes :error, if: Proc.new { |record| !record.id }
end
