package ek_cloud_course.backend.Controllers.Users;

import ek_cloud_course.backend.Models.RequestBodies.NewUserRequestBodyFromFrontend;
import ek_cloud_course.backend.Models.RequestBodies.NewUserRequestBodyToMailServer;
import ek_cloud_course.backend.Toolbox.HttpRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@RestController
@RequestMapping("users")
public class Users {
    @Value("${ServerAddress}")
    private String ServerAddress;

    //Get a list of all users
    @GetMapping("")
    public String getAllUsers() {
        String url = ServerAddress + "users";
        System.out.println("Get all users is called, sending request to: " + url);
        ResponseEntity<String> response = HttpRequest.Get(url);
        System.out.println("status Code" + response.getStatusCode());
        System.out.println("Response Body: " + response.getBody());
        if(response.getStatusCode().is2xxSuccessful()) {
            return response.getBody();
        } else {
            throw new RuntimeException("Failed to get users from " + url);
        }
    }

    @PostMapping("newUser")
    public String PostNewDomains(@RequestBody NewUserRequestBodyFromFrontend requestBodyFromFront) {
        System.out.println("New user Request Body: " + requestBodyFromFront.username);
        String url = ServerAddress + "users/" + requestBodyFromFront.username;
        System.out.println("Add a new user, sending request to: " + url);

        NewUserRequestBodyToMailServer requestBodyToServer = new NewUserRequestBodyToMailServer();
        requestBodyToServer.password = requestBodyFromFront.password;

        ResponseEntity<String> response = HttpRequest.put(url, requestBodyToServer);
        System.out.println("status Code" + response.getStatusCode());
        System.out.println("Response Body: " + response.getBody());
        if(response.getStatusCode().is2xxSuccessful()) {
            return "new user "+ requestBodyFromFront.username +" is created";
        } else {
            throw new RuntimeException("Failed to make a new user " + url);
        }
    }
}
