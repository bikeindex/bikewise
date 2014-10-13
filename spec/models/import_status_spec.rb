require 'spec_helper'

describe ImportStatus do
  describe :validations do
    it { should validate_presence_of :source }
    it { should validate_uniqueness_of :source }
    it { should serialize :info_hash }
  end
end
