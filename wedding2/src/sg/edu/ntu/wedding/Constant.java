package sg.edu.ntu.wedding;

public class Constant {
    public class Session {
        public static final String activeWedding = "activeWedding";
        public static final String guestTableQry = "SELECT * FROM IP_GUEST WHERE WEDDINGID=?";
        public static final String guestTableQry2 = "SELECT * FROM IP_GUEST WHERE ID=?";
        public static final String weddingTableQryAll = "SELECT * FROM IP_WEDDING";
        public static final String guestTableSqs = "Guest Title, Invited By, Table ID, Guest Number, Vegetarians, Muslims";
    }
}
