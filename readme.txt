To use this dockerfile, you must pass in the environment variable directory_name. 
Here is a docker-compose.yml example: 

services:
  parking:
    image: regentcollege/parking
    environment:
      - directory_name=parking
    ports: 
       - '80:80'
    volumes:
      - /var/www/parking:/var/www/parking
