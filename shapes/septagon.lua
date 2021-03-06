local M = {};

function M.new(params, colors)

	local instance = display.newGroup();
	local polygonGroup = display.newGroup();
	local lineGroup = display.newGroup();
	local height = params.height;
	local radius = height / 1.901;
	local sides = 7;
	local fractions = params.fractions[1];
	local shaded = params.shaded;
	local arrangement = params.arrangement;
	local degrees = 0;
	local theta;
	local pointX, pointY;
	local vertices, linePoints, shadedPoints, shadedCenter = {}, {}, {}, {};
	local polygon, strokePolygon, line, shadedPolygon;
  local strokes;
  
  if params.strokes == false then
    strokes = false;
  else
    strokes = true;
  end

	local function strokeColor(elem)
		elem:setStrokeColor(unpack(colors.strokeColor));
		elem.strokeWidth = 1;
	end

	for i = 1, sides do
		theta = math.rad(degrees);
		table.insert(vertices, radius * math.cos(theta));
		table.insert(vertices, radius * math.sin(theta));
		degrees = degrees + 360 / sides;
	end

	polygon = display.newPolygon(
    polygonGroup, 
    0, 0, 
    vertices
  );
	polygon.x = (radius * 2 - polygon.width) / 2;
	polygon:setFillColor(unpack(colors.shapeColor));

	strokePolygon = display.newPolygon(
    lineGroup, 
    0, 0, 
    vertices
  );
	strokePolygon.x = (2 * radius - strokePolygon.width) / 2;
	strokePolygon:setFillColor(0, 0, 0, 0);
	strokeColor(strokePolygon);

	degrees = 0;

	for i = 1, fractions do	
		theta = math.rad(degrees);
		if i % 2 == 0 and fractions == 2 then
			pointX = (radius * 0.91) * math.cos(theta);
			pointY = radius * math.sin(theta);
		else
			pointX = radius * math.cos(theta);
			pointY = radius * math.sin(theta);
		end

		table.insert(linePoints, pointX);
    table.insert(linePoints, pointY);
    if strokes then
      line = display.newLine(
        lineGroup, 
        0, 0, 
        linePoints[2 * i - 1], linePoints[2 * i]
      );
      strokeColor(line);
    end
		degrees = degrees + 360 / fractions;

	end

	table.insert(linePoints, linePoints[1]);
	table.insert(linePoints, linePoints[2]);

	local function drawPolygon(i)

		if fractions == 7 then	
			shadedPoints = {
        linePoints[2 * i - 1], linePoints[2 * i], 
        0, 0, 
        linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]
      };
			if i == 1 then
				shadedCenter = {
          (shadedPoints[1] + shadedPoints[3]) / 2, 
          (shadedPoints[4] + shadedPoints[6]) / 2
        };
			elseif i == 2 then
				shadedCenter = {
          (shadedPoints[1] + shadedPoints[5]) / 2, 
          (shadedPoints[4] + shadedPoints[6]) / 2
        };
			elseif i == 3 then
				 -- shadedCenter = {(shadedPoints[3] + shadedPoints[5]) / 2, (shadedPoints[2] + shadedPoints[4]) / 2};
				shadedCenter = {
          (shadedPoints[3] + shadedPoints[5]) / 2, 
          (shadedPoints[2] + shadedPoints[4]) / 2
        };
			elseif i == 4 then
				 -- shadedCenter = {(shadedPoints[3] + shadedPoints[5]) / 2, (shadedPoints[4] + shadedPoints[6]) / 2};
				shadedCenter = {
          (shadedPoints[1] + shadedPoints[3]) / 2, 
          (shadedPoints[2] + shadedPoints[6]) / 2
        };
			elseif i == 5 then
				shadedCenter = {
          (shadedPoints[1] + shadedPoints[3]) / 2, 
          (shadedPoints[4] + shadedPoints[6]) / 2
        };
			elseif i == 6 then
				shadedCenter = {
          (shadedPoints[1] + shadedPoints[5]) / 2, 
          (shadedPoints[2] + shadedPoints[4]) / 2
        };
			elseif i == 7 then
				shadedCenter = {
          (shadedPoints[3] + shadedPoints[5]) / 2, 
          (shadedPoints[2] + shadedPoints[6]) / 2
        };				
			end
		elseif fractions == 2 then
			if i == 1 then
				shadedPoints = {
          linePoints[2 * i - 1], linePoints[2 * i], 
          vertices[2 * (i + 1) - 1], vertices[2 * (i + 1)], 
          vertices[2 * (i + 2) - 1], vertices[2 * (i + 2)], 
          vertices[2 * (i + 3) - 1], vertices[2 * (i + 3)], 
          linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]
        };
				shadedCenter = {
          (shadedPoints[1] + shadedPoints[7]) / 2, 
          (shadedPoints[2] + shadedPoints[6]) / 2
        };
			elseif i == 2 then
				shadedPoints = {
          linePoints[2 * i - 1], linePoints[2 * i],
          vertices[5 * i - 1], vertices[5 * i], 
          vertices[6 * i - 1], vertices[6 * i], 
          vertices[7 * i - 1], vertices[7 * i], 
          linePoints[2 * i - 3], linePoints[2 * i - 2]
        };
				shadedCenter = {
          (shadedPoints[1] + shadedPoints[9]) / 2, 
          (shadedPoints[2] + shadedPoints[6]) / 2
        };
			end
		end
		shadedPolygon = display.newPolygon(
      polygonGroup, 
      shadedCenter[1], shadedCenter[2], 
      shadedPoints
    );
		shadedPolygon:setFillColor(unpack(colors.shadedColor));
	end

	for i = 1, #shaded do
		drawPolygon(shaded[i]);
	end

	instance:insert(polygonGroup);
	instance:insert(lineGroup);
	polygonGroup.x = height / 2 - radius;
	lineGroup.x = height / 2 - radius;
	instance:rotate(-90);

	return instance;
end

return M;
