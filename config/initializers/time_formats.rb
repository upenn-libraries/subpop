Time::DATE_FORMATS[:weekday_with_tz_name] = "%A @ %H:%M %Z"
Time::DATE_FORMATS[:date_with_tz_name] = "%B %d, %Y %H:%M %Z"
Time::DATE_FORMATS[:smart_and_fancy] = lambda { |time|
  return time.strftime "Today @ %H:%M %Z" if time.today?
  return time.strftime "%A @ %H:%M %Z" if time > 7.days.ago
  time.strftime "%B %d, %Y %H:%M %Z"
}