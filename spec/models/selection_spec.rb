require 'spec_helper'

describe Selection do
  describe :fuzzy_find_or_create do 
    it "creates a selection" do 
      select_hash = { 'select_type' => 'foo  type ', name: 'SOME  crazy NAME', user_created: false}
      selection = Selection.fuzzy_find_or_create(select_hash)
      expect(selection.select_type).to eq('foo_type')
      expect(selection.name).to eq('some crazy name')
      expect(selection.user_created).to be_false
    end
  end
end
