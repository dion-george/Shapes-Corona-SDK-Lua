local M = {};

function M.new(params, colors)

	local instance = display.newGroup();
	local polygonGroup = display.newGroup();
	local lineGroup = display.newGroup();
	local radius = params.style.height/2;
	local sides = 6;
	local partition = params.partition;
	local shaded = params.shaded;
	local arrangement = params.arrangement;
	local degrees = 0;
	local theta;
	local vertices = {};
	local polygon, strokePolygon, line, shadedPolygon;
	local linePoints = {};
	local shadedPoints = {};
	local shadedCenter = {};

	local function strokes(elem)
		elem:setStrokeColor(unpack(colors.strokeColor));
		elem.strokeWidth = 2;
	end

	local circle1 = display.newCircle(polygonGroup, 0, 0, radius);
	for i = 1, sides do	
		theta = math.rad(degrees);
		table.insert(vertices,radius*math.cos(theta));
		table.insert(vertices,radius*math.sin(theta));
		degrees = degrees + 360/sides;
	end
	
	polygon = display.newPolygon(polygonGroup, 0, 0, vertices);
	polygon:setFillColor(unpack(colors.shapeColor));

	strokePolygon = display.newPolygon(lineGroup, 0, 0, vertices);
	strokePolygon:setFillColor(0, 0, 0, 0 );
	strokes(strokePolygon);

	degrees = 0;

	for i = 1, partition do	
		theta = math.rad(degrees);
		table.insert(linePoints,radius*math.cos(theta));
		table.insert(linePoints,radius*math.sin(theta));
		line = display.newLine(lineGroup, 0, 0, linePoints[2*i-1], linePoints[2*i]);
		strokes(line);

		degrees = degrees + 360/partition;
	end

	table.insert(linePoints,linePoints[1]);
	table.insert(linePoints,linePoints[2]);

	local function drawPolygon(i)
		if partition == 6 then
			shadedPoints = {linePoints[2*i-1], linePoints[2*i], 0, 0, linePoints[2*(i+1)-1], linePoints[2*(i+1)]};
			if i%3 == 1 then
				shadedCenter = {shadedPoints[5], (shadedPoints[4] + shadedPoints[6])/2};
			elseif i%3 == 2 then
				shadedCenter = {shadedPoints[3], (shadedPoints[4] + shadedPoints[6])/2};
			elseif i%3 == 0 then
				shadedCenter = {shadedPoints[1], (shadedPoints[2] + shadedPoints[4])/2};
			end	
		elseif partition == 3 then
			shadedPoints = {0, 0, linePoints[2*i-1], linePoints[2*i], vertices[4*i-1], vertices[4*i], linePoints[2*(i+1)-1], linePoints[2*(i+1)]};
			shadedCenter = {(shadedPoints[1] + shadedPoints[5])/2, (shadedPoints[2] + shadedPoints[6])/2};
		elseif partition == 2 then
			shadedPoints = {linePoints[2*i-1], linePoints[2*i], vertices[6*i-3], vertices[6*i-2], vertices[6*i-1], vertices[6*i], linePoints[2*(i+1)-1], linePoints[2*(i+1)]};	
			shadedCenter = {(shadedPoints[3] + shadedPoints[5])/2, (shadedPoints[2] + shadedPoints[6])/2};
		end

		shadedPolygon = display.newPolygon(polygonGroup, shadedCenter[1], shadedCenter[2], shadedPoints);
		shadedPolygon:setFillColor(unpack(colors.shadedColor));
	end
	
	for i = 1, #shaded do
		drawPolygon(shaded[i]);
	end

	instance:insert(polygonGroup);
	instance:insert(lineGroup);
	instance:rotate(-90);
	return instance;

end

return M;