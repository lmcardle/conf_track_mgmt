require 'track'

describe Track do

  before(:each) { @track = Track.new("Track 1") }
  
  it 'has the correct properties' do
    @track.track_name.should eq("Track 1")
    @track.morning_time.should eq(0)
    @track.afternoon_time.should eq(0)
    @track.am_end_time.should eq(900)
    @track.pm_end_time.should eq(100)
    @track.pm_24hr_start.should eq(1300)
    @track.talks.count.should eq(2)
    @track.talks.first.name.should eq("Lunch")
    @track.talks.last.name.should eq("Networking Event")
  end

  it 'has a talk object for lunch at noon' do
    lunch_slot = @track.talks.first
    lunch_slot.name.should eq("Lunch")
    lunch_slot.minutes.should eq(nil)
    lunch_slot.start_time.should eq(1200)
    lunch_slot.military_time_start.should eq(1200)
  end

  it 'has a talk object for Networking Event at 500' do
    networking_slot = @track.talks.last
    networking_slot.name.should eq("Networking Event")
    networking_slot.minutes.should eq(nil)
    networking_slot.start_time.should eq(500)
    networking_slot.military_time_start.should eq(1700)
  end

  it 'has constant values' do
    Track::MORNING_MAX.should eq(180)
    Track::AFTERNOON_MAX.should eq(240)
    Track::MORNING_KEY.should eq(:morning)
    Track::AFTERNOON_KEY.should eq(:afternoon)
  end

  it 'returns the the total running time for morning and afternoon sessions' do
    @track.total_session_time(:morning).should eq(0)
    @track.total_session_time(:afternoon).should eq(0)
    talk = Talk.new("Sample Talk Title", 95)
    @track.add_talk(talk, :morning)
    @track.add_talk(talk, :morning)
    @track.total_session_time(:morning).should eq(190)
    @track.add_talk(talk, :afternoon)
    @track.add_talk(talk, :afternoon)
    @track.total_session_time(:afternoon).should eq(190)
  end

  it 'returns max number of minutes each session can have' do
    @track.max_min(:morning).should eq(180)
    @track.max_min(:afternoon).should eq(240)
  end

  it 'determins if a given session has available time to add new talk' do
    talk = Talk.new("Test Talk", 95)
    @track.available_time?(talk, :morning).should be_true
    @track.add_talk(talk, :morning)
    @track.available_time?(talk, :morning).should be_false
    @track.available_time?(talk, :afternoon).should be_true
    3.times { @track.add_talk(talk, :afternoon) }
    @track.available_time?(talk, :afternoon).should be_false
  end

  it 'assigns talk.start_time to the tracks currently ending time' do
    talk = Talk.new("Test Talk", 90)
    @track.add_talk_start_time(talk, :morning)
    talk.start_time.should eq(@track.am_end_time)
    @track.add_talk_start_time(talk, :afternoon)
    talk.start_time.should eq(@track.pm_end_time)
  end

  it 'schedules the sessions ending time' do
    @track.am_end_time.should eq(900)
    @track.pm_end_time.should eq(100)
    @track.pm_24hr_start.should eq(1300)
    talk = Talk.new("Test Talk", 90)
    @track.schedule_end_time(talk, :morning)
    @track.am_end_time.should eq(1030)
    @track.schedule_end_time(talk, :afternoon)
    @track.pm_end_time.should eq(230)
    @track.pm_24hr_start.should eq(1430)
  end

  it 'calculates the correct end time for a track session based on a talks length' do
    @track.calculate_end_time(1000, 95).should eq(1135)
    @track.calculate_end_time(100, 90).should eq(230)
    @track.calculate_end_time(215, 95).should eq(350)
  end

  it 'converts minutes into hours' do
    @track.convert_to_hrs(30).should eq(30)
    @track.convert_to_hrs(60).should eq(100)
    @track.convert_to_hrs(95).should eq(135)
  end

  it 'calculates running total of length of each session (morning and afternoon)' do
    @track.morning_time.should eq(0)
    @track.afternoon_time.should eq(0)
    talk = Talk.new("Test Talk", 90)
    @track.add_to_total_time(talk, :morning)
    @track.morning_time.should eq(90)
    @track.add_to_total_time(talk, :afternoon)
    @track.afternoon_time.should eq(90)
  end

  it 'adds a talk to the track' do
    talk = Talk.new("Test Talk", 90)
    @track.add_talk(talk, :morning)
    @track.morning_time.should eq(90)
    @track.am_end_time.should eq(1030)
    @track.add_talk(talk, :afternoon)
    @track.afternoon_time.should eq(90)
    @track.pm_end_time.should eq(230)
    @track.pm_24hr_start.should eq(1430)
  end

  it 'sorts associated talks' do
    talk = Talk.new("Test Talk", 90)
    @track.add_talk(talk, :morning)
    @track.sort_talks
    @track.talks[0].name.should eq("Test Talk")
    @track.talks[1].name.should eq("Lunch")
    @track.talks[2].name.should eq("Networking Event")
    @track.add_talk(talk, :afternoon)
    @track.talks.last.name.should eq("Test Talk")
    @track.sort_talks
    @track.talks[2].name.should eq("Test Talk")
    @track.talks.last.name.should eq("Networking Event")
  end
  
end
