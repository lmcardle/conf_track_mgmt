require "talk"

describe Talk do
  before(:each) do
    @talk1 = Talk.new('Talk 1', 5)
  end

  it 'has a name' do
    @talk1.name.should eq('Talk 1')
  end
  
  it 'has a minutes property' do
    @talk1.minutes.should eq(5)
  end
end