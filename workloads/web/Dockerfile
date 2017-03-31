FROM    ubuntu

# Install python3
RUN     apt-get update
RUN     apt-get install -y python3
RUN	apt install -y iproute2
RUN	apt install -y iputils-ping
RUN	apt install -y net-tools
RUN	apt install -y ethtool
RUN	apt install -y tcpdump
RUN	mv /usr/sbin/tcpdump /usr/bin/tcpdump

# Copy html
#ADD static/ /src
#RUN cd /src

# Run http server on port 80
EXPOSE  80
CMD ["python3", "-m", "http.server", "80"]
