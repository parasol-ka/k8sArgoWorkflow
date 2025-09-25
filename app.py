from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "<h3 style='color: pink; display:flex; justify-content: center; align-items: center; height: 90vh; font-size: 4em;'><b>BONJORNOOOOOOOOOOOOOOO</b></h3>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
