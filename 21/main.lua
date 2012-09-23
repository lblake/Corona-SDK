-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )


local deckSize = 52

local suits = {"C", "D", "H", "S"}

local cardVals = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K","A"}

--shuffle(currentDeck)

local function shuffle(t)

    local n = #t

    math.randomseed(os.time())

    while n>=2 do

        local k = math,random(n)

        t[n], t[k] = t[k], t[n]

        n = n -1


    end

    for i = 1, #t do
        print(i,t[i])
    end

    return t
end

local currentDeck = {}

local counter = 0

for i = 1, #suits do
    for j = 1, #cardVals do
        counter = counter + 1
        currentDeck[counter] = suits[i]..cardVals[j]

        print(counter, currentDeck[counter])
    end

end   

