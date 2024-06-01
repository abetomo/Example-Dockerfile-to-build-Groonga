# Example-Dockerfile-to-build-Groonga

## Fetch Groonga source

```
git clone --recursive https://github.com/groonga/groonga.git
```

## Build and Test

### Build a Docker image

```
docker image build -t groonga_build .
```

### CMake

```
docker container run -it --rm \
  -v $PWD/groonga:/build \
  -v $PWD/groonga.build:/groonga.build \
  groonga_build \
  cmake -B /groonga.build -S . -DCMAKE_BUILD_TYPE=Debug
```

### Build

```
docker container run -it --rm \
  -v $PWD/groonga:/build \
  -v $PWD/groonga.build:/groonga.build \
  groonga_build \
  cmake --build /groonga.build
```

### Run tests

```
docker container run -it --rm \
  -v $PWD/groonga:/build \
  -v $PWD/groonga.build:/groonga.build \
  --shm-size=4g \
  -e BUILD_DIR=/groonga.build/test/command \
  groonga_build \
  ./test/command/run-test.sh
```

## Build documentation

```
docker image build -t groonga_docs -f ./doc.Dockerfile .
```

### CMake

```
docker container run -it --rm \
  -v $PWD/groonga:/docs \
  -v $PWD/groonga.docs:/groonga.docs \
  groonga_docs \
  cmake -B /groonga.docs -S . --preset=doc
```

### Build

```
docker container run -it --rm \
  -v $PWD/groonga:/docs \
  -v $PWD/groonga.docs:/groonga.docs \
  groonga_docs \
  cmake --build /groonga.docs
```

Generated in `./groonga.docs/doc/{en,ja}/html/`.

### Run `ninja doc_update_examples`

```
docker container run -it --rm \
  -v $PWD/groonga:/docs \
  -v $PWD/groonga.docs:/groonga.docs \
  groonga_docs \
  ninja doc_update_examples -C /groonga.docs
```

Update the run results of the command examples.

## Use gdb in Docker

* `--cap-add=SYS_PTRACE`
  * https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities
* `--security-opt="seccomp=unconfined"`
  * https://docs.docker.com/engine/security/seccomp/
