# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'

class Weather
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!w/).nil?

    location = m.message.split('!w ').last

    if location == '!w'
      m.channel.notice("Berlin > Helsinki (toimii toimii)") and return if rand(100) == 99

      helsinki = JSON.parse(OpenUri.("http://api.openweathermap.org/data/2.5/find?q=helsinki&units=metric"))
      berlin   = JSON.parse(OpenUri.("http://api.openweathermap.org/data/2.5/find?q=berlin&units=metric"))

      temp_hki = helsinki['list'].first['main']['temp'].to_f
      temp_bln = berlin['list'].first['main']['temp'].to_f

      if temp_hki > temp_bln
        m.channel.notice("Helsinki #{temp_hki}°C > Berlin #{temp_bln}°C")
      else
        m.channel.notice("Berlin #{temp_bln}°C > Helsinki #{temp_hki}°C")
      end
    else
      data     = JSON.parse(OpenUri.("http://api.openweathermap.org/data/2.5/find?q=#{location}&units=metric"))

      return if data['list'].empty?

      weather     = data['list'].first
      place       = weather['name']
      temp        = weather['main']['temp']
      description = weather['weather'].first['description']

      country     = weather['sys']['country']

      m.channel.notice("#{place}, #{country}: #{temp}°C, #{description}")
    end
  end
end
