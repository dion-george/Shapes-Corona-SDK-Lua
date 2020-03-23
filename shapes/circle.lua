local M = {};

function M.new(params, colors)

	local instance = display.newGroup();
	local circleGroup = display.newGroup();
	local multiple = display.pixelWidth / display.contentWidth;
	local inputRadius = params.style.height / 2;
	local radius = inputRadius * multiple;
	local diameter = radius * 2;
	local partition = params.partition[1];
	local shaded = params.shaded;
	local arrangement = params.arrangement;
	local lastPoints, minPoints, maxPoints, shadedList = {}, {}, {}, {};
	local minX, maxX, minY, maxY;
	local rotateToGlobal;
	local polygon;
	local realAngle = 360 / partition;
	local angle = math.floor(360 / partition);
	local difference = math.floor((realAngle - angle) * 100);

	local function semiCircle(angle, x, y)

		minX, maxX, minY, maxY = 0, 0, 0, 0;

		local function rotateAboutPoint(point, degrees, centre)
			local pt = { x = point.x - centre.x, y = point.y - centre.y};
			pt = rotateToGlobal(pt, degrees);
			pt.x, pt.y = pt.x + centre.x, pt.y + centre.y;
			return pt;
		end

		local function rotateTo(point, degrees, center)
			if (center ~= nil) then
				return rotateAboutPoint(point, degrees, center);
			else
				local x, y = point.x, point.y;
				local theta = math.rad(degrees);
				local pt = {
					x = x * math.cos(theta) - y * math.sin(theta), 
					y = x * math.sin(theta) + y * math.cos(theta)
				}
				return pt;
			end
		end

		local center, first, angle = {x=0, y=0}, {x = x, y = y}, angle;
		rotateToGlobal = rotateTo;
		local points = {};
		points[#points + 1] = 0;
		points[#points + 1] = 0;
		points[#points + 1] = first.x;

		if first.x < minX then
			minX = first.x;
		elseif first.x > maxX then
			maxX = first.x;
		end

		points[#points + 1] = first.y;
			
		if first.y < minY then
			minY = first.y;
		elseif first.y > maxY then
			maxY = first.y;
		end
		
		local point = {x=first.x, y= first.y};

		for i=1, angle do
			point = rotateToGlobal(point, 1, center);
			points[#points + 1] = point.x;
			points[#points + 1] = point.y;

			if point.x < minX then
				minX = point.x;
			elseif point.x > maxX then
				maxX = point.x;
			end
			if point.y < minY then
				minY = point.y;
			elseif point.y > maxY then
				maxY = point.y;
			end

			if i == angle then
				if realAngle ~= angle then
					for j = 1, difference do
						point = rotateToGlobal(point, 0.01, center);
					end
				end
				table.insert(lastPoints, point.x);
				table.insert(lastPoints, point.y);
			end
		end

		table.insert(minPoints, minX);
		table.insert(minPoints, minY);
		table.insert(maxPoints, maxX);
		table.insert(maxPoints, maxY);

		return points
	end

	table.insert(lastPoints, 0);
	table.insert(lastPoints, - radius);

	for i = 1, partition do
		local polygon = display.newPolygon(circleGroup, 0, 0, semiCircle(angle, lastPoints[2 * i - 1], lastPoints[2 * i]));
		polygon.x = (minPoints[2 * i - 1] + maxPoints[2 * i - 1]) / 2;
		polygon.y = (minPoints[2 * i] + maxPoints[2 * i]) / 2;
		polygon:setFillColor(unpack(colors.shapeColor));
		polygon.strokeWidth = 2 * multiple;
		polygon:setStrokeColor(unpack(colors.strokeColor))
		table.insert(shadedList, polygon);
	end

	local snapshot = display.newSnapshot(multiple * diameter, multiple * diameter);
	snapshot.group:insert(circleGroup);
	snapshot.xScale = 1 / multiple;
	snapshot.yScale = 1 / multiple;

	for i = 1, #shaded do
		shadedList[shaded[i]]:setFillColor(unpack(colors.shadedColor));
	end

	instance:insert(snapshot);
	return instance;

end

return M;
