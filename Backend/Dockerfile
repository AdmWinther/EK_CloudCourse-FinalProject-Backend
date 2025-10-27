# Use an official OpenJDK image as base
FROM eclipse-temurin:17-jdk

# Set working directory inside container
WORKDIR /app

# Copy the built JAR file into the container
COPY /home/runner/work/EK_CloudCourseProject/EK_CloudCourseProject/Backend/target/backend-0.0.1-SNAPSHOT.jar app.jar

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]

# Expose port 8080
EXPOSE 8080