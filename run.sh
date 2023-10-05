docker run -d \
      	--name=kicks \
      	-e HUSER=docker \
      	-e HPASS=docker \
      	-p 2121:21 \
      	-p 2323:23 \
      	-p 3270:3270 \
      	-p 3505:3505 \
      	-p 3506:3506 \
      	-p 8888:8888 \
        -v ~/kicks:/config \
        -v ~/kicks/printers:/printers \
        -v ~/kicks/punchcards:/punchcards \
        -v ~/kicks/logs:/logs \
        -v ~/kicks/dasd:/dasd \
        -v ~/kicks/certs:/certs \
      	--restart unless-stopped \
      	mainframed767/kicks:1.5.0
