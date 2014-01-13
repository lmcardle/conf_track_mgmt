require_relative "talk"
require_relative "track"

class Schedule
  attr_accessor :talks, :total_time, :tracks

  def initialize
    @total_time = 0
    @talks = []
    @tracks = []
  end

  def read_file
    file_name = "test_input"
    File.readlines(file_name).each { |line| line.strip! }
  end

  def import_talk_string(talk_string)
    talk_string = talk_string.split
    last_word = talk_string.pop

    talk_name =  talk_string.join(" ")
    talk_minutes = calc_minutes(last_word)
    new_talk = Talk.new(talk_name, talk_minutes)

    talks.push(new_talk)
  end

  def calc_minutes(minutes_string)
    if minutes_string == "lightning"
      @total_time += 5
      5
    else
      talk_time = minutes_string.slice(/\d./).to_i
      @total_time += talk_time
      talk_time
    end
  end

  def import_talks
    read_file.each do |talk|
      import_talk_string(talk)
    end
  end

  def sort_talks
    @talks.sort! { |a,b| b.minutes <=> a.minutes }
  end

  def create_track(track_name)
    @tracks.push(Track.new(track_name))
  end

  def schedule_tracks
    @talks.each do |talk|
      if talk.minutes < Track::MORNING_MAX
        talk_assigned = false
        @tracks.each do |track|
          if track.available_time?(talk, :morning)
            track.add_talk(talk, :morning)
            talk_assigned = true
            break
          end
        end
        next if talk_assigned
      end

      @tracks.each do |track|
        if track.available_time?(talk, :afternoon)
          track.add_talk(talk, :afternoon)
          break
        end
      end
    end
  end

  def run_schedule_demo
    create_track("Track 1")
    create_track("Track 2")
    import_talks
    schedule_tracks
    @tracks.each do | track|
      puts track.track_name
      track.sort_talks
      track.talks.each do |talk|
        puts talk
      end
      puts "\n\n"
    end
  end

end
