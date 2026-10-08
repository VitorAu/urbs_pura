# BASE
FROM dart:stable AS base
WORKDIR /app/
COPY pubspec.* ./
RUN dart pub get

# DEVELOPMENT
FROM base AS development
COPY . .
CMD [ "dart", "run", "bin/main.dart" ]

# BUILD
FROM base AS build
COPY . .
RUN dart pub get --ofline
RUN dart compile exe bin/main.dart -o bin/main

# PRODUCTION
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/main /app/bin/main
CMD ["/app/bin/main"]

