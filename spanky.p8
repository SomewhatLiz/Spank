pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--main

function _init()
	
	ban = initbanana()
	ban.speedy = 1
	ban.x += 63
	add(bananas, ban)
end

function _draw()
	cls()
	checkloss()
	background()
	setting()
	if state ==  "start" then
		str = "spanky kong's wild ride"
		print(str, 64 - (#str * 2), 54, 7)
		str = "featuring seth rogan"
		print(str, 64 - (#str * 2), 62, 13)
		str = "as the bad guys"	
		print(str, 64 - (#str * 2), 70, 13)	
		str = "press ❎ to play"
		print(str, 64 - (#str * 2), 84, 13)
		if btn(❎) then
			state = "game"
		end	
	end
	if state == "lose" then
		str = "youre done"
		print(str, 64 - (#str * 2), 54, 7)
		str = "your final score is"
		print(str, 64 - (#str * 2), 62, 13)
		str = tostr(score)	
		print(str, 64 - (#str * 2), 70, 13)	
		str = "press ❎ to play"
		print(str, 64 - (#str * 2), 84, 13)
		globalspeed = 1
		player.x = 63
		player.y = 63
		if btnp(❎) then
			state = "game"
			score = 0
			bananas = {}
			ban = initbanana()
			ban.speedy = 1
			ban.x += 63
			add(bananas, ban)
		end
	end
	if state == "game"  or state == "tutorial" then
		drawchar()
		moving()
		for i in all(bananas) do
			spr(2, i.x, i.y, 1, 1)
		end
		print("score:", 1, 1, 8)
		print(score, 25, 1, 8)
	end
	if state == "tutorial" then
		str =  "hold ❎ to show direction"
		print(str, 64 - (#str * 2), 54, 7) 
		str =  "release ❎ to shoot"
		print(str, 64 - (#str * 2), 54, 7)
	end
end


function _update()
	physics()
	if state == "game" then
		for i in all(bananas) do
			i.x += i.speedx * globalspeed
			i.y += i.speedy * globalspeed
		end
	end
	collision()
end 
-->8
--variables
originx = 63
originy = 63
tick = 0
tickt = 1
tickreset = 40

globalspeed = 1 

colors = {12}

score = 0

state = "start"

player = {
	x = 63,
	y = 63,
	dirx = 0,
	diry = 0,
	speed =  2,
	maxspeed = 5,
	fricti0n = 1,
	gravity = 3,
	jump =  15,
	distance = 50,
	shot = false,
	direction = 1
}

spin = {
	x = 10,
	y = 0,
	rotation = 0,
	prevpressed = false
}

bananas={}

function initbanana()
 return {
 	x = 0,
 	y = 0,
 	speedx = 0,
 	speedy = 0
 }
end
-->8
--functions

function physics()
	player.x += player.dirx * globalspeed * player.speed
	player.y += player.diry * globalspeed * player.speed
 player.dirx *= player.fricti0n
end

function drawchar()
	spr(1, player.x, player.y, 1, 1)
end

function spinline()
	spin.rotation += 1
	r = spin.rotation
	x1 = spin.x
	y1 = spin.y
	x =(x1 * cos(deg2rad(r))) - (y1 * sin(deg2rad(r)))
	y =(y1 * cos(deg2rad(r))) + (x1 * sin(deg2rad(r)))
	line(player.x +  4, player.y + 4, x + player.x + 4,  y + player.y + 4, 12)
end

function shoot()
	r = spin.rotation
	x1 = spin.x
	y1 = spin.y
	x =(x1 * cos(deg2rad(r))) - (y1 * sin(deg2rad(r)))
	y =(y1 * cos(deg2rad(r))) + (x1 * sin(deg2rad(r)))
	player.dirx = (x/7) * player.direction
	player.diry = (y/7)
end

function bounce()
	if player.x + player.dirx < 7 or player.x + player.dirx > 112 then
		player.direction *= -1
	end
end

function moving()
	if btn(❎) then
		spinline()
		globalspeed = 0.1
		spin.prevpressed = false
	end
	if not btn(❎) and spin.prevpressed == false then
		player.shot = false
		spin.prevpressed = true
	end
	if player.shot == false then
		globalspeed = 1
		shoot()
		player.shot = true
	end
end

function collision()
	for i in all(bananas) do
		if distance(i.x, i.y, player.x, player.y) < 8  then
			score += 1
			del(bananas,i)
			ban = initbanana()
			ban.x = rnd(103) + 7
			ban.speedy = (score/30)  + 1
			globalspeed +=  score/30
			add(bananas, ban)
		end
	end
end

function checkloss()
	for i in all(bananas) do
		 if i.x < 0 or i.x > 128 then
		 	state =  "lose"
		 end
		 if i.y < 0 or  i.y > 128 then
		 	state = "lose"
		 end
	end
	if player.x < 0 or player.x > 128 then
		 	state =  "lose"
		 end
		 if player.y < 0 or  player.y > 128 then
		 	state = "lose"
		 end
end

function lose()
	globalspeed = 0
end
-->8
--shaders

function  sinwave(x, a)
	return a * sin(deg2rad(x))
end

function background()
	pos = 0
	tick += tickt
	if tick > 40 or tick < 0 then
		tickt  *= -1
	end
	for r=1, 5 do
		pos +=  1
		r *= 12
		if pos > count(colors) then
			pos = 1
		end
		for i=-100, 100 do
			x1 = i + tick
			y1 = sinwave(i, 4, 2)
			x =(x1 * cos(deg2rad(r))) - (y1 * sin(deg2rad(r)))
			y =(y1 * cos(deg2rad(r))) + (x1 * sin(deg2rad(r)))
			y += originy
			x += originx
			pset(x, y, colors[pos])
		end
	end
end

function squares()
	for x=8, 112 do
		for y=8, 112 do
			if (x%8) == 0 and (y%8) == 0 then
				spr(1, x, y)
			end
		end
	end
end

function setting()
	if (player.x + 4 < 7 or player.x + 4 > 119) or (player.y + 4 < 7 or player.y + 4 > 119) then
		flash()
	end
	rect(7,7,120,120,7)
	rectfill(8,8,119,119,0)
	end
	function flash()
	for x=0,  127 do
		for y=0, 127 do
			if pget(x,y) == 12  then
				pset(x,y, 0)
			else
				if pget(x,y) == 0  then
					pset(x, y, 12)
				end
			end
		end
	end
end

-->8
--util

function deg2rad(deg)
	return deg * (3.14/180)
end

function distance(x1, y1, x2, y2)
	absx = (x1 - x2) * (x1 - x2)
	absy = (y1 - y2) * (y1 - y2)
	return(sqrt(absx + absy))
end

function print_centered(str)
  print(str, 64 - (#str * 2), 60, 7) 
end
__gfx__
000000000dddddd00000000077777777000000077000000077777777000000000000000000000000000000000000000000000000000000000000000000000000
00000000d000000d0000001100000007000000077000000070000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070040044004000000a100000007000000077000000070000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000ffffff000000aaa00000007000000077000000070000000000000000000000000000000000000000000000000000000000000000000000000000000
000770004f8888f40110aaa000000007000000077000000070000000000000000000000000000000000000000000000000000000000000000000000000000000
007007004ffffff401aaaa0000000007000000077000000070000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004044440400aaa00000000007000000077000000070000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004004000000000000000007777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000
