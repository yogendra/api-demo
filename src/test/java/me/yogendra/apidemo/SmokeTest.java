package me.yogendra.apidemo;


import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class SmokeTest {

    @Autowired
    HomeController homeController;
    @Test
    public void homeControllerShouldBeCreated(){
      assertThat(homeController).isNotNull();
    }
}
