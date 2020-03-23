local Septagon = require('shapes.septagon');
local Pentagon = require('shapes.pentagon');
local Hexagon = require('shapes.hexagon');
local Octagon = require('shapes.octagon');
local Circle = require('shapes.circle');
local Star = require('shapes.star');
local Triangle = require('shapes.triangle');
local Rectangle = require('shapes.rectangle');

local M = {};

function M.new(params, colors)

	if params.shape == "hexagon" then
		return Hexagon.new(params, colors);
	elseif params.shape == "circle" then
		return Circle.new(params, colors);
	elseif params.shape == "octagon" then
		return Octagon.new(params, colors);
	elseif params.shape == "pentagon" then
		return Pentagon.new(params, colors);
	elseif params.shape == "septagon" then
		return Septagon.new(params, colors);
	elseif params.shape == "star" then
		return Star.new(params, colors);
	elseif params.shape == "triangle" then
		return Triangle.new(params, colors);
	elseif params.shape == "rectangle" then
		return Rectangle.new(params, colors);
	end
end

return M;
