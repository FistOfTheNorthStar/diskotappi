require 'uri'
require 'cinch'
require 'nokogiri'

require './lib/oembed_title_fetcher'

class YleAreena < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(yle.fi)
  end

  def listen(m)
    uris = parse_uris(m)

    return if uris.empty?

    uri = uris.first
    title = Nokogiri::HTML(OpenUri.(uri)).title.split("|").first.strip

    m.channel.notice("YLE :: #{title}")
  end
end
