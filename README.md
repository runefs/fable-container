# fable-container

A docker container for fable applications.

You will need to buikld an image based on. The installation of node and dotnet dependencies will happen at build time and the build context needs to be the app root

You will then have to mount the src folder (not the app folder) into /app/src in the container

a docker compose service could look like this

'''
fableApp : 
      build:
        image: Dockerfile
        context: ./fableApp
      volumes:
          - type: bind
            source: ./fableApp/src
            target: /app/src
            read_only: false
      ports: 
        - "8080:8080"
'''