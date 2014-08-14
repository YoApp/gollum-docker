FROM ubuntu:14.04
MAINTAINER Zach Latta <zach@zachlatta.com>

# dependencies
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get update && apt-get install -y git curl zlib1g-dev build-essential \
  libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev \
  libxslt1-dev libcurl4-openssl-dev python-software-properties

# rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# ruby 2.1.1
RUN rbenv install 2.1.1
RUN rbenv global 2.1.1

# don't install documentation
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

RUN gem install gollum asciidoc creole redcarpet github-markdown org-ruby \
  docutils redcloth wikicloth && rbenv rehash

EXPOSE 4567
VOLUME /data
RUN git init /data

CMD ["gollum", "/data"]
