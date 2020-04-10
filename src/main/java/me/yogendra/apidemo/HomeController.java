package me.yogendra.apidemo;

import static org.slf4j.LoggerFactory.getLogger;

import org.slf4j.Logger;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {
  private static final Logger logger = getLogger(HomeController.class);

  @GetMapping("/")
  public String greeting(){
    logger.info("Received a request");
    return "Hello, World!";
  }
}
