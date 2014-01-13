require_relative "schedule"


def run_schedule_demo(schedule)
  schedule.create_track("Track 1")
  schedule.create_track("Track 2")
  schedule.import_talks
  schedule.schedule_tracks
  schedule.tracks.each do | track|
    prints_track_schedule(track)
  end
end

def prints_track_schedule(track)
  puts track.track_name
  track.sort_talks
  track.talks.each do |talk|
    puts talk
  end
  puts "\n\n"
end



schedule = Schedule.new
run_schedule_demo(schedule)