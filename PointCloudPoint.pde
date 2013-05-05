class PointCloudPoint
{
  PVector pos;
  float x, y, z;
  int mapX, mapY;
  int pointCloudId;
  
  PointCloudPoint(PVector position, int id, int mX, int mY)
  {
    pos = position;
    x = pos.x;
    y = pos.y;
    z = pos.z;
    pointCloudId = id;
    mapX = mX;
    mapY = mY;
  }
}
