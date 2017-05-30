package verizon.kafka.connect.rest.KafkaConnectRest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.glassfish.jersey.client.ClientConfig;
import org.glassfish.jersey.filter.LoggingFilter;
import org.json.JSONObject;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;


public class RestClient {

	
	 static { 
		 HttpsURLConnection.setDefaultHostnameVerifier(new  HostnameVerifier() 
		 		{ public boolean verify(String hostname, SSLSession  session)
		 			{	  if (hostname.equals("192.168.0.3")) return true; return false;
		 			 }
		 		}); 
	 		}
	
	
//	public static void main(String[] args) {
		//callRest();
	//	callRestUrlVoid("http://www.mocky.io/v2/592c0f1a10000062153898d2");	
		
//		System.out.println(getAuthToken("https://192.168.0.3:5000/v3/auth/tokens"));
//	}

	
public String callRestServicewithAuthToken( String authToken,String url1,String url1NodePath,String url1VariableElement,String url2, String url2NodePath, String url2VariableElement ,
		 String url3, String url3NodePath, String url3VariableElement ,  String url4, String url4NodePath, String url4VariableElement, String url5, String url5NodePath, 
		 String url5VariableElement, String url6, String url6NodePath, String url6VariableElement ){
	//System.out.println("inside callRestServicewithAuthToken ");

	String authenticationToken=getAuthToken(authToken);
	
	Client client = ClientBuilder.newClient(new ClientConfig().register(LoggingFilter.class));
	WebTarget webTarget = client.target(url1);
    Invocation.Builder invocationBuilder =  webTarget.request(
			MediaType.APPLICATION_JSON).header("X-Auth-Token", authenticationToken);
	Response response = invocationBuilder.get();
    
    
	try {
		ObjectMapper mapper = new ObjectMapper();
		JsonNode root = mapper.readTree(InputSteramtoString(response.readEntity(InputStream.class)));
	
		if (url1NodePath==null || url1NodePath.isEmpty() ||url1NodePath.length()<2 ) 
			return root.toString();
		
		JsonNode servers = root.path(url1NodePath);	
		for (JsonNode node : servers) {
			String varElement = node.path(url1VariableElement).asText();			
			
			if(url2NodePath==null || url2NodePath.isEmpty() ||url2NodePath.length()<2 )
			return makeanothercall(url2.replace(url1VariableElement, varElement),authenticationToken ).toString();
			
			else {
				JsonNode root2 = makeanothercall(url2.replace(url1VariableElement, varElement),authenticationToken );
				if (url3NodePath==null || url3NodePath.isEmpty() ||url3NodePath.length()<2 ) 
					return root2.toString();
				
				else{
					
					JsonNode servers2 = root.path(url2NodePath);
					
					for (JsonNode node2 : servers2) {
						String varElement2 = node.path(url2VariableElement).asText();
						if(url3NodePath==null || url3NodePath.isEmpty() ||url3NodePath.length()<2 )
							return makeanothercall(url2.replace(url2VariableElement, varElement),authenticationToken ).toString();
						
					}
				}
				
			}
			
		}
		
	} catch (JsonParseException e) {
		
		e.printStackTrace();
	} catch (JsonMappingException e) {
		
		e.printStackTrace();
	} catch (IOException e) {
		
		e.printStackTrace();
	}
     
return null;
}



private JsonNode makeanothercall(String replace, String authenticationToken) {
	

	try {

	Client client = ClientBuilder.newClient(new ClientConfig().register(LoggingFilter.class));
	WebTarget webTarget = client.target(replace);
    Invocation.Builder invocationBuilder =  webTarget.request(MediaType.APPLICATION_JSON).header("X-Auth-Token", authenticationToken);
	Response response = invocationBuilder.get();
 
	ObjectMapper mapper = new ObjectMapper();
	JsonNode root = mapper.readTree(InputSteramtoString(response.readEntity(InputStream.class)));
	
	return root;	
		
		
	} catch (JsonParseException e) {		
		e.printStackTrace();
	} catch (JsonMappingException e) {		
		e.printStackTrace();
	} catch (IOException e) {		
		e.printStackTrace();
	} catch (Exception e) {		
		e.printStackTrace();
	}
	return null;
     
	
}


private static String getAuthToken(String authToken) {
	
Client client = ClientBuilder.newClient(new ClientConfig().register(LoggingFilter.class));
	
	WebTarget webTarget = client.target(authToken);

	Invocation.Builder invocationBuilder = webTarget
			.request(MediaType.APPLICATION_JSON);
		
	String body="{\r\n    \"auth\": {\r\n        \"identity\": {\r\n            \"methods\": [\r\n                \"password\"\r\n            ],\r\n            \"password\": {\r\n                \"user\": {\r\n                    \"id\": \"3abd1c4b579e4a019afa0dc6e64c4a62\",\r\n                    \"password\": \"sdnadminos@123\"\r\n                }\r\n            }\r\n        },\r\n        \"scope\": {\r\n            \"project\": {\r\n                \"id\": \"1f9f615c8d784dbba027f6d73262064a\"\r\n            }\r\n        }\r\n    }\r\n}";
	JSONObject jsonObj = new JSONObject(body);
	
	Response response = invocationBuilder.post(Entity.json(body));
	
	String token =response.getHeaderString("X-Subject-Token");
	System.out.println(token);
	
	
	return token;
}


public String callRestService( String url1,String url1NodePath,String url1VariableElement,String url2, String url2NodePath, String url2VariableElement ,
		 String url3, String url3NodePath, String url3VariableElement ,  String url4, String url4NodePath, String url4VariableElement, String url5, String url5NodePath, 
		 String url5VariableElement, String url6, String url6NodePath, String url6VariableElement ){
	


	Client client = ClientBuilder.newClient(new ClientConfig().register(LoggingFilter.class));
	
	WebTarget webTarget = client.target("");

	Invocation.Builder invocationBuilder = webTarget
			.request(MediaType.APPLICATION_JSON);
	
	Response response = invocationBuilder.get();

	
	System.out.println(response.getHeaderString("Content-Type"));
	
	System.out.println(response.getHeaders().toString());
	
	ObjectMapper mapper = new ObjectMapper();
	try {
	 
		
		JsonNode root = mapper.readTree(InputSteramtoString(response.readEntity(InputStream.class)));
	
		
		JsonNode servers = root.path("servers");
		
		for (JsonNode node : servers) {
			String type = node.path("status").asText();
			String ref = node.path("hostId").asText();
			System.out.println("type : " + type);
			System.out.println("ref : " + ref);

		}
		
	} catch (JsonParseException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (JsonMappingException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
     
		
	


	
	return "";
}
	

public static String callRest(){
	
	BufferedReader reader = new BufferedReader(new  InputStreamReader(callRestUrl("http://www.mocky.io/v2/592c0f1a10000062153898d2"), StandardCharsets.UTF_8));		  
	 StringBuilder result = new StringBuilder();		  
	 String line;
	 				  
	  try {
	  
	  while ((line = reader.readLine()) != null)
	  		{
		  	result.append(line);
	  			}
	  
	  			System.out.println(result);
	 
	  		} catch (IOException e) {
	  			System.out.println("Exception is " +e);  
	  								}
	return result.toString();
}

public static InputStream callRestUrl(String urltoCall) {

	Client client = ClientBuilder.newClient(new ClientConfig().register(LoggingFilter.class));
	
	WebTarget webTarget = client.target(urltoCall);

	Invocation.Builder invocationBuilder = webTarget
			.request(MediaType.APPLICATION_JSON);
	
	Response response = invocationBuilder.get();

	
	
	return response.readEntity(InputStream.class);

}

public static void callRestUrlVoid(String urltoCall) {

	Client client = ClientBuilder.newClient(new ClientConfig().register(LoggingFilter.class));
	
	WebTarget webTarget = client.target(urltoCall);

	Invocation.Builder invocationBuilder = webTarget
			.request(MediaType.APPLICATION_JSON);
	
	Response response = invocationBuilder.get();

	
	System.out.println(response.getHeaderString("Content-Type"));
	
	System.out.println(response.getHeaders().toString());
	
	ObjectMapper mapper = new ObjectMapper();
	try {
	 
		
		JsonNode root = mapper.readTree(InputSteramtoString(response.readEntity(InputStream.class)));
	
		
		JsonNode servers = root.path("servers");
		
		for (JsonNode node : servers) {
			String type = node.path("status").asText();
			String ref = node.path("hostId").asText();
			System.out.println("type : " + type);
			System.out.println("ref : " + ref);

		}
		
	} catch (JsonParseException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (JsonMappingException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
     
		
	

}


public static String InputSteramtoString(InputStream stream){
	
	BufferedReader reader = new BufferedReader(new  InputStreamReader(stream, StandardCharsets.UTF_8));		  
	 StringBuilder result = new StringBuilder();		  
	 String line;
	 				  
	  try {
	  
	  while ((line = reader.readLine()) != null)
	  		{
		  	result.append(line);
	  			}
	  
	  			System.out.println(result);
	 
	  		} catch (IOException e) {
	  			System.out.println("Exception is " +e);  
	  								}
	return result.toString();
}

}