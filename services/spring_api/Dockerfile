FROM openjdk:17

WORKDIR /app

COPY . .

RUN chmod +x ./mvnw

RUN ./mvnw clean install -DskipTests

CMD ["./mvnw", "spring-boot:run"]
