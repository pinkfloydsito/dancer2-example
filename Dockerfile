FROM perl:5.38

RUN cpanm Carton
RUN cpanm JSON::MaybeXS
RUN cpanm HTML::Entities
RUN cpanm Plack
RUN cpanm Module::Starter
RUN cpanm WebService::HashiCorp::Vault


WORKDIR /app

COPY . /app

COPY cpanfile cpanfile.snapshot /app/

VOLUME /app/local

ONBUILD RUN carton install

ENV PORT 3000

EXPOSE 3000

CMD ["sh", "-c", "carton exec plackup -R bin/app.psgi --port $PORT" ]

