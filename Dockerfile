FROM perl:5.38

RUN cpanm Carton
RUN cpanm Plack


WORKDIR /app

COPY . /app

COPY cpanfile cpanfile.snapshot /app/

VOLUME /app/local

ONBUILD RUN carton install

ENV PORT 3000

EXPOSE 3000

CMD ["sh", "-c", "carton exec plackup -R bin/app.psgi --port $PORT" ]

