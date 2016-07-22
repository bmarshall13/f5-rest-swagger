OpenAPI description of BigIP REST API, and tooling to generate libraries

This is a work in progress, and is not ready for production.

The OpenAPI spec has been auto-generated, and
contains many known and unknown errors.


# Generating a library (e.g. go)
Generate an SDK using swagger-codegen.

Currently go has been lightly tested.

## Prerequisites
 - docker (I'm using the docker for mac beta)
 - PyYaml
 - A swagger-codegen docker image that can run generate
   ```
   git clone https://github.com/swagger-api/swagger-codegen.git
   cd swagger-codegen
   docker build -t swagger-codegen .
   ```
   NOTE: https://github.com/swagger-api/swagger-codegen/issues/3242 may prevent
   use of the templates provide in this repo


## Generate
1. Generate go sdk:
```
make
```

2. Commit changes:
```
cd build/go-bigip-rest
git commit
```

