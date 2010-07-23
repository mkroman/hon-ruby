# encoding: utf-8

module HoN
  class HeroError  <  StandardError; end
  class MatchError  < StandardError; end
  class PlayerError < StandardError; end

  def self.heroes nickname
    hero = HeroStats.new nickname
    yield hero if block_given?
    hero
  end  

  def self.player nickname, *options
    player = PlayerStats.new nickname, *options
    yield player if block_given?
    player
  end

  def self.match id
    match = MatchStats.new id
    yield match if block_given?
    match
  end
end
