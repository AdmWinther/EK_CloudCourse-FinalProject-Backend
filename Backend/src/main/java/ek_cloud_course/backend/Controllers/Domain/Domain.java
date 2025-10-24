package ek_cloud_course.backend.Controllers.Domain;

import ek_cloud_course.backend.Models.NewDomainRequestBody.newDomainRequestBody;
import ek_cloud_course.backend.Toolbox.HttpRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.http.HttpResponse;
import java.util.HashMap;

@RestController
@RequestMapping("domains")
public class Domain {

    @Value("${domain}")
    private String domain;

    //Get a list of all domains
    @GetMapping("")
    public String getAllDomains() {
        String url = domain + "domains";
        System.out.println("Get all domains called, sending request to: " + url);
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
    public String PostNewDomains(@RequestBody newDomainRequestBody requestBody) {
        System.out.println("New Domain Request Body: " + requestBody.newDomain);
        String url = domain + "domains/" + requestBody.newDomain;
        System.out.println("Get all domains called, sending request to: " + url);
        HashMap<String, String> headers = new HashMap<>();
        ResponseEntity<String> response = HttpRequest.put(url, headers);
        System.out.println("status Code" + response.getStatusCode());
        System.out.println("Response Body: " + response.getBody());
        if(response.getStatusCode().is2xxSuccessful()) {
            return response.getBody();
        } else {
            throw new RuntimeException("Failed to get domains from " + url);
        }
    }
}
