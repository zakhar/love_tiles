local maps = {}

local fun = require("fun")


local TileW, TileH = 32, 32
local TileTable = {}
local Quads = {}


local function readFile(path)
    local file = io.open(path, "rb") -- r read mode and b binary mode
    if not file then
        return nil
    end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end


function toArray(...)
    local arr = {}
    for v in ... do
        arr[#arr + 1] = v
    end
    return arr
end


function createQuadsInfo(quadsString)
    local quadsInfo = {}
    local rowsArray = toArray(quadsString:gmatch("[^\n]+"))

    for _it, rowIndex, line in fun.enumerate(rowsArray) do
        for _it, columnIndex, char in fun.enumerate(line) do
            table.insert(quadsInfo, {char, columnIndex-1, rowIndex-1})
        end
    end
    return quadsInfo
end


function maps.load(pathToMap)
    local content = readFile(pathToMap)
    local tileImageFile, quadsString, tilesString = unpack(
        toArray(content:gmatch("(.-)\n\n")))
    local quadsInfo = createQuadsInfo(quadsString)
    _loadMap(tileImageFile, tilesString, quadsInfo)
end


function maps.draw()
    for rowIndex, tileRow in ipairs(TileTable) do
        for columnIndex, quadIndex in ipairs(tileRow) do
            local x, y = (rowIndex - 1) * TileW, (columnIndex - 1) * TileH
            love.graphics.draw(Tileset, Quads[quadIndex], x, y)
        end
    end
end


function _loadMap(imageFile, tilesString, quadsInfo)
    -- Load quads
    Tileset = love.graphics.newImage(imageFile)
    local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()
    for _, quadInfoRow in ipairs(quadsInfo) do
        local quadCode, xIndex, yIndex = unpack(quadInfoRow)
        Quads[quadCode] = love.graphics.newQuad(
            xIndex * TileW, yIndex * TileH, TileW, TileH, tilesetW, tilesetH)
    end

    -- Load TileTable
    local width = #(tilesString:match("[^\n]+"))
    for x = 1, width do TileTable[x] = {} end

    local rowIndex, columnIndex = 1, 1
    for row in tilesString:gmatch("[^\n]+") do
        assert(#row == width, 'Map is not aligned: width of row ' .. tostring(rowIndex) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
        rowIndex = 1
        for character in row:gmatch(".") do
            TileTable[rowIndex][columnIndex] = character
            rowIndex = rowIndex + 1
        end
        columnIndex = columnIndex + 1
    end
end


return maps
