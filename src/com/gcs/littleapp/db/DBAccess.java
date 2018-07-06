package com.gcs.trinimbus.db;

import javax.servlet.ServletOutputStream;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.*;

import com.gcs.json.JSONException;
import com.gcs.json.JSONObject;

public class DBAccess 
{
	private static String username="trinimbus";
	private static String password="trinimbus";
	private static String schema="simpleKV";
	private static String kvTableName="kv";
	private static String dbHost="roxydb.ceyog3sgzm33.us-east-1.rds.amazonaws.com";
	private static int dbPort=3306;
	private static String jdbcConnect="jdbc:mysql://"+dbHost+":"+dbPort+"/"+schema;
	



	public static void query(JSONObject query, OutputStream os) 
			throws SQLException, JSONException 
	{
		//unpack query
		int pkey=query.optInt("pkey");
		String key=query.optString("key");
		String conditionString="pkey="+pkey + " AND kee='"+key+"'";
		if (pkey>0)
		{ // if key not specified then drop from conditional
			conditionString=conditionString.split("AND")[0];
		}
		else
		{
			conditionString=conditionString.split("AND")[1];
		}
		
		String queryString = "SELECT * from " + schema + "." + kvTableName + " WHERE " + conditionString;
		
		Connection conn = DriverManager.getConnection(jdbcConnect, username, password);
		// construct SQL query form query object
		Statement q = conn.createStatement();
		
		System.out.println("trying this statement: " + queryString);
		q.executeQuery(queryString);
		
		ResultSet res = q.getResultSet();
		
		streamResultSet(res, os);
		
	}
	
	private static void streamResultSet(ResultSet res, OutputStream os) 
			throws JSONException, SQLException
	{
		if (!res.next()) return;
		// lets just return the value
		JSONObject resp = new JSONObject();
		resp.put("value", res.getString("value"));
		Writer writer = new OutputStreamWriter(os);
		try 
		{
			resp.write(writer);
			writer.flush();		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally
		{
			try {
				writer.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	static
	{
//TODO pull db access config from common source
		 try {
			Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
