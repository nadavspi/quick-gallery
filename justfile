default: build start
build: 
  bash generate.sh
start:
  npx http-server dist

deploy:
  npx netlify deploy --dir dist --prod
