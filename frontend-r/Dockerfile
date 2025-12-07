FROM rocker/shiny:4.4.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('httr2', 'log4r'), repos='https://cloud.r-project.org/')"

COPY app.R /srv/shiny-server/app/app.R
RUN chown -R shiny:shiny /srv/shiny-server/app

# Set API_URL globally for all R processes
RUN echo 'API_URL=http://api:8080/predict' >> /usr/local/lib/R/etc/Renviron.site

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
