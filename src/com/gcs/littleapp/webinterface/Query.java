package com.gcs.trinimbus.webinterface;

import java.io.DataOutputStream;
import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gcs.json.JSONException;
import com.gcs.json.JSONObject;
import com.gcs.json.JSONTokener;
import com.gcs.trinimbus.db.DBAccess;

/**
 * Servlet implementation class Query
 */
@WebServlet(
		description = "Servlet for querying the simpleKV table", 
		urlPatterns = { 
				"/Query", 
				"/query"
		}
		)
		
public class Query extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Query() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		/*
		 * The query payload should be json and have a pkey(int) or key(string).  If both values are included, use the key
		 */
		try 
		{
			JSONObject query= new JSONObject(new JSONTokener(request.getInputStream()));
			
			DBAccess.query(query, response.getOutputStream());
		} catch (JSONException e) 
		{
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			DataOutputStream dos = new DataOutputStream(response.getOutputStream());
			dos.writeUTF("Query requires json payload with 'key':string and/or 'pkey':int");
			dos.flush();
			dos.close();
			e.printStackTrace();
		} catch (SQLException sqle) 
		{
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			DataOutputStream dos = new DataOutputStream(response.getOutputStream());
			dos.writeUTF("Some sort of SQL error occured: " + sqle.getMessage());
			dos.flush();
			dos.close();
			sqle.printStackTrace();
		}
		
	}

	private void queryByKey(String key)
	{
		
	}
	private void queryById(int id)
	{
		
	}
}
