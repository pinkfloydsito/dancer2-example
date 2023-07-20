FROM perl:5.38

RUN cpanm Carton
RUN cpanm JSON::MaybeXS
RUN cpanm HTML::Entities
RUN cpanm Plack Test::More

WORKDIR /app

COPY . /app

COPY cpanfile cpanfile.snapshot /app/

RUN carton install

ENV PORT 3000

EXPOSE 3000

CMD ["sh", "-c", "carton exec plackup -R bin/app.psgi --port $PORT" ]

