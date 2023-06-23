ARG SDK_TAG="7.0-alpine"

FROM mcr.microsoft.com/dotnet/sdk:${SDK_TAG} as base

FROM mcr.microsoft.com/dotnet/sdk:${SDK_TAG} as build

ARG BUILD_CONFIG="Release"
ARG DOTNET_RUNTIME="linux-musl-x64"
ARG RANDOM_PROPERTY="false"
ENV API_FOLDER="/src/Api"
ENV TEST_FOLDER="/test/Api.Tests"

WORKDIR /src

# Copy csproj and packages lock json
COPY [ "${API_FOLDER}/*.csproj",  "${API_FOLDER}/packages.lock.json", "${API_FOLDER}/" ]
COPY [ "${TEST_FOLDER}/*.csproj",  "${TEST_FOLDER}/packages.lock.json", "${TEST_FOLDER}/" ]

WORKDIR "/src/${TEST_FOLDER}"

# Dotnet restore cachable
RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    --mount=type=secret,id=nugetconfig \
    dotnet restore \
    -r ${DOTNET_RUNTIME} \
    --locked-mode \
    -p:ReadyToPublish=true \
    -p:RandomProperty=${RANDOM_PROPERTY} \
    --configfile /run/secrets/nuget.config

WORKDIR /src

# copy source code
COPY [ "${API_FOLDER}", "${API_FOLDER}" ]
COPY [ "${TEST_FOLDER}", "${TEST_FOLDER}" ]

WORKDIR "/src/${TEST_FOLDER}"

# publish
RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    dotnet publish \
    -c ${BUILD_CONFIG} \
    -r ${DOTNET_RUNTIME} \
    --no-restore \
    -p:ReadyToPublish=true \
    -p:RandomProperty=${RANDOM_PROPERTY} \
    -o /app/publish

FROM base as final

WORKDIR /app

COPY --from=build /app/publish /app

ENTRYPOINT [ "dotnet", "./Api.Tests" ]

