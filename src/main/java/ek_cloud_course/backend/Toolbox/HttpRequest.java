package ek_cloud_course.backend.Toolbox;


import ek_cloud_course.backend.Models.RequestBodies.IRequestBody;
import ek_cloud_course.backend.Models.RequestBodies.NewUserRequestBodyToMailServer;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

import java.net.http.HttpResponse;
import java.util.HashMap;

public class HttpRequest {
    public static ResponseEntity<String> Get(String url) {
        RestTemplate restTemplate = new RestTemplate();

        // Send GET request and read response as a String
        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

        // Print the response body
        System.out.println("Response: " + response.getBody());
        return response;
    }

    public static ResponseEntity<String> put(String url, IRequestBody requestBody) {

//        System.out.println("Password in request body: " + body.get("password"));

        RestTemplate restTemplate = new RestTemplate();

//        NewUserRequestBodyToMailServer requestBody = new NewUserRequestBodyToMailServer();
//        requestBody.password = body.get("password");

        // Create HttpEntity with headers and body
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<IRequestBody> entity = new HttpEntity<>(requestBody, headers);

        // Send PUT request and read response code

        System.out.println("before sending PUT request to: " + url);
        ResponseEntity<String> response = restTemplate.exchange(
                url,
                HttpMethod.PUT,
                entity,
                String.class
        );
        System.out.println("after sending PUT request to: " + url);

        System.out.println("Response: " + response.getBody());

        // Print the response body
        System.out.println("Response: " + response.getBody());
        return response;
    }
}