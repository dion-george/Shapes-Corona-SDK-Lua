local M = {};

function M.new(params, colors)

	local instance = display.newGroup();

	local polygonGroup = display.newGroup();
	local lineGroup = display.newGroup();
	local radius = params.radius;
	local sides = 3;
	local partition = params.partition;
	local shaded = params.shaded;
	local arrangement = params.arrangement;
	local degrees = 0;
	local theta;
	local pointX, pointY;
	local vertices = {};
	local polygon, strokePolygon, line, shadedPolygon;
	local linePoints = {};
	local shadedPoints = {};
	local shadedCenter = {};

	local function strokes(elem)
		elem:setStrokeColor(unpack(colors.strokeColor));
		elem.strokeWidth = 2;
	end

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
	strokePolygon.x = (2 * radius - strokePolygon.width) / 2;
	strokePolygon:setFillColor(0, 0, 0, 0);
	strokes(strokePolygon);

	degrees = 0;

	if partition == 2 or partition == 3 or partition == 6 then
		for i = 1, partition do	
			theta = math.rad(degrees);
			if i % 2 == 1 or partition == 3 then
				pointX = radius * math.cos(theta);
				pointY = radius * math.sin(theta);
			else
				pointX = radius / 2 * math.cos(theta);
				pointY = radius / 2 * math.sin(theta);
			end
			table.insert(linePoints, pointX);
			table.insert(linePoints, pointY);
			line = display.newLine(lineGroup, 0, 0, linePoints[2 * i - 1], linePoints[2 * i]);
			strokes(line);
			degrees = degrees + 360 / partition;
		end

		table.insert(linePoints, linePoints[1]);
		table.insert(linePoints, linePoints[2]);

	elseif partition == 4 or partition == 9 then

		table.insert(linePoints, vertices[1]);
		table.insert(linePoints, vertices[2]);
		table.insert(linePoints, vertices[3]);
		table.insert(linePoints, (vertices[4] + vertices[6]) / 2);

		if partition == 4 then
			midvalueX = (linePoints[1] + linePoints[3]) / 2;
			midTopY = - (linePoints[1] - midvalueX) / math.sqrt(3);
			midBottomY = (linePoints[1] - midvalueX) / math.sqrt(3);
			positionY = midTopY;
			for i = 1, 2 do
			line = display.newLine(lineGroup, midvalueX, 0, midvalueX, positionY);
			strokes(line);
			line = display.newLine(lineGroup, midvalueX, positionY, linePoints[3], linePoints[4]);
			strokes(line);
			positionY = - positionY;
			end
		end

		if partition == 9 then
			valueX_1 = linePoints[1] - (linePoints[1] - linePoints[3]) / 3;
			valueY_1 = linePoints[1] - valueX_1;
			topY_1 = - valueY_1 / math.sqrt(3);
			bottomY_1 = valueY_1 / math.sqrt(3);
			valueX_2 = valueX_1 - (linePoints[1] - linePoints[3]) / 3;
			valueY_2 = linePoints[1] - valueX_2;
			topY_2 = - valueY_2 / math.sqrt(3);
			bottomY_2 = valueY_2 / math.sqrt(3);
			valueX = linePoints[1] - (linePoints[1] - linePoints[3]) / 3;
			for i = 1, 4 do
				valueY = linePoints[1] - valueX;
				topY = - valueY / math.sqrt(3);
				bottomY = valueY / math.sqrt(3);
				positionY = i % 2 == 1 and topY or bottomY;
		
				line = display.newLine(lineGroup, valueX, 0, valueX, positionY);
				strokes(line);
				if i == 2 then
					valueX = valueX - (vertices[1] - vertices[3]) / 3;
				end
			end
		
			 -- Diagonal Lines
			positionY = topY_1;
			for i = 1, 2 do
			line = display.newLine(lineGroup, valueX_1, positionY, valueX_2, 0);
			strokes(line);
			positionY = bottomY_1; 
			end
		
			 -- Second diagonal lines
			line = display.newLine(lineGroup, valueX_2, topY_2, vertices[3], (vertices[6] + (vertices[4] - vertices[6]) / 3));
			strokes(line);
		
			line = display.newLine(lineGroup, valueX_2, 0, vertices[3], (vertices[6] + (vertices[4] - vertices[6]) / 3));
			strokes(line);
		
			line = display.newLine(lineGroup, valueX_2, 0, vertices[3], (vertices[4] - (vertices[4] - vertices[6]) / 3));
			strokes(line);
		
			line = display.newLine(lineGroup, valueX_2, bottomY_2, vertices[3], (vertices[4] - (vertices[4] - vertices[6]) / 3));
			strokes(line);
		end
	end

	local function drawPolygon(i)

		if partition == 6 then
			shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i], 0, 0, linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]};
				
			if i % 3 == 1 then
				shadedCenter = {(shadedPoints[1] + shadedPoints[3]) / 2, (shadedPoints[4] + shadedPoints[6]) / 2};
			elseif i % 3 == 2 then
				if i == 5 then
				shadedCenter = {(shadedPoints[1] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[4]) / 2};
				else
					shadedCenter = {(shadedPoints[1] + shadedPoints[5]) / 2, (shadedPoints[4] + shadedPoints[6]) / 2};
				end
			elseif i % 3 == 0 then
				shadedCenter = {(shadedPoints[3] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[4]) / 2};
			end
			
		elseif partition == 3 then
			shadedPoints = {0, 0, linePoints[2 * i - 1], linePoints[2 * i], linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]};
			if i == 1 then
			shadedCenter = {(shadedPoints[3] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
			elseif i == 2 then
				shadedCenter = {(shadedPoints[1] + shadedPoints[5]) / 2, (shadedPoints[4] + shadedPoints[6]) / 2};
			else
				shadedCenter = {(shadedPoints[3] + shadedPoints[5]) / 2, (shadedPoints[4] + shadedPoints[6]) / 2};
			end
			
		elseif partition == 2 then
			shadedPoints = {linePoints[2 * i - 1], linePoints[2 * i], vertices[2 * i + 1], vertices[2 * i + 2], linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]};	
			shadedCenter = {(shadedPoints[1] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[4]) / 2};
		
		elseif partition == 9 then
			if i == 1 then
				shadedPoints = {valueX_1, topY_1, linePoints[1], linePoints[2], valueX_1, bottomY_1};
			elseif i == 2 then
				shadedPoints = {valueX_2, topY_2, valueX_1, topY_1, valueX_2, 0};
			elseif i == 3 then
				shadedPoints = {valueX_1, topY_1, valueX_2, 0, valueX_1, bottomY_1};
			elseif i == 4 then
				shadedPoints = {valueX_2, 0, valueX_1, bottomY_1, valueX_2, bottomY_2};
			elseif i == 5 then
				shadedPoints = {vertices[5], vertices[6], valueX_2, topY_2, vertices[5], (vertices[6] + (vertices[4] - vertices[6]) / 3)};
			elseif i == 6 then
				shadedPoints = {valueX_2, topY_2, vertices[5], (vertices[6] + (vertices[4] - vertices[6]) / 3), valueX_2, 0};
			elseif i == 7 then
				shadedPoints = {vertices[5], (vertices[6] + (vertices[4] - vertices[6]) / 3), valueX_2, 0, vertices[5], (vertices[4] - (vertices[4] - vertices[6]) / 3)};
			elseif i == 8 then
				shadedPoints = {valueX_2, 0, vertices[5], (vertices[4] - (vertices[4] - vertices[6]) / 3), valueX_2, bottomY_2};
			elseif i == 9 then
				shadedPoints = {vertices[5], (vertices[4] - (vertices[4] - vertices[6]) / 3), valueX_2, bottomY_2, vertices[3], vertices[4]};
			end
			shadedCenter = {(shadedPoints[1] + shadedPoints[3]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
	
		elseif partition == 4 then
			if i == 1 then
				shadedPoints = {midvalueX, midTopY, linePoints[1], linePoints[2], midvalueX, midBottomY};
			elseif i == 2 then
				shadedPoints = {vertices[5], vertices[6], midvalueX, midTopY, linePoints[3], linePoints[4]};
			elseif i == 3 then
				shadedPoints = {midvalueX, midTopY, linePoints[3], linePoints[4], midvalueX, midBottomY};
			elseif i == 4 then
				shadedPoints = {linePoints[3], linePoints[4], midvalueX, midBottomY, vertices[3], vertices[4]};
			end
			shadedCenter = {(shadedPoints[1] + shadedPoints[3]) / 2, (shadedPoints[2] + shadedPoints[6]) / 2};
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
	instance:rotate(-90);
	
	return instance;

end

return M;