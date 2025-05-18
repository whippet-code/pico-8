pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- splatty boid
-- m.ivkovic

function _init()
	game_over=false
	make_world()
	make_player()
end

function _update()
	if (not game_over) then
		update_world()
		update_player()
		check_hit()
	else
		if (btnp(❎)) _init()
	end
end

function _draw()
	cls()
	draw_world()
	draw_player()
	
	if (game_over) then
		print("game over!",44,44,7)
		print("your score:"..p.score,34,54,7)
		print("press ❎ to play again!",18,72,6)
	else
		print("score:"..p.score,2,2,7)
	end
end
-->8
--player

function make_player()
	p={}
	
	--sprite
	p.up=1
	p.down=2
	p.dead=3

	--status
	p.x=24
	p.y=60
	p.dy=0
	p.speed=2
	p.score=0
end

function update_player()
	
	gravity = 0.25
	p.dy += gravity
	
	if (btnp(⬆️)) then
		p.dy = -4
		sfx(0)
	end
	
	p.y += p.dy
	
	p.score += p.speed
end

function draw_player()
	if (game_over) then
		spr(p.dead,p.x,p.y)
	elseif(p.dy<0) then
		spr(p.down,p.x,p.y)
	else
		spr(p.down,p.x,p.y,1,1,false,true)
	end
end

function check_hit()
	for i=p.x,p.y+7 do
		if (world[i+1].top>p.y
			or world[i+1].btm<p.y) then
			sfx(1)
			game_over=true
		end
	end
end

-->8
--world

function make_world()
	world={
		{
			["top"]=64,
			["btm"]=120
		}
	}
	top=45 --min roof
	btm=85 --max floor
end

function update_world()
	--remove far left
	if(#world>p.speed) then
		for i=1,p.speed do
			del(world,world[1])
		end
	end

	--create new right hand side
	while(#world<128) do
		local col={}
		local up=flr(rnd(7)-3)
		local dwn=flr(rnd(7)-3)
		col.top=mid(3,world[#world].top+up,top)
		col.btm=mid(btm,world[#world].btm+dwn,124)
	
		--add rhs to world{}
		add(world,col)
		add(world,col)
		add(world,col)
		add(world,col)	
	end
end

function draw_world()
	top_col=3
	btm_col=3
	wolrd_col=7
	
	for i=1,#world do
		line(i-1,0,i-1,127,world_col)
		line(i-1,0,i-1,world[i].top,top_col)
		line(i-1,world[i].btm,i-1,127,btm_col) 
	end

end
__gfx__
000000000000000000000000cc000c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccc000000000000008700c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000cccc7000cccc7a007788a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccacccccca00887c8c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000aacc0000accc0a0788cac0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000cc00000c8c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000cc00c0800008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000c00c000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000300000332004310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0006000005130107200b7100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
