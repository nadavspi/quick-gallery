default: build start
build: 
  bash generate.sh
start:
  npx http-server dist


