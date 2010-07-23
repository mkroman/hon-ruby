# encoding: utf-8

module HoN
  class HeroStats < Stats
    
    def initialize nickname
      @nickname   = nickname
      @statistics = Hash.new

      retrieve_statistics
    end

    private
    def retrieve_statistics
      open "http://xml.heroesofnewerth.com/xml_requester.php?f=player_hero_stats&opt=nick&nick[]=#{@nickname}" do |response|
        data = REXML::Document.new response.read
        data.elements.each '/xmlRequest/stats/player_hero_stats/hero' do |hero|
          buffer = Hash.new
          hero.elements.each do |element|
            buffer[element.attributes["name"].to_sym] = element.text
          end
          @statistics[hero.attributes["cli_name"]] = buffer
        end
      end
    end

  end
end
