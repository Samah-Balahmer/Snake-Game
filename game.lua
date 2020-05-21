GameState = {start = 'start', pause = 'pause', running = 'running', game_over = 'Game Over!'} --added a start state for UI
state = GameState.start

local snakeX = 15
local snakeY = 15
local dirX = 0
local dirY = 0

local SIZE = 30
local appleX = 0
local appleY = 0

local tail = {}

tail_length = 0

up = false
down = false
left = false
right = false


function add_apple()
    math.randomseed(os.time())
    appleX = math.random(WINDOW_WIDTH/SIZE - 1)
    appleY = math.random(WINDOW_HEIGHT/SIZE - 1)
end

function game_draw()
    -- Snake head color
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill',snakeX*SIZE, snakeY*SIZE, 30, 30, 10, 10)

    -- snake tail
    love.graphics.setColor(0.7, 0.35, 0.4, 1.0)
    for _, v in ipairs(tail) do
        love.graphics.rectangle('fill', v[1]*SIZE, v[2]*SIZE, 30, 30, 10, 10)
    end

    -- apples Color
    love.graphics.setColor(0.0, 0.0, 1.0, 1.0)
    love.graphics.rectangle('fill', appleX*SIZE, appleY*SIZE, 30, 30, 10, 10)

    --set score counter
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('Score: ' .. tail_length, 10, 10, 0, 4, 4, 0, 0, 0, 0)
end

function game_update()
    if up and dirY == 0 then
        dirX, dirY = 0, -1
    elseif down and dirY == 0 then
        dirX, dirY = 0, 1
    elseif left and dirX == 0 then
        dirX, dirY = -1, 0
    elseif right and dirX == 0 then
        dirX, dirY = 1, 0
    end

    local oldX = snakeX
    local oldY = snakeY

    snakeX = snakeX + dirX
    snakeY = snakeY + dirY

    if snakeX == appleX and snakeY == appleY then
        add_apple()
        tail_length =  tail_length + 1
        table.insert(tail, {0,0})
        EAT_SOUND:play() --tell the sound source to play (could also use love.audio.play(EAT_SOUND))
    end

    if snakeX < 0 then
        snakeX = WINDOW_WIDTH/SIZE
    elseif snakeX > WINDOW_WIDTH/SIZE then
        snakeX = 0
    elseif snakeY < 0 then
        snakeY = WINDOW_HEIGHT/SIZE
    elseif snakeY > WINDOW_HEIGHT/SIZE then
        snakeY = 0
    end

    if tail_length > 0 then
        for _, v in ipairs(tail) do
            local x, y = v[1], v[2]
            v[1], v[2] = oldX, oldY
            oldX, oldY = x, y
        end
    end

    for _, v in ipairs(tail) do
        if snakeX == v[1] and snakeY == v[2] then
            state = GameState.game_over
            OVER_SOUND:play() --play the "game over" sound, see EAT_SOUND:play() for more info
        end
    end

end

function game_restart()
    snakeX, snakeY = 15, 15
    dirX, dirX = 0, 0
    tail = {}
    up, down, left, right = false, false, false, false
    tail_length = 0
    state = GameState.running
    add_apple()
end
