
ArrayList <Path> dijkstra_path = new ArrayList<Path>();
ArrayList <Path> A_path = new ArrayList<Path>();


boolean visited(boolean[] visit) {
  for (int i = 0; i < total_points; i ++) {
    if (visit[i] == false) return false;
  }
  return true;
}


int minDistance(float dist[], boolean Q[]) {
    // Initialize min value
    float min = 100000.0;
    int min_index = 0;


    for (int i = 0; i < total_points; i++) {
      if (Q[i] == false && dist[i] <= min) {
        min = dist[i];
        min_index = i;
      }
    }

    return min_index;
}

IntList neighbor(int u, boolean[] Q) {
  IntList list = new IntList();
  for (Path p : paths) {
    if (p.start == u) {
      list.append(p.end);
    }
    if (p.end == u) {
      list.append(p.start);
    }
  }

  int count = 0;
  for (int i : list) {
    if (Q[i]) {
      list.remove(count);
    } else {
      count += 1;
    }
  }

  return list;
}

void find_real_path(int[] parent, int source, int destination) {
  while ( destination != source && parent[destination] != -1) {
    Point b = points[destination];
    Point a = points[parent[destination]];

    realpath.add(new Path(a, b));

    destination = parent[destination];
  }
}


void Dijkstra(){
  // path --> Graph
  // point -> Vertex
  temp__time = millis();
  float[] dist = new float[total_points];
  boolean[] Q  = new boolean[total_points];
  int[] parent = new int[total_points];
  int source = 0;

  for (int i = 0; i < total_points; i ++) {
    if (i == source) dist[source] = 0.0;
    else             dist[i]      = 100000.0;
    parent[i] = -1;
    Q[i] = false;
  }

  for (int j = 0; j < total_points; j ++) {

    int u = minDistance(dist, Q);
    Q[u]  = true;

    for (int v : neighbor(u, Q)) {
      float alt = dist[u] + points[u].distance(points[v]);
      if ( Q[v] == false && alt < dist[v]) {
        // path!
        Path path = new Path(points[u], points[v]);
        dijkstra_path.add(path);

        parent[v] = u;
        dist[v] = alt;
      }
    }
  }

  if (isValid()) {
    find_real_path(parent, 0, 1);
  }

  total_time = millis() - temp__time;
  IS_PRM = true;    // trigger
}


//============================================================


void A_ () {

  temp__time = millis();
  float[] dist = new float[total_points];
  boolean[] Q  = new boolean[total_points];
  int[] parent = new int[total_points];
  int source = 0;
  int destination = 1;

  for (int i = 0; i < total_points; i ++) {
    if (i == source) dist[source] = 0.0;
    else             dist[i]      = 100000.0;
    parent[i] = -1;
    Q[i] = false;
  }

  for (int j = 0; j < total_points; j ++) {
    int u = minDistance(dist, Q);
    Q[u]  = true;

    for (int v : neighbor(u, Q)) {
      float alt = dist[u] + points[u].distance(points[v]) +
                  points[u].distance(points[destination]);
      if ( Q[v] == false && alt < dist[v]) {
        Path path = new Path(points[u], points[v]);
        A_path.add(path);
        parent[v] = u;
        dist[v] = alt;
      }
    }
  }

  if (isValid()) {
    find_real_path(parent, 0, 1);
  }

  total_time = millis() - temp__time;
  IS_PRM = true;    // trigger
}
