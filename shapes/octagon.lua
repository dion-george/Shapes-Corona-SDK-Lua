local M = {};

function M.new(params, colors)

	local instance = display.newGroup();
	local polygonGroup = display.newGroup();
	local lineGroup = display.newGroup();
	local radius = params.height / 2;
	local sides = 8;
	local fractions = params.fractions[1];
	local shaded = params.shaded;
	local arrangement = params.arrangement;
	local degrees = 0;
	local theta;
	local polygon, strokePolygon, line, shadedPolygon;
  local vertices, linePoints, shadedPoints, shadedCenter = {}, {}, {}, {};
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
    0, 0, vertices
  );
	polygon:setFillColor(unpack(colors.shapeColor));


	strokePolygon = display.newPolygon(
    lineGroup, 
    0, 0, 
    vertices
  );
	strokePolygon:setFillColor(0, 0, 0, 0);
	strokeColor(strokePolygon);

	degrees = 0;

	for i = 1, fractions do	
		theta = math.rad(degrees);
		table.insert(linePoints, radius * math.cos(theta));
    table.insert(linePoints, radius * math.sin(theta));
    if strokes then
      line = display.newLine(lineGroup, 0, 0, linePoints[2 * i - 1], linePoints[2 * i]);
      strokeColor(line);
    end
		degrees = degrees + 360 / fractions;
	end

	table.insert(linePoints, linePoints[1]);
	table.insert(linePoints, linePoints[2]);

	local function drawPolygon(i)

		if fractions == 8 then
			shadedPoints = {
        linePoints[2 * i - 1], linePoints[2 * i], 
        0, 0, 
        linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]
      };
				
				if i % 4 == 1 or i % 4 == 2 then
					shadedCenter = {
            (shadedPoints[1] + shadedPoints[3]) / 2, 
            (shadedPoints[4] + shadedPoints[6]) / 2
          };
				else
					shadedCenter = {
            (shadedPoints[3] + shadedPoints[5]) / 2, 
            (shadedPoints[2] + shadedPoints[4]) / 2
          };
				end
				
			elseif fractions == 4 then
				shadedPoints = {
          0, 0, 
          linePoints[2 * i - 1], linePoints[2 * i], 
          vertices[4 * i - 1], vertices[4 * i], 
          linePoints[2 * (i + 1) - 1], linePoints[2 * (i + 1)]
        };
				if i % 2 == 1 then
					shadedCenter = {
            (shadedPoints[1] + shadedPoints[3]) / 2, 
            (shadedPoints[2] + shadedPoints[8]) / 2
          };
				else
					shadedCenter = {
            (shadedPoints[1] + shadedPoints[7]) / 2, 
            (shadedPoints[2] + shadedPoints[4]) / 2
          };
				end
				
			elseif fractions == 2 then
				if i == 1 then
					shadedPoints = {
            vertices[2 * i - 1], vertices[2 * i], 
            vertices[4 * i - 1], vertices[4 * i], 
            vertices[6 * i - 1], vertices[6 * i], 
            vertices[8 * i - 1], vertices[8 * i], 
            vertices[10 * i - 1], vertices[10 * i]
          };	
				elseif i == 2 then 
					shadedPoints = {
            vertices[5 * i - 1], vertices[5 * i], 
            vertices[6 * i - 1], vertices[6 * i], 
            vertices[7 * i - 1], vertices[7 * i], 
            vertices[8 * i - 1], vertices[8 * i], 
            vertices[i - 1], vertices[i]
          };	
				end
				shadedCenter = {
          (shadedPoints[1] + shadedPoints[9]) / 2, 
          (shadedPoints[2] + shadedPoints[6]) / 2
        };
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
	return instance;

end

return M;
