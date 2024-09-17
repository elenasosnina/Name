# Используйте образ с JDK и Android SDK
FROM openjdk:8-jdk


# Установите необходимые зависимости
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Установите Android SDK
RUN mkdir -p /opt/android-sdk && cd /opt/android-sdk && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip sdk-tools-linux-3859397.zip && \
    rm sdk-tools-linux-3859397.zip

# Установите необходимые компоненты SDK
RUN yes | /opt/android-sdk/tools/bin/sdkmanager --sdk_root=/opt/android-sdk --licenses
RUN /opt/android-sdk/tools/bin/sdkmanager --update
RUN /opt/android-sdk/tools/bin/sdkmanager "platform-tools" "platforms;android-30"

# Установите рабочую директорию
WORKDIR /app

# Копируйте проект в контейнер
COPY . .

# Соберите приложение
RUN ./gradlew build

# Укажите команду для запуска (если необходимо)
CMD ["./gradlew", "assembleDebug"]
