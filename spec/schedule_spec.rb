require "schedule"

describe Schedule do
  before(:each) { @schedule = Schedule.new }
  it 'has correct properties when initialized' do
    @schedule.total_time.should eq(0)
    @schedule.talks.empty?.should be_true
    @schedule.tracks.empty?.should be_true
  end


  it 'has a read_file method that reads the data file into an array of 19 items' do
    @schedule.read_file.length.should eql(19)
  end

  it 'imports a talk string as a talk object' do
    @schedule.talks.count.should eq(0)
    talk_string = "Writing Fast Tests Against Enterprise Rails 60min"
    @schedule.import_talk_string(talk_string)
    @schedule.talks.count.should eq(1)
    @schedule.talks.first.name.should eq("Writing Fast Tests Against Enterprise Rails")
    @schedule.talks.first.minutes.should eq(60)
  end

  it 'has calc_minutes method' do
    @schedule.calc_minutes("60min").should eq(60)
    @schedule.calc_minutes("lightning").should eq(5)
  end

  it 'imports all talks from file' do
    @schedule.talks.count.should eq(0)
    @schedule.import_talks
    @schedule.talks.count.should eq(19)
    @schedule.talks.first.name.should eq("Writing Fast Tests Against Enterprise Rails")
    @schedule.talks.first.minutes.should eq(60)
    @schedule.talks.last.name.should eq("User Interface CSS in Rails Apps")
    @schedule.talks.last.minutes.should eq(30)
  end

  it 'sorts talks based off of each talks minutes property' do
    talk_string1 = "Rails for Python Developers lightning"
    talk_string2 = "Writing Fast Tests Against Enterprise Rails 60min"
    talk_string3 = "A World Without HackerNews 30min"
    @schedule.import_talk_string(talk_string1)
    @schedule.import_talk_string(talk_string2)
    @schedule.import_talk_string(talk_string3)
    sorted_talks = @schedule.sort_talks
    sorted_talks.first.name.should eq("Writing Fast Tests Against Enterprise Rails")
    sorted_talks.last.name.should eq("Rails for Python Developers")
  end

  it 'has a create_track method' do
    @schedule.tracks.count.should eq(0)
    @schedule.create_track("Track 1")
    @schedule.create_track("Track 2")
    @schedule.tracks.count.should eq(2)
  end

  it 'assigns talks to tracks' do
    @schedule.create_track("Track 1")
    @schedule.create_track("Track 2")
    @schedule.import_talks
    @schedule.schedule_tracks
    first_track = @schedule.tracks.first
    second_track = @schedule.tracks.last
    first_track.morning_time.should be > 0
    first_track.morning_time.should be <= Track::MORNING_MAX
    first_track.afternoon_time.should be > 0
    first_track.afternoon_time.should be <= Track::AFTERNOON_MAX
    second_track.morning_time.should be > 0
    second_track.morning_time.should be <= Track::MORNING_MAX
    second_track.afternoon_time.should be > 0
    second_track.afternoon_time.should be <= Track::AFTERNOON_MAX
  end
end