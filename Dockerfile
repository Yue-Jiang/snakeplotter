FROM rocker/shiny
MAINTAINER Yue Jiang (rivehill@gmail.com)


## install packages from CRAN (and clean up)
RUN Rscript -e "install.packages(c('ggplot2','shinyjs','colourpicker'), repos='https://cran.rstudio.com/')" \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


COPY app/ /srv/shiny-server/snakeplotter/