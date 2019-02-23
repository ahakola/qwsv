# My QWSV setup

This is pulled from my over decade old back ups of my server where I used to run QWTF server. This might not even be the latest version of the back ups, but the first one I found. Now it is configured to run **Thundervote**, but I can't remember if I ever got this configuration into working condition so it might be worth to convert this into fixed map rotation.

## MVDSV

I ran the server with **MVSDV** (https://github.com/deurk/mvdsv), but you can use any server software you find for your hardware and OS. **MVSDV** is available at least for 32bit and 64bit Windows, Linux and 32bit ARM. If you want to try to run this on Raspberry Pi for example, I'm pretty sure the ARM version should compile on Rasbian (https://github.com/deurk/mvdsv#compiling-on-ubuntu).

If you are on x86 based Linux system and are feeling lucky, you can try to yolo with `chmod +x mvdsv` and/or `chmod +x qwsv` and try to run those.


## sv-up.sh

I ran this script with crontab (`sudo crontab -e`) on boot (`@reboot /where/ever/you/place/this/sv-up.sh`) to automatically start the qw-server and it should also restart the qw-server if it crashes or exits for any other reason.

Make sure the script is executable (`chmod +x sv-up.sh`) and edit the `quakedir` variable and external IP with *-ip* flag of the launch command to match your own setup or use the launch command without the *-ip* flag if you have only public IP visible to the machine (I used it because NAT hid the public IP from the server and caused issues when trying to connect to the server).


## id1/pak0.pak and id1/pak1.pak

I didn't include those files in this repository because I'm not 100% sure of the legality of sharing them, but you can copy the **id1/** folder of your own Quake install or search the internet for those files.


## fortress/server.cfg

This is based on old TomteFortress-tournament configuration template. Remember to edit this file to check all the settings for proper values before starting the server.


### Deathmatch

Set this to *3* always or players can't change class.

`deathmatch 3 `


### Team play

Team play settings are set with `teamplay X?QWTF2.9` line where *X* is a number created by a bitmask field. Bits are:

Bit | Function
---: | ---
1 | Team play normal. This has to be always on?
2 | Team-members only take 1/2 damage from direct fire.
4 | Team-members take no damage from direct fire.
8 | Team-members only take 1/2 damage from area-affect weaponry.
16 | Team-members take no damage from area-affect weaponry.
32 | TEAMPLAY_LESSPLAYERSHELP
64 | TEAMPLAY_LESSSCOREHELP
128 | Team-members only lose 1/2 armor from direct fire.
256 | Team-members lose no armor from direct fire.
512 | Team-members only lose 1/2 armor from area-affect weaponry.
1024 | Team-members lose no armor from area-affect weaponry.
2048 | Team-members take 1/2 mirror damage from direct fire.
4096 | Team-members take full mirror damage from direct fire.
8192 | Team-members take 1/2 mirror damage from area-affect weaponry.
16384 | Team-members take full mirror damage from area-affect weaponry.

Bitmask fields are constructed by combining the bits of wanted settings. For example two very common setting are "team-members take only half of the damage" *11* (*1 + 2 + 8*) and "no friendly fire" *21* (*1 + 4 + 16*).

I have no idea what bits *32* and *64* do, but I would guess they have something to do players only being able to swap teams to the "underdog" team to even the game and prevent snowballing.

Also I'm not 100% sure if the bit *1* has to be always on since in some *rare* (it is almost always *1*, *11* or *21*) cases I have seen `teamplay 1300` which prevents any damage and armor loss between team-members so I assume dropping the *1* could prevents self-harm?


### Time limit, pre-match and clanmode

Time limit is the maximum time the server will stay in map before ending the game and continuing to next map.

If you enable *clanmode*, you can also turn on pre-match. During pre-match clans can get their players on the server and set up their teams and classes etc. to be ready for the game. When pre-match time ends, all players are killed to send them back to respawn and the actual match begins. The time limit **includes** pre-match time.

If you set your pre-match time to 5 minutes (`localinfo pm 5`) and want the match to last 30 minutes, you have to set the timelimit to 35 minutes (`timelimit 35`).

To turn pre-match off, use `localinfo pm 0` or turn clanmode off (`localinfo c off`). Pre-match setting will be ignored if *clanmode* is *off*.

`timelimit 30`

`localinfo c on` or `localinfo c on`  
`localinfo clan on` or `localinfo clan off`

`localinfo pm 5` or `localinfo pm 0`  
`localinfo prematch 5` or `localinfo prematch 0`


### Flood protection

Flood protection controls the rate clients can send messages. If client sends more then *X* messages in time *Y*, they will be silenced for *Z* seconds:

`floodprot X Y Z`

Optionally you can set custom message for client when they trigger the flood protection:

`floodprotmsg "You have been silenced for flooding!"`


### FPD

FPD is used to control over what proxies (like Qizmo) can do and cannot do on server.

Sources for following informations are "Qizmo Info" (https://web.archive.org/web/20090928083556/http://www.udpsoft.com/qizmo/info.html) and QWiki Page about "FPD" (https://wiki.quakeworld.nu/wiki/FPD).

#### Disabling Qizmo features

There are some features in Qizmo that some people consider cheating,
so we made a way to disable these features from the server. There is
a server variable, which can be used to do that. The variable is called
fpd and is set by typing at the console:

`serverinfo fpd X`

or if you have *rcon* for a server and do not have access directly to
the console:

`rcon rcon_password serverinfo fpd X`

Where *X* is a number created by a bitmask field. Bits are:

Bit | Function
---: | ---
1 | Disable %-reporting
2 | Disable use of powerup timer
4 | Disable use of soundtrigger
8 | Disable use of lag features
16 | Make Qizmo report any changes in lag settins
32 | Silent %e enemy vicinity reporting (reporter doesn't see the message) (always on in v2.55)
64 | Spectators can't talk to players and vice versa (voice)
128 | Silent %x and %y (reporter doesn't see the message)
256 | Disable skin forcing
512 | Disable color forcing

For example, if you want to disable powerup timer, you would type at
server console: `serverinfo fpd 2`. Or if you want to disable powerup timer
and lag features, you would use: `serverinfo fpd 10`, because bits for timer
and for lag features combined (*2+8*) is 10..

On Team Fortress servers, *%e* and *%x* use bottomcolor to determine
team and *%x* won't report own players at all. Also skin forcing is
disabled. So detecting spies is impossible.


#### More FPD bits

Bit | Function
---: | ---
1024 | ???
2048 | ???
4096 | ???
8192 | ???
16384 | Limit pitch speed
32768 | Limit yaw speed

I have no idea what bits *1024 - 8192* do and I'm not 100% sure, but bits *16384* and *32768* might be ment to cripple some rocket jump scripts?


### Score counting

By default player's get 1 point for every kill they make and 10 points for every cap made by a team. Team's score is calculated combining team's frag counts and adding 10 points for every cap.

In clan matches sometimes you play so called *Caps Only* or *Team Frags* -format. This makes each player's frag count equal to the number of points his/her team has. In *Team Frags*-mode, frags for killing enemies are not counted towards the team's total score, and only the points from caps matter.

`localinfo t on` or `localinfo t off`  
`localinfo teamfrags on` or `localinfo teamfrags off`

There is also 3rd mode called *Full Team Scores* where points are calculated like in default way, but each player's frag count is equal to the number of points his/her team has.

`localinfo fts on` or `localinfo fts off`  
`localinfo fullteamscore on` or `localinfo fullteamscore off`


### Class restrictions

You can set class restrictions to disallowed, allowed or limited with `localinfo cr_* X` where *X* is:

Value | Setting
:---: | ---
0 | Allow, no limits.
-1 | Disallow, no-one can pick.
1+ | Restricted, limited to *n* players per team at any given time.

```
localinfo cr_sc 0
localinfo cr_sn 3
localinfo cr_so 0
localinfo cr_de 0
localinfo cr_me 0
localinfo cr_hw 0
localinfo cr_py 0
localinfo cr_sp 0
localinfo cr_en 0
localinfo cr_ra -1
```
or
```
localinfo cr_scout 0
localinfo cr_sniper 3
localinfo cr_soldier 0
localinfo cr_demoman 0
localinfo cr_medic 0
localinfo cr_hwguy 0
localinfo cr_pyro 0
localinfo cr_spy 0
localinfo cr_engineer 0
localinfo cr_randompc -1
```


### Fixed map rotation

Freely edited from http://quakeone.com/forum/quake-help/servers-and-coding/7882-quakeworld-server-with-multiple-maps?p=149703#post149703 and https://www.quakeworld.nu/forum/topic/4674/56555/mvdsv-map-rotation-help/#56555

In this example we create fixed rotation of *bases*, *2fort5r* and *well6*. I'm sure if you can get the server up and running, you are smart enough to figure out how to alter the rotation for your needs.

1. Inside `\fortress\qwmcycle` directory create .cfg files called `mapX.cfg`, where *X* is number between 1 and the amount of maps in your rotation + 1 (the extra .cfg file is used to loop back to the start of the rotation).  
   `map1.cfg` which contains the following line:  
      `map bases`  
   `map2.cfg` which contains the following line:  
      `map 2fort5r`  
   `map3.cfg` which contains the following line:  
      `map well6`  
   `map4.cfg` which contains the following line:  
      `serverinfo n 0`

2. Edit the `server.cfg` to use `map` command to load to the first map in your rotation. Also add line `serverinfo n 1` to prevent the first map playing twice when you boot your server up:  
   `map bases`  
   `serverinfo n 1`

3. ???

4. Profit! You are done.

There is no limit to the number of maps you can cycle between. You can also use these .cfg file to change any server settings per map.  
In our example, let's allow maximum of 24 players on *bases* and *well6*, but only 16 on *2fort5r* by altering the .cfg files:  
```
map1.cfg
   maxclients 24
   map bases

map2.cfg
   maxclients 16
   map 2fort5r

map3.cfg
   maxclients 24
   map well6
```

If you want to make a server rerun the same level over and over again, you will still have to make a `map1.cfg` that contains a `map` command, and a `map2.cfg` that sets `serverinfo n 0`.

**N.B.** Make sure all the maps in the list are spelt correctly and that they are in your server's map directory. If they're not, the server will crash when it tries to enter the map.

**N.B.** The *n* serverinfo key stores the current map number in the list. If you want to jump around the levels, you can just set the key to (*desired level number - 1*).  
E.g. if you wanted to jump to map 3 in the list, enter this: `serverinfo n 2` and then end the level.


### Other note worthy settings

* **AutoTeam** will automatically assign players to the team with the least number of people in it, when the player chooses his/her class.

   `localinfo autoteam on` or `localinfo autoteam off`

* **Map checksums** checks the map file on the server with the one client uses on client connect. If the clients map has hacked textures, removed walls or waterhack then client is disconnected.

   `sv_mapcheck 1`

* **Announce server** to the master server lists so all the "relevant" softwares like *GameSpy* and *The All-Seeing Eye* for example can find your server and you get more players. You can add as many master servers as you want separated by space. QuakeServers.net for example has listed some master servers on their site (https://www.quakeservers.net/quakeworld/master_servers/).

   `setmaster master.server1.com:27000 server2.net:27000 123.123.123.123:27000`  
   `setmaster master.quakeservers.net:27000`

