local M = {};

function M.new(params, colors)
  local instance = display.newGroup();
  local polygonGroup = display.newGroup();
  local lineGroup = display.newGroup();
  local rows = params.fractions[1];
  local columns = params.fractions[2];
  local shaded = params.shaded;
  local arrangement = params.arrangement;
  local rowValues, columnValues, shadedPoints = {}, {}, {}, {};
  local polygon, strokePolygon, line, shadedPolygon;
  local width = params.width;
  local height = params.height;
  local widthFactor = width / columns;
  local heightFactor = height / rows;
  local strokes;
  
  if params.strokes == false then
    strokes = false;
  else
    strokes = true;
  end

  local vertices = {
    -width / 2, -height / 2,
    width / 2, -height / 2,
    width / 2, height / 2,
    -width / 2, height / 2
  };

  local function strokeColor(elem)
    elem:setStrokeColor(unpack(colors.strokeColor));
    elem.strokeWidth = 1;
  end

  polygon = display.newPolygon(
    polygonGroup, 
    0, 0, 
    vertices
  );
  polygon:setFillColor(unpack(colors.shapeColor));

  strokePolygon = display.newPolygon(
    lineGroup, 
    0, 0, 
    vertices
  );
  strokePolygon:setFillColor(0, 0, 0, 0);
  strokeColor(strokePolygon);

  table.insert(columnValues, -width / 2);
  table.insert(rowValues, -height / 2);

  for i = 1, columns do
    if i ~= columns  and strokes then
      line = display.newLine(
        lineGroup,
        -width / 2 + widthFactor, - height / 2,
        -width / 2 + widthFactor, height / 2
      );
      strokeColor(line);
    end

    table.insert(columnValues, - width / 2 + widthFactor);
    widthFactor = widthFactor + width / columns;
  end

  for i = 1, rows do
    if i ~= rows and strokes then
      line = display.newLine(
        lineGroup,
        -width / 2, - height / 2 + heightFactor,
        width / 2, - height / 2 + heightFactor
      );
      strokeColor(line);
    end

    table.insert(rowValues, -height / 2 + heightFactor);
    heightFactor = heightFactor + height / rows;
  end

  local function drawPolygon(i, j)
    shadedPoints = {
      columnValues[j], rowValues[i],
      columnValues[j + 1], rowValues[i],
      columnValues[j + 1], rowValues[i + 1],
      columnValues[j], rowValues[i + 1]
    };
    shadedPolygon = display.newPolygon(
      polygonGroup,
      (columnValues[j] + columnValues[j + 1]) / 2,
      (rowValues[i] + rowValues[i + 1]) / 2,
      shadedPoints
    );
    shadedPolygon:setFillColor(unpack(colors.shadedColor));
  end

  local RC = {};
  for i = 1, rows do
    for j = 1, columns do
      table.insert(RC, {i, j});
    end
  end

  for i = 1, #shaded do
    drawPolygon(RC[shaded[i]][1], RC[shaded[i]][2]);
  end

  instance:insert(polygonGroup);
  instance:insert(lineGroup);

  return instance;

end

return M;
