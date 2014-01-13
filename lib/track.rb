require_relative "talk"

class Track
  attr_accessor :track_name, :morning_time, :afternoon_time, :am_end_time, :pm_end_time, :pm_24hr_start, :talks

  MORNING_MAX = 180
  AFTERNOON_MAX = 240
  MORNING_KEY = :morning
  AFTERNOON_KEY = :afternoon

  def initialize(track_name)
    @track_name = track_name
    @morning_time, @afternoon_time = 0, 0
    @am_end_time, @pm_end_time = 900, 100
    @pm_24hr_start = 1300
    @talks = []
    @talks.push(Talk.new("Lunch", nil, 1200, 1200))
    @talks.push(Talk.new("Networking Event", nil, 500, 1700))
  end

  def total_session_time(time_of_day)
    time_of_day == :morning ? self.morning_time : self.afternoon_time
  end

  def max_min(time_of_day)
    time_of_day == :morning ? MORNING_MAX : AFTERNOON_MAX
  end

  def available_time?(talk, time_of_day)
    self.total_session_time(time_of_day) < max_min(time_of_day) && self.total_session_time(time_of_day) + talk.minutes <= max_min(time_of_day)
  end

  def add_talk(talk, time_of_day)
    add_talk_start_time(talk, time_of_day)
    self.talks.push talk
    schedule_end_time(talk, time_of_day)
    add_to_total_time(talk, time_of_day)
  end

  def add_talk_start_time(talk, time_of_day)
    if time_of_day == MORNING_KEY
      talk.start_time = self.am_end_time
      talk.military_time_start = self.am_end_time
    else
      talk.start_time = self.pm_end_time
      talk.military_time_start = self.pm_24hr_start
    end
  end

  def schedule_end_time(talk, time_of_day)
    if time_of_day == MORNING_KEY
      self.am_end_time = calculate_end_time(self.am_end_time, talk.minutes)
    else
      self.pm_end_time = calculate_end_time(self.pm_end_time, talk.minutes)
      self.pm_24hr_start = calculate_end_time(self.pm_24hr_start, talk.minutes)
    end
  end

  def calculate_end_time(std_time, talk_length)
    hr = std_time / 100 * 100
    cur_min = std_time % 100
    hr + convert_to_hrs(cur_min + talk_length)
  end

  def convert_to_hrs(min)
    (min / 60 * 100) + (min % 60)
  end


  def add_to_total_time(talk, time_of_day)
    if time_of_day == MORNING_KEY
      self.morning_time += talk.minutes
    else
      self.afternoon_time += talk.minutes
    end
  end

  def sort_talks
    @talks.sort! { |a,b| a.military_time_start <=> b.military_time_start }
  end

end