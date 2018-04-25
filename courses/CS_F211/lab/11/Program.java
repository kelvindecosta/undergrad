import java.util.*;

class Graph {
    int weightMatrix[][];
    String vertices;

    Graph(String vertices) {
        int l = vertices.length();
        this.weightMatrix = new int[l][l];

        this.vertices = vertices;
    }

    void insertEdge(char v1, char v2, int weight) {
        int p1 = vertices.indexOf(v1);
        int p2 = vertices.indexOf(v2);

        weightMatrix[p1][p2] = weightMatrix[p2][p1] = weight;
    }

    void calculateDijkstra(char node) {
        DijkstraMap map = new DijkstraMap(this, node);
        map.calculate();
        map.printTable();
        map.printPaths();
    }
}

class DijkstraMap {
    class Dijkstra {
        Integer distance;
        Character previous;
        boolean known;

        Dijkstra(Integer d, Character v, boolean k) {
            distance = d;
            previous = v;
            known = k;
        }
    }

    Graph g;
    char n;
    HashMap<Character, Dijkstra> map;

    DijkstraMap(Graph g, char n) {
        this.g = g;
        this.n = n;
        map = new HashMap<Character, Dijkstra>();
        generateMap();
    }

    void generateMap() {
        char vertices[] = g.vertices.toCharArray();
        for (char v : vertices) {
            if (n == v)
                map.put(v, new Dijkstra(0, null, false));
            else
                map.put(v, new Dijkstra(null, null, false));
        }
    }

    boolean checkMap() {
        char vertices[] = g.vertices.toCharArray();
        for (int i = 0; i < vertices.length; i++)
            if (!map.get(vertices[i]).known)
                return false;
        return true;
    }

    Character getMinimalNode() {
        char vertices[] = g.vertices.toCharArray();
        Character c = new Character('0');
        int d = 0;
        for (int i = 0; i < vertices.length; i++)
            if (!map.get(vertices[i]).known && map.get(vertices[i]).distance != null) {
                c = vertices[i];
                d = map.get(vertices[i]).distance;
                break;
            }

        for (int i = 0; i < vertices.length; i++)
            if (!map.get(vertices[i]).known && map.get(vertices[i]).distance != null)
                if (map.get(vertices[i]).distance < d) {
                    c = vertices[i];
                    d = map.get(vertices[i]).distance;
                }

        return c;
    }

    void updateMap(char current) {
        int pos = g.vertices.indexOf(current);
        char vertices[] = g.vertices.toCharArray();
        Dijkstra v1 = map.get(current);
        v1.known = true;

        for (int i = 0; i < vertices.length; i++) {
            char u = g.vertices.charAt(i);
            int w = g.weightMatrix[pos][i];
            if (w > 0) {
                Dijkstra v2 = map.get(u);
                if (v2.known)
                    continue;

                int newD = v1.distance + w;
                if (v2.distance == null || newD < v2.distance) {
                    v2.previous = current;
                    v2.distance = newD;
                }

            }
        }
    }

    void calculate() {
        while (true) {
            if (checkMap())
                break;
            char current = getMinimalNode();
            updateMap(current);
        }
    }

    void printTable() {
        System.out.println("Dijkstra Computation Table");
        for (char c : g.vertices.toCharArray())
            System.out.println("[" + c + "] : " + map.get(c).distance + " : " + map.get(c).previous);
        System.out.println();
    }

    void printPaths() {
        System.out.println("Dijkstra Computed Paths");
        for (char c : g.vertices.toCharArray())
            if (c == n)
                continue;
            else
                System.out.println(getPath(c, "" + c));
    }

    String getPath(char c, String s) {
        if (c == n)
            return s;
        else
            return getPath(map.get(c).previous, map.get(c).previous + " -> " + s);
    }
}

class Program {
    public static void main(String args[]) {
        Graph graph = new Graph("uvwxyz");
        graph.insertEdge('u', 'v', 2);
        graph.insertEdge('u', 'w', 5);
        graph.insertEdge('u', 'x', 1);
        graph.insertEdge('v', 'x', 2);
        graph.insertEdge('v', 'w', 3);
        graph.insertEdge('x', 'w', 3);
        graph.insertEdge('x', 'y', 1);
        graph.insertEdge('w', 'y', 1);
        graph.insertEdge('w', 'z', 5);
        graph.insertEdge('y', 'z', 2);

        graph.calculateDijkstra('u');
    }
}
