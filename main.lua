require 'game'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--Generate sound sources from wav files
--In the future, it's best to have file names without spaces as some programs
--can cause errors
-- "static" is for short sound effects, use "stream" when using long audio tracks
EAT_SOUND = love.audio.newSource("Snake eat apple.wav", "static")
OVER_SOUND = love.audio.newSource("Game Over.wav", "static")

--generate a new love font from the ttf file
love.graphics.setFont(love.graphics.newFont("font.ttf", 20))

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false;
      vsync = true
  })
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle('Snake Game')
  interval = 20
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
  add_apple()
end


function love.draw()
  --draw the UI if it's in the starting state
  if state == GameState.start then
    --display a bunch of text
    --there are fancier ways of doing this such as using the built in Text functions
    --but this will do if perfection isn't required
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    love.graphics.setFont(largeFont)
    love.graphics.print('Snake Game ', 440, 200, 0, 4, 4)
    love.graphics.setFont(smallFont)
    love.graphics.print('Press Enter to start', 510, 320, 0, 3, 3)
    love.graphics.print('Press P to pause', 535, 380, 0, 3, 3)
    love.graphics.print('Press Escape to quit', 510, 440, 0, 3, 3)
    love.graphics.setFont(smallFont)
    love.graphics.print('coded by: Samah Balahmmer', 50, 650, 0, 3, 3)
  end

  --only draw the game if it's running
  if state == GameState.running or state == GameState.pause then
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    game_draw()
  end

  if state == GameState.game_over then
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(255,255,255,1)
    love.graphics.print('Game Over!', 380, 200, 0, 3, 3)
    love.graphics.setFont(smallFont)
    love.graphics.print('Press Space to Restart', 500, 340, 0, 3, 3)
  end

end

function love.update()
  if state == GameState.running then
    interval = interval- 1
    if interval < 0 then
      game_update()
      if tail_length <= 5 then
        interval = 20
      elseif tail_length > 5 and tail_length <= 10 then
        interval = 17
      elseif tail_length > 10 and tail_length <= 15 then
        interval = 14
      elseif tail_length > 15 and tail_length <= 25 then
        interval = 11
      elseif tail_length > 25 and tail_length <= 35 then
        interval = 8
      else
        interval = 5
      end
    end
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'left'  then
    left = true; right = false;  up = false; down = false
  elseif key == 'right'  then
    left = false; right = true;  up = false; down = false
  elseif key == 'up'  then
    left = false; right = false;  up = true; down = false
  elseif key == 'down'  then
    left = false; right = false;  up = false; down = true
  elseif key == 'space' and state == GameState.game_over then
    game_restart()
  elseif key == 'p' then
    if state == GameState.running then
      state = GameState.pause
    --only run the game if it's in the pause state
    elseif state == GameState.pause then
      state = GameState.running
    end
  --start game on enter key press
  elseif key == 'return' then
     state = GameState.running
  end

end
