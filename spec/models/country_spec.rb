require 'spec_helper'

describe Country do
  describe :validations do
    it { should validate_presence_of :name }
    it { should validate_presence_of :iso }
    it { should validate_uniqueness_of :iso }
    it { should validate_uniqueness_of :name }
  end
end
