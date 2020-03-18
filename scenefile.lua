local Shapes = require('shapes.main');

local composer = require("composer");
local scene = composer.newScene();

local CCX = display.contentWidth * 0.5;
local CCY = display.contentHeight * 0.5;
    
local shapes;

local params = {
	shape = 'hexagon',
	radius = 100,
	width = 250,
	rows = 3,
	columns = 4,
	height = 200,
	partition = 6,
	shaded = 2,
	arrangement = 3
}

local colors = {
	shapeColor = {1, 1, 1, 1},
	shadedColor = {0, 1, 1, 1},
	strokeColor = {1, 0, 0, 1},

}

function scene:show()
    shapes = Shapes.new(params,colors);
	shapes.x = CCX;
	shapes.y = CCY;

end

scene:addEventListener("show", scene);

return scene;
