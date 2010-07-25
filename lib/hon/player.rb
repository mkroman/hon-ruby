# encoding: utf-8

module HoN
  class PlayerStats < Stats

    def initialize nickname, *options
      @nickname   = nickname
      @statistics = Hash.new
      
      statistics!
      raise PlayerError, "Player not found" if @statistics.empty?
    end

    def inspect
      %{<#{self.class} @nickname="#{nickname}" @games=#{games} @wins=#{wins} @losses=#{losses}>}
    end
    
    def psr;             @statistics[:acc_pub_skill]      end # The players Public Skill Rating.
    def wins;            @statistics[:acc_wins]           end # The total amount of victories.
    def games;           @statistics[:acc_games_played]   end # The total amount of games played.
    def kills;           @statistics[:acc_herokills]      end # The total amount of heroes the player has killed.
    def deaths;          @statistics[:acc_deaths]         end # The total amount of deaths in a match.
    def kicked;          @statistics[:acc_kicked]         end # The amount of times the player has been kicked from a game.
    def losses;          @statistics[:acc_losses]         end # The total amount of defeats.
    def assists;         @statistics[:acc_heroassists]    end
    def concedes;        @statistics[:acc_concedes]       end # The total amount of games conceded.
    def buybacks;        @statistics[:acc_buybacks]       end # The (total? average?) amount of hero buybacks.
    def nickname;        @statistics[:nickname]           end # The player's nickname 
    def total_exp;       @statistics[:acc_heroexp]        end # The total amount of experience the player has gained.
    def idle_time;       @statistics[:acc_secs_dead]      end # Total amount of time death
    def disconnects;     @statistics[:acc_discos]         end # The amount of times the player has disconnected from a game.
    def total_damage;    @statistics[:acc_herodmg]        end # The total amount of damage the player has dealt to heroes.
    def public_games;    @statistics[:acc_pub_count]      end # The amount of public games the player has played (non-matchmaking games).
    def concede_votes;   @statistics[:acc_concedevotes]   end # The amount of times the player has tried to concede.
    def total_hero_gold; @statistics[:acc_herokillsgold]  end # The total amount of gold consumed from killing enemy heroes.
    def total_gold_lost; @statistics[:acc_goldlost2death] end # Total amount of gold consumed by enemies or creeps on death.

    def win_percentage
      (wins.to_f / games.to_f * 100).round 1
    end

    def kdr
      (kills.to_f / deaths.to_f).round 1
    end

  private
    def statistics!
      open "http://xml.heroesofnewerth.com/xml_requester.php?f=player_stats&opt=nick&nick[]=#{@nickname}" do |response|
        data = REXML::Document.new response.read
        data.elements.each '/xmlRequest/stats/player_stats/stat' do |element|
          @statistics[element.attributes["name"].to_sym] = element.text
        end
      end
    end

  end
end

