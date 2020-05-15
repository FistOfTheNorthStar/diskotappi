# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'
require 'nokogiri'

class Corona
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!c/).nil?

    location = m.message.split('!c ').last
    temp = fetch_corona_total
    return m.channel.notice("Corona error fetching data!") unless temp   
    if location == '!c'
      #temp = fetch_corona_total
      #return m.channel.notice("Corona error fetching data!") unless temp

      m.channel.notice("Corona totals. New confirmed: #{temp['Global']['NewConfirmed']}, total confirmed #{temp['Global']['TotalConfirmed']}, new deaths: #{temp['Global']['NewDeaths']}, total deaths: #{temp['Global']['TotalDeaths']}, new recovered: #{temp['Global']['NewRecovered']}, total recovered #{temp['Global']['TotalRecovered']}!")
    else
      
      location = location.strip.gsub(" ", "-").downcase.capitalize
      #corona = fetch_corona(location)
      
      #return m.channel.notice("Corona error fetching data!") unless corona

      #temp = corona.last
      countries = temp['Countries']
      countries.each do |country|
        if country['Country'] == location
          place        = country['Country']
          newconfirmed = country['NewConfirmed']
          confirmed    = country['TotalConfirmed']
          newdeaths    = country['NewDeaths']
          deaths       = country['TotalDeaths']
          recovered    = country['TotalRecovered']
          date_c       = temp['Date']

          m.channel.notice("Corona in #{place}, new confirmed: #{newconfirmed}, confirmed: #{confirmed}, new deaths: #{newdeaths}, deaths: #{deaths}, recovered: #{recovered}, date: #{date_c}")

          break
        end
      end

      #m.channel.notice("Corona in #{place}, new confirmed: #{newconfirmed}, confirmed: #{confirmed}, new deaths: #{newdeaths}, deaths: #{deaths}, recovered: #{recovered}, date: #{date_c}")
    end
  end

  def fetch_corona_total
    JSON.parse(OpenUri.("https://api.covid19api.com/summary"))
  end

  def fetch_corona(country)
    #JSON.parse(OpenUri.("https://api.covid19api.com/live/country/#{country}/status/confirmed"))
    JSON.parse(OpenUri.("https://api.covid19api.com/dayone/country/#{country}"))
  end

end
