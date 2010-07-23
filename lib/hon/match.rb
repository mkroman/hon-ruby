# encoding: utf-8

module HoN
  class MatchStats < Stats
    
    def initialize match_id
      @match_id   = match_id
      @statistics = { server: {}, legion: { players: [] }, hellbourne: { players: [] } }

      retrieve_statistics
    end

  def server
    @statistics[:server]
  end

  def legion
    @statistics[:legion]
  end

  def legion_players
    legion[:players]
  end

  def hellbourne
    @statistics[:hellbourne]
  end

  def hellbourne_players
    hellbourne[:players]
  end

  private
    def retrieve_statistics
      open "http://xml.heroesofnewerth.com/xml_requester.php?f=match_stats&opt=mid&mid[]=#{@match_id}" do |response|
        data = REXML::Document.new response.read

        # Server statistics
        data.elements.each '/xmlRequest/stats/match/summ/stat' do |element|
          @statistics[:server][element.attributes["name"].to_sym] = element.text
        end

        data.elements.each '/xmlRequest/stats/match/team[@side=1]/stat' do |element|
          @statistics[:legion][element.attributes["name"].to_sym] = element.text
        end

        data.elements.each '/xmlRequest/stats/match/team[@side=2]/stat' do |element|
          @statistics[:hellbourne][element.attributes["name"].to_sym] = element.text
        end

        data.elements.each '/xmlRequest/stats/match/match_stats/ms' do |element|
          buffer, team = Hash.new, 0
          element.elements.each do |stat|
            team = stat.text.to_i if stat.attributes["name"] == "team"
            buffer[stat.attributes["name"]] = stat.text
          end

          @statistics[(team == 1) ? :legion : :hellbourne][:players].push buffer
        end

      end
    end

  end
end
