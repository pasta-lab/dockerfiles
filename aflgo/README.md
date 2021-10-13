# Build and push to Docker Hub

```bash
docker build --rm -t realkankan/aflgo -f prereq.llvm11.Dockerfile .
docker push docker.io/realkankan/aflgo:latest
```
