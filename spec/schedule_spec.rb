require "schedule"

describe Schedule do
  before(:each) { @schedule = Schedule.new }
  describe 'on initialization' do
    it 'has a total_time property, initially set to 0' do
      @schedule.total_time.should eq(0)
    end

    it 'has a talks array, initially empty' do
      @schedule.talks.empty?.should be_true
    end
  end

  it 'reads data file into an array of 18 items' do
    expect(@schedule.read_file.length).to eql(19)
  end

  it 'imports a talk string as a talk object' do
    talk_string = "Writing Fast Tests Against Enterprise Rails 60min"
    @schedule.import_talk_string(talk_string)
    @schedule.talks.count.should eq(1)
    @schedule.talks.first.name.should eq("Writing Fast Tests Against Enterprise Rails")
    @schedule.talks.first.minutes.should eq(60)
  end

  it 'imports all talks from file' do
    @schedule.import_talks
    @schedule.talks.count.should eq(19)
    @schedule.talks.first.name.should eq("Writing Fast Tests Against Enterprise Rails")
    @schedule.talks.first.minutes.should eq(60)
    @schedule.talks.last.name.should eq("User Interface CSS in Rails Apps")
    @schedule.talks.last.minutes.should eq(30)
  end

  it 'sorts talks based off of minutes' do
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

  it 'has 2 tracks' do
    @schedule.create_track("Track 1")
    @schedule.create_track("Track 2")
    @schedule.tracks.count.should eq(2)
  end

  it 'assigns talks to tracks' do
    @schedule.create_track("Track 1")
    @schedule.create_track("Track 2")
    @schedule.import_talks
    @schedule.schedule_tracks
  end
end