FROM blang/latex:ctanfull
RUN apt-get update && apt-get install python-pygments -y --no-install-recommends
