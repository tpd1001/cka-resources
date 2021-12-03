# docker build -t ubuntu-sleeper .
# docker run ubuntu-sleeper
# docker run -ti --entrypoint=/bin/bash ubuntu-sleeper
FROM ubuntu
RUN ln -s /usr/bin/sleep /usr/bin/nap
# CMD command param1
#  -OR-
# CMD ["command","param1"]
#  -NOT-
# CMD ["command param1"]
# e.g.
# CMD sleep 5
# CMD ["sleep","5"]
ENTRYPOINT ["sleep"]
CMD ["5"]
