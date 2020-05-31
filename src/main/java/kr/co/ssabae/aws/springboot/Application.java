package kr.co.ssabae.aws.springboot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        // 내장 WAS를 실행 Embedded Tomcat
        SpringApplication.run(Application.class, args);
    }
}
