require 'spec_helper'

describe WelcomeController do

  describe 'index' do 
    before do 
      get :index
    end
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe 'developer' do 
    before do 
      get :developer
    end
    it { should respond_with(:success) }
    it { should render_template(:developer) }
  end
end