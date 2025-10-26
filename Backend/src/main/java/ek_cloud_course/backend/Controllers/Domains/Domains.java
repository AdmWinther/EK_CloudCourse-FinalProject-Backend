package ek_cloud_course.backend.Controllers.Domains;

import ek_cloud_course.backend.Models.RequestBodies.NewDomainRequestBody;
import ek_cloud_course.backend.Models.RequestBodies.NewDomainRequestBodyToServer;
import ek_cloud_course.backend.Toolbox.HttpRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@RestController
@RequestMapping("domains")
public class Domains {

    @Value("${ServerAddress}")
    private String ServerAddress;

    //Get a list of all domains
    @GetMapping("")
    public String getAllDomains() {
        String url = ServerAddress + "domains";
        System.out.println("Get all domains is called, sending request to: " + url);
        ResponseEntity<String> response = HttpRequest.Get(url);
        System.out.println("status Code" + response.getStatusCode());
        System.out.println("Response Body: " + response.getBody());
        if(response.getStatusCode().is2xxSuccessful()) {
            return response.getBody();
        } else {
            throw new RuntimeException("Failed to get domains from " + url);
        }
    }

    @PostMapping("newDomain")
    public String PostNewDomains(@RequestBody NewDomainRequestBody requestBody) {
        System.out.println("New Domain Request Body: " + requestBody.newDomain);
        String url = ServerAddress + "domains/" + requestBody.newDomain;
        System.out.println("Registering new domain, sending request to: " + url);

        NewDomainRequestBodyToServer bodyToServer = new NewDomainRequestBodyToServer();
        ResponseEntity<String> response = HttpRequest.put(url, bodyToServer);
        System.out.println("status Code" + response.getStatusCode());
        System.out.println("Response Body: " + response.getBody());
        if(response.getStatusCode().is2xxSuccessful()) {
            return "new domain "+ requestBody.newDomain +" is created";
        } else {
            throw new RuntimeException("Failed to get domains from " + url);
        }
    }
}
