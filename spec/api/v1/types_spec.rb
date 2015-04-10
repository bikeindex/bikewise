require 'spec_helper'

describe 'Types API V1' do
  describe 'all' do 
    it "renders types" do
      @hazard = Selection.create(name: 'foo hazard', select_type: 'hazard', user_created: false)
      get '/api/v1/types'
      response.code.should == '200'
      result = JSON.parse(response.body)['types']
      expect(result.count).to be > 0
      # expect(result[0]['id']).to eq(@hazard.id)
      expect(result[0]['name']).to eq('foo hazard')
    end

  end

  describe 'select_type' do 
    before :each do 
      @hazard = Selection.create(name: 'foo hazard', select_type: 'hazard', user_created: false)
      @locking = Selection.create(name: 'foo locking', select_type: 'locking', user_created: false)
      @locking_defeat = Selection.create(name: 'foo locking_defeat', select_type: 'locking_defeat', user_created: false)
      @condition = Selection.create(name: 'foo condition', select_type: 'condition', user_created: false)
      @location = Selection.create(name: 'foo location', select_type: 'location', user_created: false)
      @crash = Selection.create(name: 'foo crash', select_type: 'crash', user_created: false)
      @vehicle = Selection.create(name: 'foo vehicle', select_type: 'vehicle', user_created: false)
      @lighting = Selection.create(name: 'foo lighting', select_type: 'lighting', user_created: false)
      @visibility = Selection.create(name: 'foo visibility', select_type: 'visibility', user_created: false)
      @injury_severity = Selection.create(name: 'foo injury_severity', select_type: 'injury_severity', user_created: false)
      @experience_level = Selection.create(name: 'foo experience_level', select_type: 'experience_level', user_created: false)
      @gender = Selection.create(name: 'foo gender', select_type: 'gender', user_created: false)
    end
    
    xit "renders hazards" do
      get '/api/v1/types/hazard'
      pp response
      response.code.should == '200'
      result = JSON.parse(response.body)['types']
      # pp result
      expect(result.count).to be > 0
      # expect(result[0]['id']).to eq(@hazard.id)
      expect(result[0]['name']).to eq('foo hazard')
    end

    xit "renders user generated hazards" do
      user_hazard = Selection.create(name: 'user hazard', select_type: 'hazard')
      get '/api/v1/types/hazard?include_user_created=true'
      result = JSON.parse(response.body)['types']
      # pp result
      response.code.should == '200'
      expect(result.count).to be(2)
    end

    xit "renders all the types" do 
      types = %w(hazard locking locking_defeat condition location crash vehicle lighting visibility injury_severity experience_level gender)
      types.each do |type|
        url = "/api/v1/types/#{type}"
        get url
        response.code.should == '200'
        result = JSON.parse(response.body)['types']
        pp url unless result.count == 1
        expect(result.count).to be(1)
        expect(result[0]['name']).to eq("foo #{type}")
      end
    end
  end

end