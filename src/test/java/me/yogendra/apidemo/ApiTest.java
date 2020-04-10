package me.yogendra.apidemo;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;

@SpringBootTest(webEnvironment = RANDOM_PORT)
public class ApiTest {

  @LocalServerPort
  private int port;


  @Autowired
  private TestRestTemplate restTemplate;

  @Test
  public void greetingShouldReturnDefaultMessage() {
    String url = String.format("http://localhost:%d/", port);
    String expected = "Hello, World!";
    String output = restTemplate.getForObject(url, String.class);
    assertThat(output).contains(expected);

  }
}
