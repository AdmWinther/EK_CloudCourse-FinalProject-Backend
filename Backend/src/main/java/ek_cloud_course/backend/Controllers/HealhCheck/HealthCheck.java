package ek_cloud_course.backend.Controllers.HealhCheck;

import ek_cloud_course.backend.Toolbox.HttpRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.http.HttpResponse;

@RestController
@RequestMapping("healthcheck")
public class HealthCheck {

    @Value("${domain}")
    private String domain;

    @GetMapping("")
    public String healthCheck() {
        //Send a Simple Get request to check if the server is running
        String url = domain + "healthcheck";
        System.out.println("Healthcheck called, sending request to: " + url);
        ResponseEntity<String> response = HttpRequest.Get(url);
        System.out.println("status Code" + response.getStatusCode());
        System.out.println("Response Body: " + response.getBody());
        if(response.getStatusCode().is2xxSuccessful()) {
            return "Server is running.";
        } else {
            return "Server is not running.";
        }
    }
}
