local M = {};

function M.new(params, colors)

	local instance = display.newGroup();
	local polygonGroup = display.newGroup();
	local lineGroup = display.newGroup();
	local radius = params.radius;
	local sides = 5;
	local partition = params.partition;
	local shaded = params.shaded;
	local arrangement = params.arrangement;
	local degrees = 0;
	local theta;
	local pointX, pointY, shadedCenterX, shadedCenterY;
	local vertices, linePoints, shadedPoints, shadedCenter = {}, {}, {}, {};
	local polygon, strokePolygon, line, shadedPolygon;

	for i = 1, sides do	
		theta = math.rad(degrees);
		table.insert(vertices, radius * math.cos(theta));
		table.insert(vertices, radius * math.sin(theta));
		degrees = degrees + 360 / sides;
	end

	polygon = display.newPolygon(polygonGroup, 0, 0, vertices);
	polygon.x = (radius * 2 - polygon.width) / 2;
	polygon:setFillColor(unpack(colors.shapeColor));

	strokePolygon = display.newPolygon(lineGroup, 0, 0, vertices);
	strokePolygon.x = (radius * 2 - strokePolygon.width) / 2;
	strokePolygon:setFillColor(0, 0, 0, 0);
	strokePolygon:setStrokeColor(unpack(colors.strokeColor));
	strokePolygon.strokeWidth = 2;

	degrees = 0;

	for i = 1, partition do	
		theta = math.rad(degrees);
		if i % 2 == 1 or partition == 5 then
			pointX = radius * math.cos(theta);
			pointY = radius * math.sin(theta);
		else
			pointX = ((math.sqrt(3) / 2 * radius) - 0.055 * radius) * math.cos(theta);
			pointY = ((math.sqrt(3) / 2 * radius) - 0.055 * radius) * math.sin(theta);
		end
		table.insert(linePoints, pointX);
		table.insert(linePoints, pointY);
		line = display.newLine(lineGroup, 0, 0, linePoints[2 * i - 1], linePoints[2 * i]);
		line:setStrokeColor(1, 0, 0, 1);
		line.strokeWidth = 2;
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
			elseif i == 3 or i == 4 or i == 9 or i == 10 then
				shadedCenterX = (shadedPoints[3] + shadedPoints[5]) / 2;
				shadedCenterY = (shadedPoints[2] + shadedPoints[4]) / 2;
				if i == 3 then
					shadedCenterX = (shadedPoints[1] + shadedPoints[5]) / 2;
				end
			end
			shadedCenter = {shadedCenterX, shadedCenterY};
		elseif partition == 5 then	
			shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i], 0, 0, linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]};		
			if i == 1 then
				shadedCenter = {(shadedPoints[1] + shadedPoints[3]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
			elseif i == 2 then
				shadedCenter = {(shadedPoints[1] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[4]) / 2};
			elseif i == 3 then
				shadedCenter = {(shadedPoints[1] + shadedPoints[3]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
			elseif i == 4 then
				shadedCenter = {(shadedPoints[1] + shadedPoints[5]) / 2, (shadedPoints[4] + shadedPoints[6]) / 2};
			elseif i == 5 then
				shadedCenter = {(shadedPoints[3] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
			end
		elseif partition == 2 then
			if i == 1 then
				shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i],vertices[2 * (i + 1) - 1], vertices[2 * (i + 1)], vertices[2 * (i + 2) - 1], vertices[2 * (i + 2)],linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]};
				shadedCenter = {(shadedPoints[1] + shadedPoints[7]) / 2, (shadedPoints[2] + shadedPoints[4]) / 2};
			elseif i == 2 then
				shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i],vertices[4 * i - 1], vertices[4 * i], vertices[5 * i - 1], vertices[5 * i], linePoints[2 * i - 3], linePoints[2 * i - 2]};
				shadedCenter = {(shadedPoints[1] + shadedPoints[7]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
			end
		end
			shadedPolygon = display.newPolygon(polygonGroup, shadedCenter[1], shadedCenter[2], shadedPoints);
			shadedPolygon:setFillColor(unpack(colors.shadedColor));
	end

	local function sequentialHighlight()
		for i = 1, shaded do
			drawPolygon(i);
		end
	end

	local function alternateHighlight()
		local j = 1;
		for i = 1, partition do
			if i % 2 == 1 and j <= shaded then
				drawPolygon(i);
				j = j + 1;
			end
		end
	end

	local function randomHighlight()
		local partitionList = {};
		for i = 1, partition do
			table.insert(partitionList, i);
		end

		for i = 1, shaded do
			i = partitionList[math.random(#partitionList)]; 
			table.remove(partitionList, table.indexOf(partitionList, i));
			drawPolygon(i);
		end
	end

	if arrangement == 1 then
		sequentialHighlight();
	elseif arrangement == 2 then
		alternateHighlight();
	elseif arrangement == 3 then
		randomHighlight();
	end

	instance:insert(polygonGroup);
	instance:insert(lineGroup);

	return instance;

end


return M;