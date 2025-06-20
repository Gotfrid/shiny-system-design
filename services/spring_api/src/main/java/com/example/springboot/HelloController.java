package com.example.springboot;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

	@GetMapping("/hello")
	public ResponseEntity<String> index() {
		return ResponseEntity
			.ok()
			.contentType(MediaType.APPLICATION_JSON)
			.body("\"Spring Boot (Java) says hi!\"");
	}

}
