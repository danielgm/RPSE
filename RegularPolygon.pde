//A simple class to deal with regular polygons

static class Polygon {   
        
    //Returns a regular polygon as an array of PVectors 
    static PVector[] createPolygon(int sides, float cx, float cy, float radius, float angle) {
        float a = TWO_PI/sides;
        PVector[] vertices = new PVector[sides];
        for (int i=0; i<sides; i++) {
            float currentAngle = angle+(i*a);
            vertices [i] = new PVector (cx + cos(currentAngle)*radius, cy + sin(currentAngle)*radius);  
        }
        return vertices;
    }
  
    //Returns the center of a regular polygon. Careful: it doesn't check whether the input is a well-formed regular polygon.
    static PVector center(PVector[] v) 
    {
        int l = v.length, 
            m = l/2;

        if (l%2 != 0) return LineIntersector.simpleIntersect(v[0].x, v[0].y, (v[m].x + v[m+1].x)*.5, (v[m].y + v[m+1].y)*.5,
                                                             v[1].x, v[1].y, (v[m+1].x + v[(m+2)%l].x)*.5, (v[m+1].y + v[(m+2)%l].y)*.5);     
                      return LineIntersector.simpleIntersect(v[0].x, v[0].y, v[m].x, v[m].y,
                                                             v[1].x, v[1].y, v[(m+1)%l].x, v[(m+1)%l].y);
    }
}
