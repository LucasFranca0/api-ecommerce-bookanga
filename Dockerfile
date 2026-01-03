# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copia pom.xml e baixa dependências (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia código fonte e compila
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Cria usuário não-root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copia JAR da stage de build
COPY --from=build /app/target/*.jar app.jar

# Expõe porta
EXPOSE 8080

# Configuração JVM
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Comando de inicialização
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
