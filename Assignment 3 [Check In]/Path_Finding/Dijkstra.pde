
int min_dist(IntList Q, FloatList dist) {
  int   pos = 0;
  float min = 1000;

  for (int q = 0; q < Q.size(); q++) {
    if (Q.get(q) == 0) {
      if ( dist.get(q) < min ) {
        min = dist.get(q);
        pos = q;
      }
    }
  }
  // dist
  return pos;
}


IntList vertex_neighbor(int v, IntList Q) {
  IntList list = new IntList();
  for (Path p : paths) {
    if (p.start_pos == v) {
      list.append(p.end_pos);
    }
  }

  int pos = 0;
  for (int l : list) {
    if (Q.get(l) == 1) {
      list.remove(pos);
    }
    else {
      pos += 1;
    }
  }

  return list;
}


void findRealPath(IntList parent_list) {
  int num = number_of_points - 1;

  while ( num != 0 ) {
    Point b = points.get(num);
    Point a = points.get(parent_list.get(num));

    realpath.add(new Path(a, b));

    num = parent_list.get(num);
  }
}


void Dijkstra() {
// start 0
// end 29
  FloatList dist   = new FloatList();      // distance measure
  IntList   Q      = new IntList();        // vertex point (0, 1)
  IntList   parent = new IntList();        // parent position

  // initialization
  for (int i = 0; i < number_of_points; i ++ ) {
    Q.append(0);
    parent.append(-1);
    if (i == 0) dist.append(0.0);
    else dist.append(1000.0);
  }


  for (int i = 0; i < number_of_points; i ++) {
    int u = min_dist(Q, dist);
    Q.set(u, 1);        // set as visited

    for ( int v : vertex_neighbor(u, Q) ) {
      float alt = dist.get(u) + dist(points.get(u), points.get(v));
      if ( Q.get(v) == 0 && alt < dist.get(v)) {
        parent.set(v, u);
        dist.set(v, alt);
      }
    }
  }

  findRealPath(parent);

  print("dist: ");
  println(dist.size());
  print("Q   : ");
  println(Q.size());
  print("pare: ");
  println(parent.size());
  //for (int i = realpath.size()-1; i >= 0; i--) {
  //  realpath.get(i).print();
  //  println("-----------------------------", realpath.size(), "-----");
  //}

}
