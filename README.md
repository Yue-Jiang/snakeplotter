# snakeplotter

Plots custom 7-transmembrane G protein-coupled receptors with user defined extracellular, intracellular and transmembrane region lengths. User can also define colors and text for residues.  
App at https://yuejiang.shinyapps.io/GPCRsnakeplotter/

## Using docker

If you have docker installed, you don't need `R` or to install any libraries used by this app to run it locally.

### Grabbing the image

You can grab the docker image in either of the two ways:

- Directly obtain the image from dockerhub by running `docker pull yuejiang/snakeplotter`. This should take seconds.
- or build the image locally by cloning this repo `git clone https://github.com/Yue-Jiang/snakeplotter.git`, `cd snakeplotter`, and running `docker build . -f Dockerfile -t yuejiang/snakeplotter:latest`. This takes longer since it's building from scratch. Once it's done, you can confirm the image has been built by running `docker image ls`, which will hopefully give you something like this:

```
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
yuejiang/snakeplotter   latest              413914287a35        42 seconds ago      1.2GB
rocker/shiny            latest              e6cb4ad59fcd        3 months ago        1.18GB
```

### Running the container

After the image is built, you can run it by `docker run -d -p 80:3838 --name c_snakeplotter yuejiang/snakeplotter:latest`. To confirm it's running, key `docker ps -as` and hopefully it gives you something like this:

```
CONTAINER ID        IMAGE                          COMMAND                  CREATED                  STATUS              PORTS                  NAMES               SIZE
e1ea0dcc5772        yuejiang/snakeplotter:latest   "/usr/bin/shiny-serv…"   Less than a second ago   Up 21 seconds       0.0.0.0:80->3838/tcp   c_snakeplotter      0B (virtual 1.2GB)
```

In your browser, go to `localhost/snakeplotter` and the app should be there. Note the path is as such because I specified it in the `Dockerfile` - it has nothing to do with the image or container name in case you wish to rename them. Unless you modify the `COPY` line of `Dockerfile`, this path will not change.

### Cleaning up

To stop the container, key `docker stop c_snakeplotter`. Note `c_snakeplotter` is the container name.

Then remove the container `docker rm c_snakeplotter`.

Then you will be allowed to remove the image `docker image rm yuejiang/snakeplotter`. Note `yuejiang/snakeplotter` is the image name.


