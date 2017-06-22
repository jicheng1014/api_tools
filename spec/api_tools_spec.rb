require "spec_helper"

RSpec.describe ApiTools do
  it "has a version number" do
    expect(ApiTools::VERSION).not_to be nil
  end
end
