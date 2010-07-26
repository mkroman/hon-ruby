# encoding: utf-8

module HoN
  class PlayerStats < Stats

    attr_statistics :wins,            :acc_wins           # The total amount of victories.
    attr_statistics :kicks,           :acc_kicked         # The amount of times the player has been kicked from a game.
    attr_statistics :losses,          :acc_losses         # The total amount of defeats.
    attr_statistics :deaths,          :acc_deaths         # The total amount of deaths in a match.
    attr_statistics :psr,             :acc_pub_skill      # The players Public Skill Rating.
    attr_statistics :nickname,        :nickname           # The player's nickname.
    attr_statistics :kills,           :acc_herokills      # The total amount of heroes the player has killed.
    attr_statistics :concedes,        :acc_concedes       # The total amount of games conceded.
    attr_statistics :buybacks,        :acc_buybacks       # The (total? average?) amount of hero buybacks.
    attr_statistics :total_exp,       :acc_heroexp        # The total amount of experience the player has gained.
    attr_statistics :disconnects,     :acc_discos         # The amount of times the player has disconnected from a game.
    attr_statistics :games,           :acc_games_played   # The total amount of games played.
    attr_statistics :idle_time,       :acc_secs_dead      # Total amount of time dead
    attr_statistics :assists,         :acc_heroassists    # The total amount of assist kills.
    attr_statistics :total_damage,    :acc_herodmg        # The total amount of damage the player has dealt to heroes.
    attr_statistics :public_games,    :acc_pub_count      # The amount of public games the player has played (non-matchmaking games).
    attr_statistics :concede_votes,   :acc_concedevotes   # The amount of times the player has tried to concede.
    attr_statistics :total_hero_gold, :acc_herokillsgold  # The total amount of gold consumed from killing enemy heroes.
    attr_statistics :total_gold_lost, :acc_goldlost2death # Total amount of gold consumed by enemies or creeps on death.

    def initialize nickname, *options
      @nickname   = nickname
      @statistics = Hash.new
      
      statistics!
      raise PlayerError, "Player not found" if @statistics.empty?
    end

    def inspect
      %{<#{self.class.name} @nickname="#{nickname}" @games=#{games} @wins=#{wins} @losses=#{losses}>}
    end

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

