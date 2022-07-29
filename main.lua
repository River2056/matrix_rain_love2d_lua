-- [[
--    self attempt on the matrix rain effect
-- ]]
local font, fontSize, dtTotal, streams
local charpool = {
    "ァ",
    "ア",
    "ィ",
    "イ",
    "ゥ",
    "ウ",
    "ェ",
    "エ",
    "ォ",
    "オ",
    "カ",
    "ガ",
    "キ",
    "ギ",
    "ク",
    "グ",
    "ケ",
    "ゲ",
    "コ",
    "ゴ",
    "サ",
    "ザ",
    "シ",
    "ジ",
    "ス",
    "ズ",
    "セ",
    "ゼ",
    "ソ",
    "ゾ",
    "タ",
    "ダ",
    "チ",
    "ヂ",
    "ッ",
    "ツ",
    "ヅ",
    "テ",
    "デ",
    "ト",
    "ド",
    "ナ",
    "ニ",
    "ヌ",
    "ネ",
    "ノ",
    "ハ",
    "バ",
    "パ",
    "ヒ",
    "ビ",
    "ピ",
    "フ",
    "ブ",
    "プ",
    "ヘ",
    "ベ",
    "ペ",
    "ホ",
    "ボ",
    "ポ",
    "マ",
    "ミ",
    "ム",
    "メ",
    "モ",
    "ャ",
    "ヤ",
    "ュ",
    "ユ",
    "ョ",
    "ヨ",
    "ラ",
    "リ",
    "ル",
    "レ",
    "ロ",
    "ヮ",
    "ワ",
    "ヰ",
    "ヱ",
    "ヲ",
    "ン",
    "ヴ",
    "ヵ",
    "ヶ",
    "ヷ",
    "ヸ",
    "ヹ",
    "ヺ",
    "ぁ",
    "あ",
    "ぃ",
    "い",
    "ぅ",
    "う",
    "ぇ",
    "え",
    "ぉ",
    "お",
    "か",
    "が",
    "き",
    "ぎ",
    "く",
    "ぐ",
    "け",
    "げ",
    "こ",
    "ご",
    "さ",
    "ざ",
    "し",
    "じ",
    "す",
    "ず",
    "せ",
    "ぜ",
    "そ",
    "ぞ",
    "た",
    "だ",
    "ち",
    "ぢ",
    "っ",
    "つ",
    "づ",
    "て",
    "で",
    "と",
    "ど",
    "な",
    "に",
    "ぬ",
    "ね",
    "の",
    "は",
    "ば",
    "ぱ",
    "ひ",
    "び",
    "ぴ",
    "ふ",
    "ぶ",
    "ぷ",
    "へ",
    "べ",
    "ぺ",
    "ほ",
    "ぼ",
    "ぽ",
    "ま",
    "み",
    "む",
    "め",
    "も",
    "ゃ",
    "や",
    "ゅ",
    "ゆ",
    "ょ",
    "よ",
    "ら",
    "り",
    "る",
    "れ",
    "ろ",
    "ゎ",
    "わ",
    "ゐ",
    "ゑ",
    "を",
    "ん",
    "ゔ",
}

function Symbol(x, y, text)
    local s = {}
    s.x = x
    s.y = y
    s.text = text

    s.render = function()
        love.graphics.print(s.text, font, s.x, s.y)
    end
    return s
end

function Stream()
    local st = {}
    st.symbols = {} -- array of symbols
    st.lengthCount = math.random(15, 70)
    st.count = math.random(-1000, 1)

    return st
end

function love.load()
    -- fullscreen mode
    math.randomseed(os.time())
    love.window.setFullscreen(true)
    WIDTH = love.graphics.getWidth() 
    HEIGHT = love.graphics.getHeight()
    fontSize = 10
    font = love.graphics.newFont("fonts/NotoSansJP-Regular.otf", fontSize)
    dtTotal = 0
    streams = {}
    for x = 1, WIDTH, fontSize do
        local s = Stream()
        local symbol = Symbol(x, s.count, charpool[math.random(1, #charpool)])
        table.insert(s.symbols, 1, symbol)
        s.count = s.count + 1
        table.insert(streams, #streams, s)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

local function generateChar(x, stream)
    local symbol = Symbol(x, (stream.count * fontSize) % HEIGHT, charpool[math.random(1, #charpool)])
    table.insert(stream.symbols, 1, symbol)
    stream.count = stream.count <= HEIGHT and stream.count + 1 or 0
    if stream.count == 0 then
        stream.lengthCount = math.random(15, 70)
    end
    if #stream.symbols >= stream.lengthCount then
        table.remove(stream.symbols, #stream.symbols - 0)
    end
end

function love.update(dt)
    dtTotal = dtTotal + dt
    if dtTotal >= 0.07 then
        dtTotal = 0
        for _, stream in ipairs(streams) do
            local x = #stream.symbols > 0 and stream.symbols[1].x or 0

            generateChar(x, stream)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)
    for _, stream in ipairs(streams) do
        for idx, sym in ipairs(stream.symbols) do
            if idx == 1 then
                love.graphics.setColor(0.68, 0.78, 0.69)
            else
                love.graphics.setColor(0.40, 0.73, 0.40)
            end
            sym.render()
        end
    end
end
