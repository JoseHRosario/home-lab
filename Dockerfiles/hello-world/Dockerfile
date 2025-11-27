# Cloud-optimized Dockerfile for CI/CD builds and registry builds
# Creates a named non-root user with UID:GID1000 so the runtime has an /etc/passwd entry
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
RUN groupadd -g1000 appgroup \
 && useradd -m -u1000 -g appgroup -s /sbin/nologin appuser
WORKDIR /app
EXPOSE 8080
USER appuser

# Build stage: clone the repo from GitHub and build inside the container
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
ARG REPO_URL=https://github.com/JoseHRosario/HelloWorld.git
ARG REPO_REF=master
WORKDIR /src
# install git, clone the repo, and remove apt lists to keep image small
RUN apt-get update \
 && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/*
RUN git clone --depth1 --branch "$REPO_REF" "$REPO_URL" .
RUN dotnet restore "./HelloWorld.csproj"
RUN dotnet build "./HelloWorld.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./HelloWorld.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
# copy published app; ensure files are owned by the numeric UID/GID
COPY --from=publish /app/publish .
USER root
RUN chown -R1000:1000 /app
USER appuser
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
