local M = {};

function M.new(params, colors)

	local instance = display.newGroup();
	local polygonGroup = display.newGroup();
	local lineGroup = display.newGroup();
	local radius = (1 - 0.4472) * params.style.height;
	local sides = 10;
	local partition = params.partition[1];
	local shaded = params.shaded;
	local arrangement = params.arrangement;
	local degrees = 0;
	local theta;
	local pointX, pointY, shadedCenterX, shadedCenterY;
	local vertices, linePoints, shadedPoints, shadedCenter = {}, {}, {}, {};
	local polygon, strokePolygon, line, shadedPolygon;

	local function strokes(elem)
		elem:setStrokeColor(unpack(colors.strokeColor));
		elem.strokeWidth = 2;
	end

	for i = 1, sides do	
		theta = math.rad(degrees);
		if i % 2 == 1 then
			pointX = radius * math.cos(theta);
			pointY = radius * math.sin(theta);
		else
			pointX = radius / 2 * math.cos(theta);
			pointY = radius / 2 * math.sin(theta);
		end
		table.insert(vertices, pointX);
		table.insert(vertices, pointY);
		degrees = degrees + 360 / sides;
		
	end

	polygon = display.newPolygon(polygonGroup, 0, 0, vertices);
	polygon.x = (radius * 2 - polygon.width) / 2;
	polygon:setFillColor(unpack(colors.shapeColor));

	strokePolygon = display.newPolygon(lineGroup, 0, 0, vertices);
	strokePolygon.x = (2 * radius - strokePolygon.width) / 2;
	strokePolygon:setFillColor(0, 0, 0, 0);
	strokes(strokePolygon);

	degrees = 0;

	for i = 1, partition do	
		
		theta = math.rad(degrees)
		if i % 2 == 1 or partition == 5 then
			pointX = radius * math.cos(theta);
			pointY = radius * math.sin(theta);
		else
			pointX = radius * 0.5 * math.cos(theta);
			pointY = radius * 0.5 * math.sin(theta);
		end

		table.insert(linePoints, pointX);
		table.insert(linePoints, pointY);
		line = display.newLine(lineGroup, 0, 0, linePoints[2 * i - 1], linePoints[2 * i]);
		strokes(line);

		degrees = degrees + 360 / partition;

	end

	table.insert(linePoints, linePoints[1]);
	table.insert(linePoints, linePoints[2]);

	local function drawPolygon(i)
		if partition == 10 then
			shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i], 0, 0, linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]};
			if i == 1 or i == 2 or i == 5 or i == 6 or i == 7 or i == 8 then
				shadedCenterX = (shadedPoints[1] + shadedPoints[3]) / 2;
				shadedCenterY = (shadedPoints[4] + shadedPoints[6]) / 2;
				if i == 8 then
					shadedCenterX = (shadedPoints[1] + shadedPoints[5]) / 2;
				end
				if i == 5 then
					shadedCenterY = (shadedPoints[2] + shadedPoints[6]) / 2;
				end
				if i == 6 then
					shadedCenterX = (shadedPoints[3] + shadedPoints[5]) / 2;
				end
				if i == 7 then
					shadedCenterY = (shadedPoints[2] + shadedPoints[4]) / 2;
				end
			elseif i == 3 or i == 4 or i == 9 or i == 10 then
				shadedCenterX = (shadedPoints[3] + shadedPoints[5]) / 2;
				shadedCenterY = (shadedPoints[2] + shadedPoints[4]) / 2;
				if i == 3 then
					shadedCenterX = (shadedPoints[1] + shadedPoints[5]) / 2;
				end
				if i == 4 then
					shadedCenterY = (shadedPoints[4] + shadedPoints[6]) / 2;
				end
			end
			shadedCenter = {shadedCenterX, shadedCenterY};

		elseif partition == 5 then	
			if i == 1 then
				shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i], 0, 0, linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)], vertices[2 * (i + 1) - 1], vertices[2 * (i + 1)]};
				shadedCenter = {(shadedPoints[1] + shadedPoints[3]) / 2, (shadedPoints[4] + shadedPoints[6]) / 2};
			elseif i == 2 then
				shadedPoints = {vertices[3 * i - 1], vertices[3 * i], 0, 0, vertices[5 * i - 1], vertices[5 * i], vertices[4 * i - 1], vertices[4 * i]};
				shadedCenter = {(shadedPoints[1] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[4]) / 2};
			elseif i == 3 then
				shadedPoints = {vertices[3 * i], vertices[3 * i + 1], 0, 0, vertices[3 * (i + 1) + 1], vertices[3 * (i + 1) + 2], vertices[3 * (i + 1) - 1], vertices[3 * (i + 1)]};
				 -- shadedCenter = {(shadedPoints[3] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
				shadedCenter = {(shadedPoints[1] + shadedPoints[3]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
			elseif i == 4 then
				shadedPoints = {vertices[3 * i + 1], vertices[3 * i + 2], 0, 0, vertices[4 * i + 1], vertices[4 * i + 2], vertices[4 * i - 1], vertices[4 * i]};
				shadedCenter = {(shadedPoints[1] + shadedPoints[5]) / 2, (shadedPoints[4] + shadedPoints[6]) / 2};
			elseif i == 5 then
				shadedPoints = {vertices[3 * i + 2], vertices[3 * i + 3], 0, 0, linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)], vertices[4 * i - 1], vertices[4 * i]};
				shadedCenter = {(shadedPoints[3] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
			end
		elseif partition == 2 then
			if i == 1 then
				shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i], vertices[2 * (i + 1) - 1], vertices[2 * (i + 1)], vertices[2 * (i + 2) - 1], vertices[2 * (i + 2)], vertices[2 * (i + 3) - 1], vertices[2 * (i + 3)], vertices[2 * (i + 4) - 1], vertices[2 * (i + 4)], linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]};
				shadedCenter = {(shadedPoints[1] + shadedPoints[9]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
			elseif i == 2 then
				shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i], vertices[7 * i - 1], vertices[7 * i], vertices[8 * i - 1], vertices[8 * i], vertices[9 * i - 1], vertices[9 * i], vertices[10 * i - 1], vertices[10 * i], linePoints[2 * i - 3], linePoints[2 * i - 2]};
				shadedCenter = {(shadedPoints[3] + shadedPoints[11]) / 2, (shadedPoints[2] + shadedPoints[8]) / 2};
			end
		end
		 shadedPolygon = display.newPolygon(polygonGroup, shadedCenter[1], shadedCenter[2], shadedPoints);
		 shadedPolygon:setFillColor(unpack(colors.shadedColor));
	end

	for i = 1, #shaded do
		drawPolygon(shaded[i]);
	end

	polygonGroup.x = params.style.height/2 - radius;
	lineGroup.x = params.style.height/2 - radius;
	instance:insert(polygonGroup);
	instance:insert(lineGroup);
	instance:rotate(-90);

	return instance;

end

return M;
