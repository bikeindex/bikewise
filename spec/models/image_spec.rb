require 'spec_helper'

describe Image do
  describe :validations do
    it { should belong_to :incident }
  end


end
