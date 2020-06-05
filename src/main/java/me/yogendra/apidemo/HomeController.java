package me.yogendra.apidemo;

import static org.slf4j.LoggerFactory.getLogger;

import java.util.Random;
import java.util.stream.IntStream;

import org.slf4j.Logger;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
public class HomeController {
  private static final Logger logger = getLogger(HomeController.class);

  @GetMapping("/")
  public String greeting() {
    logger.info("Received a request");
    return "Hello, World!";
  }

  @GetMapping("/long")
  public String longRequestTest() {
    Random random = new Random();
    IntStream.range(0, 1000000).forEach((x) -> {
      random.nextInt();
    });
    return "Long Request Done!";
  }

  @GetMapping("/memory")
  public String memoryTest() {
    IntStream.range(0, 10000).forEach((x) -> {
      new Random().nextInt(10000);
    });
    return "Memory Request Done!";
  }

  @GetMapping(value = "/gc")
  public String gc(@RequestParam String param) {
    System.gc();
    return "gc done!";
  }

}
