//A easly extendable bunch of subdivision methods

class Subdivider {
  
    //An abstract inner class to be extended by the different subdivision methods
    abstract class Divider {
      
        //The abstract method responsible for the particular kind of subdivision
        abstract PVector[][] division(PVector[] v); 
      
        //Subdivide all queue elements
        void division(LinkedList<PVector[]> pols) 
        {
            PVector[][] nu;
            int S = pols.size();
            for (int i = 0; i < S; i++) {
                nu = division(pols.poll());
                int L = nu.length;
                for (int j = 0; j < L; j++) pols.offer(nu[j]);          
            }
        }
    } 
    
    /*
      Subdivision methods, represented by objects of anonymous classes extending the abstract class Divider
    */
    
    //Joing all vertices to the center of the polygon
    //Returns L triangles
    Divider SPARSE_BARYCENTRIC = new Divider()
    {
        PVector[][] division(PVector[] v) { 
            int L = v.length; 
            PVector[][] nu = new PVector[L][];
            PVector c = Polygon.center(v);
            for (int i = 0, j = 1; i < L; i++, j = (j+1)%L)  
                nu[i] = new PVector[] {new PVector(v[i].x, v[i].y), new PVector(v[j].x, v[j].y), new PVector(c.x, c.y)};
            return nu; 
        }
    };
    
    //Subdivide creating a smaller rotated version of the original polygon
    //Returns L triangles and a central polygon of same number of vertices as the original one
    Divider MIRRORED = new Divider()
    {
        PVector[][] division(PVector[] v) {      
            int L = v.length; 
            PVector[][] nu = new PVector[L+1][];
            //Create polygon at the center
            nu[L] = new PVector[L];
            for (int i = 0, j = 1; i < L; i++, j = (i+1) % L) 
                nu[L][i] = new PVector((v[i].x+v[j].x)*.5, (v[i].y+v[j].y)*.5);
            //Create the other polygons
            for (int i = 0, j = L-1; i < L; i++, j = (j+1) % L) 
                nu[i] = new PVector[] {new PVector(v[i].x, v[i].y), new PVector(nu[L][i].x, nu[L][i].y), new PVector(nu[L][j].x, nu[L][j].y)};
            return nu;
       }    
    };
    
    //Joing all side middle points and vertices to the center of the polygon
    //Returns L*2 triangles
    Divider DENSE_BARYCENTRIC = new Divider()
    {
        PVector[][] division(PVector[] v) {    
            int l = v.length; 
            PVector[][] nu = new PVector[l*2][];
            PVector c = Polygon.center(v);
            float mx, my;
            for (int i = 0, j = 1, I = 0; i < l; i++, j = (j+1) % l, I = i*2)
            {
                mx = (v[i].x+v[j].x)*.5;
                my = (v[i].y+v[j].y)*.5;
                nu[I]   = new PVector[] {new PVector(v[i].x, v[i].y), new PVector(mx, my), new PVector(c.x, c.y)};
                nu[I+1] = new PVector[] {new PVector(v[j].x, v[j].y), new PVector(mx, my), new PVector(c.x, c.y)};
            }
            return nu;
        }
    };
    
    //Create stars joining althernate vertices
    //Returns L*2 triangles and a central polygon of same number of vertices as the original one
    Divider STARRED = new Divider()
    {
        PVector[][] division(PVector[] v) {
            int l = v.length;
            
            //Cannot apply to triangles or squares
            if (l<5) return new PVector[][] {v};
            
            PVector[][] nu; 
            int l2 = l*2; 
            nu = new PVector[l2+1][];
            //Create polygon at the center
            nu[l2] = new PVector[l];
            for (int i = 0, a1 = l-1, a2 = 1, b = 2; i < l; i++, a1 = (a1+1) % l, a2 = (a2+1) % l, b = (b+1) % l)        
                nu[l2][i] = LineIntersector.simpleIntersect(v[a1].x, v[a1].y, v[a2].x, v[a2].y, v[i].x, v[i].y, v[b].x, v[b].y);
            //Create the other polygons
            for (int i = 0, j = l - 1, I = 0, k = 1; i < l; i++, I+=2, j = (j+1)%l, k = (k+1)%l) { 
                nu[I]   = new PVector[] {new PVector(v[i].x, v[i].y), new PVector(nu[l2][i].x, nu[l2][i].y), new PVector(nu[l2][j].x, nu[l2][j].y)};
                nu[I+1] = new PVector[] {new PVector(v[i].x, v[i].y), new PVector(nu[l2][i].x, nu[l2][i].y), new PVector(v[k].x, v[k].y)}; 
            }
            return nu;
        }
    };
     
    //Applies a generalization of Alan Sutcliffe's penthagons subdivision method as pointed out by Matt Pearson
    //Returns L penthagons and a central polygon of same number of vertices as the original one 
    Divider SUTCLIFFE = new Divider()
    {
        PVector[][] division(PVector[] v)
        { 
            int L = v.length; 
            
            //Cannot apply to triangles or squares
            if (L<5) return new PVector[][] {v};
            
            PVector[][] nu = new PVector[L+1][];
            //Create polygon at the center
            nu[L] = new PVector[L];
            for (int i = 0, j = 1, k = 2, l = L-1; i < L; i++, j = (j+1)%L, k = (k+1)%L, l = (l+1)%L) 
                nu[L][i] = LineIntersector.simpleIntersect(v[i].x, v[i].y, v[k].x, v[k].y, v[j].x, v[j].y, v[l].x, v[l].y);    
            //Create the other polygons
            for (int i = 0, j = L-1, k = 1; i < L; i++, j = (j+1) % L, k = (k+1) % L) {
                nu[i] = new PVector[] { new PVector(v[i].x, v[i].y), new PVector((v[i].x + v[k].x)*.5, (v[i].y + v[k].y)*.5), 
                                        new PVector(nu[L][i].x, nu[L][i].y), new PVector(nu[L][j].x, nu[L][j].y), 
                                        new PVector((v[i].x + v[j].x)*.5, (v[i].y + v[j].y)*.5) };   
            }
            return nu;
        }
    };
}
