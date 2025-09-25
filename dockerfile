# FROM ubuntu:latest
# RUN apt-get update 
# RUN apt-get install sl -y

# FROM ubuntu:latest
# RUN apt-get update && apt-get install sl nano -y

# FROM ubuntu:latest
# RUN apt-get update && apt-get install sl nano -y
# WORKDIR /usr/games
# ENTRYPOINT ["./sl" , "-l"]

# FROM ubuntu:latest
# RUN apt-get update && apt-get install sl nano -y

# WORKDIR /usr/games
# COPY script3trains.sh /usr/games
# RUN chmod +x /usr/games/script3trains.sh
# ENV N=3

# ENTRYPOINT ["./script3trains.sh"]

FROM python:3.10-bookworm

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

CMD ["python", "app.py"]
