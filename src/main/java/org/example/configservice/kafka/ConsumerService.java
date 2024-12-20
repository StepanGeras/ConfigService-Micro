package org.example.configservice.kafka;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class ConsumerService {

    @KafkaListener(topics = "my-topic", groupId = "my-group")
    public void receiveMessage(String message) {
        System.out.println("Received message: " + message);
    }

}
