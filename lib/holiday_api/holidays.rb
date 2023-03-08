require 'httparty'
require 'pry'
require './lib/holiday_api/holiday'
require './lib/holiday_api/holiday_search'
require './lib/holiday_api/holiday_service'

holiday_array = HolidaySearch.new.holidays
holiday_array.each do |holiday|
  puts holiday.name
  puts holiday.date
end
