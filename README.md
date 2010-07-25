What is this library?
=====================
This library simplifies calls to the Heroes of Newerth API with Ruby.
At this point it only supports player, match and hero statistics.

Example
-------
    >> require 'hon'
    => true
    >> player = HoN.player "mk"
    => <HoN::PlayerStats @nickname="mk" @games=224 @wins=111 @losses=113>
    >> player.psr
    => "1637"
    >> player.kdr
    => 0.9
    
Documentation
=============
Due to lack of documentation, I would recommend that you read through the
source, I will add more documentation with time.
