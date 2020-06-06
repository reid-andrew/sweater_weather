module Parseable
  private

  def parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
