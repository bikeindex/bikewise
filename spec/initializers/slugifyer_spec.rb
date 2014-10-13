require 'spec_helper'

describe Slugifyer do
  describe :slugify do 
    it "should remove special characters, downcase and strip" do
      output = Slugifyer.slugify('SOMe ***& thing AND StuFFF   ')
      expect(output).to eq('some______thing_and_stufff')
    end
  end
end
