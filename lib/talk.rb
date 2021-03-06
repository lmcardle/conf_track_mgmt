class Talk
  attr_accessor :minutes, :name, :start_time, :military_time_start

  def initialize(name, minutes, start_time=nil, military_time_start=nil)
    @name = name
    @minutes = minutes
    @start_time = start_time
    @military_time_start = military_time_start
  end

  def talk_length
    self.minutes / 60 * 100 + self.minutes % 60
  end

  def formatted_start_time
    if @start_time
      hr = start_time / 100
      hr = hr.to_s.length == 2 ? hr : "0" + hr.to_s
      min = start_time % 100
      min = min.to_s.length == 1 ? "00" : min.to_s
      if @military_time_start && @military_time_start < 1200
        time_period = "AM"
      else
        time_period = "PM"
      end

      "#{hr}:#{min}#{time_period}"
    else
      "No Start Time has been assigned"
    end
  end

  def formatted_minutes
    if !minutes
      ""
    elsif minutes == 5
      "lightning"
    else
      "#{minutes}min"
    end
  end

  def to_s
    "#{formatted_start_time} #{name} #{formatted_minutes}"
  end
end