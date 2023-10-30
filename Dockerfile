FROM jekyll/jekyll:pages

RUN apk --update add --virtual build_deps \
    build-base ruby-dev libc-dev linux-headers \
  && gem install --verbose --no-document \
    json \
    github-pages \
    jekyll-theme-hydeout \
    webrick \
  && apk del build_deps \
  && apk add git \
  && mkdir -p /usr/src/app \
  && rm -rf /usr/lib/ruby/gems/*/cache/*.gem

WORKDIR /usr/src/app

EXPOSE 4000 80
# CMD jekyll serve -d /_site --watch --force_polling -H 0.0.0.0 -P 4000