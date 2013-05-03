class PointCloudPoint
{
  PVector pos;
  float x, y, z;
  int pointCloudId;
  
  PointCloudPoint(PVector position, int id)
  {
    pos = position;
    x = pos.x;
    y = pos.y;
    z = pos.z;
    pointCloudId = id;
  }
}
