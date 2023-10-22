FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /source

# Copy and restore as distinct layer
COPY sample-app/. .
RUN dotnet restore

# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /source
COPY --from=build-env /source/out .
ENTRYPOINT ["dotnet", "sample-app.dll"]
