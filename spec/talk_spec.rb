require "talk"

describe Talk do
  before(:each) { @talk = Talk.new('Talk 1', 5) }

  it 'has a has the correct properties on object initialization' do
    @talk.name.should eq('Talk 1')
    @talk.minutes.should eq(5)
    @talk.start_time.should eq(nil)
    @talk.military_time_start.should eq(nil)
  end
  
  it 'converts a talks minutes into hours' do
    @talk.talk_length.should eq(5)
    @talk.minutes = 95
    @talk.talk_length.should eq(135)
  end

  it 'has a formatted_start_time method' do
    @talk.formatted_start_time.should eq("No Start Time has been assigned")
    @talk.start_time = 1035
    @talk.formatted_start_time.should eq("10:35 AM")
  end

  it 'has a formatted_minutes method' do
    @talk.formatted_minutes.should eq("lightning")
    @talk.minutes = 30
    @talk.formatted_minutes.should eq("30min")
    @talk.minutes = 95
    @talk.formatted_minutes.should eq("95min")
    @talk.minutes = nil
    @talk.formatted_minutes.should eq("")
  end

  it 'has a to_s method' do
    @talk.to_s.should eq("No Start Time has been assigned Talk 1 lightning")
    @talk.start_time = 1015
    @talk.to_s.should eq("10:15 AM Talk 1 lightning")
    @talk.minutes = 95
    @talk.to_s.should eq("10:15 AM Talk 1 95min")
  end

end