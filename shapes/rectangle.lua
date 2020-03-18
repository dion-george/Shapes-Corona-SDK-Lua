local M = {};

function M.new(params, colors)

	local instance = display.newGroup();
	local polygonGroup = display.newGroup();
	local lineGroup = display.newGroup();
	local rows = params.rows;
	local columns = params.columns;
	local shaded = params.shaded;
	local arrangement = params.arrangement;
	local vertices, rowValues, columnValues, shadedPoints = {}, {}, {}, {};
	local polygon, strokePolygon, line, shadedPolygon;
	local width = params.width;
	local height = params.height;
	local widthFactor = width / columns;
	local heightFactor = height / rows;

	local function strokes(elem)
		elem:setStrokeColor(unpack(colors.strokeColor));
		elem.strokeWidth = 2;
	end

	vertices = { - width / 2, - height / 2, width / 2, - height / 2, width / 2, height / 2, - width / 2, height / 2};
	polygon = display.newPolygon(polygonGroup, 0, 0, vertices );
	polygon:setFillColor(unpack(colors.shapeColor));
	strokePolygon = display.newPolygon(lineGroup, 0, 0, vertices);
	strokePolygon:setFillColor(0, 0, 0, 0 );
	strokes(strokePolygon);
	table.insert(columnValues, - width / 2);
	table.insert(rowValues, - height / 2);

	for i = 1, columns do
		if i ~= columns then
			line = display.newLine(lineGroup, - width / 2 + widthFactor, - height / 2, - width / 2 + widthFactor, height / 2);
			strokes(line);
		end
		table.insert(columnValues, - width / 2 + widthFactor);
		widthFactor = widthFactor + width / columns;
	end

	for i = 1, rows do
		if i ~= rows then
			line = display.newLine(lineGroup, - width / 2, - height / 2 + heightFactor, width / 2, - height / 2 + heightFactor);
			strokes(line);
		end
		table.insert(rowValues, - height / 2 + heightFactor);
		heightFactor = heightFactor + height / rows;
	end

	local function drawPolygon(i, j) 
		shadedPoints = {columnValues[j], rowValues[i], columnValues[j + 1], rowValues[i], columnValues[j + 1], rowValues[i + 1], columnValues[j], rowValues[i + 1]};
		shadedPolygon = display.newPolygon(polygonGroup, (columnValues[j] + columnValues[j + 1]) / 2, (rowValues[i] + rowValues[i + 1]) / 2, shadedPoints);
		shadedPolygon:setFillColor(unpack(colors.shadedColor));
	end

	local function sequentialHighlight()
		local var1 = 1;
		for i = 1, #rowValues - 1 do
			for j = 1, #columnValues - 1 do
				if var1 <= shaded then
					drawPolygon(i, j);
					var1 = var1 + 1;	
				end
			end
		end
	end

	local function alternateHighlight()
		local var1 = 1;
		local flag = 1;
		for i = 1, #rowValues - 1 do
			flag = flag == 1 and 0 or 1;
			for j = 1, #columnValues - 1 do
				if var1 <= shaded and j % 2 == flag then
					drawPolygon(i, j); 
					var1 = var1 + 1;
				end
			end
		end
	end

	local function RCList(R, C)
		local RC = {};
		for i = 1, R do
			for j =1, C do
				table.insert(RC, {i, j});
			end
		end
		return RC;
	end

	local function randomHighlight()
		local RC = {};
		local partitionList = {};
		local randomNumber, R, C;
		RC = RCList(rows, columns);
		for j = 1, #RC do
			table.insert(partitionList, j);
		end	
		for i = 1, shaded do
			randomNumber = partitionList[math.random(#partitionList)]; 
			table.remove(partitionList, table.indexOf(partitionList, randomNumber));
			R = RC[randomNumber][1];
			C = RC[randomNumber][2];
			drawPolygon(R, C);		
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
