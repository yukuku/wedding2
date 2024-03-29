package sg.edu.ntu.wedding;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DatabaseConnection {
    private Connection connection;
    private static DatabaseConnection instance;
    
    private String host = "localhost";
    private int port = 40006;
    private String dbname = "wedding";
    private String user = "root";
    private String password = "";
    
    public DatabaseConnection() { 
        try {
            connection = connect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public ResultSet select(String sql, Object... params) {
        checkConnection();
        try {
            PreparedStatement s = connection.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                s.setObject(i+1, params[i]);
            }
            return s.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public int fetchInt(String sql, Object... params) {
        checkConnection();
        try {
            ResultSet rs = select(sql, params);
            if (rs.next()) {
            	return rs.getInt(1);
            } else {
            	return 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    public String fetchStr(String sql, Object... params){
    	checkConnection();
        try {
            ResultSet rs = select(sql, params);
            if (rs.next()) {
            	return rs.getString(1);
            } else {
            	return "error";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "error";
        }
    }

    public boolean execute(String sql, Object... params) {
        checkConnection();
        try {
            PreparedStatement s = connection.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                s.setObject(i+1, params[i]);
            }
            return s.execute();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Guest g){
    	checkConnection();
        try {
        	java.sql.Statement st = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
        	String sql = "SELECT * FROM IP_GUEST WHERE ID = " + g.getId();
            ResultSet rs = st.executeQuery(sql);
            if(rs.next()){            	
                rs.updateString("NAME", g.getName());
                rs.updateString("CATEGORY", g.getCategory());
                rs.updateString("INVITEDBY",g.getInvitedBy());
                rs.updateInt("GUESTTOTAL",g.getGuestTotal());
                rs.updateInt("GUESTMUS",g.getGuestMus());
                rs.updateInt("GUESTVEG",g.getGuestVeg());
                rs.updateRow();
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }  
    }

    public boolean delete(Wedding w, Guest g){
    	checkConnection();
        try {
        	java.sql.Statement st = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
        	Assignment.unassign(this, w, g);
           	String sqlGuest = "DELETE FROM IP_GUEST WHERE ID = " + g.getId();
            st.execute(sqlGuest);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }  
    }

    public int insert(String sql, Object... params) {
        checkConnection();
        try {
            PreparedStatement s = connection.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                s.setObject(i+1, params[i]);
            }
            
            s.execute();
            
            ResultSet keys = s.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            } else {
                return 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }
    
    private Connection connect() {
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String connString = "jdbc:mysql://" + host + ":" + port + "/" + dbname + "?" + "user=" + user + "&password=" + password + "&autoReconnect=true";
            return DriverManager.getConnection(connString);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } 
    }
    
    private void checkConnection() {
        try {
            connection.createStatement().execute("select 1");
        } catch (Exception e) {
            e.printStackTrace();
            connection = connect();
        }
    }
}
