//A simple class to deal with regular polygons

class Polygon {
    int _generation;
    PVector[] _vertices;
    
    Polygon(int generation, int sides, float cx, float cy, float radius, float angle) {
        float a = TWO_PI/sides;
        PVector[] vertices = new PVector[sides];
        for (int i=0; i<sides; i++) {
            float currentAngle = angle+(i*a);
            vertices [i] = new PVector (cx + cos(currentAngle)*radius, cy + sin(currentAngle)*radius);  
        }
        
        _generation = generation;
        _vertices = vertices;
    }
    
    Polygon(int generation, PVector[] vertices) {
      _generation = generation;
      _vertices = vertices;
    }
  
    int generation() {
        return _generation;
    }  
    
    PVector[] vertices() {
        return _vertices;
    }
}
