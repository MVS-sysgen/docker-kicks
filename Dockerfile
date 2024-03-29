FROM mainframed767/mvsce:2.0.3 as builder
COPY *.xmi /XMI/
RUN unset LD_LIBRARY_PATH && apt-get update && apt-get install -yq git python3-pip
WORKDIR /MVSCE/DASD/
RUN dasdinit -a kicks0.3350 3350 111111 
WORKDIR /workdir
RUN pip3 install ebcdic requests automvs
COPY * /workdir/
RUN python3 -u install_kicks.py -d -m /MVSCE
RUN echo "" >> /MVSCE/conf/local.cnf && \
    echo "0351    3350    DASD/kicks0.3350" >> /MVSCE/conf/local.cnf

FROM mainframed767/mvsce:2.0.3
COPY --from=builder /MVSCE /MVSCE
