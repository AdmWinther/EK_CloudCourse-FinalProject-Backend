
package ek_cloud_course.backend.ControllersTest.HealthCheckTest;

import ek_cloud_course.backend.Controllers.HealhCheck.HealthCheck;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

@WebMvcTest(HealthCheck.class)
public class HealthCheckTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void testHealthCheck() throws Exception {
        mockMvc.perform(get("/healthcheck"))
                .andExpect(status().isOk());
    }
}