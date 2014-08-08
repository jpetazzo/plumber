FROM ubuntu
ADD run.sh /
ENTRYPOINT [ "/run.sh" ]
